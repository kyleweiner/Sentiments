//
//  SentimentAnalysisViewController.swift
//  Created by Kyle Weiner on 2/4/16.
//

import UIKit
import SwiftyJSON

class SentimentAnalysisViewController: UIViewController {
    @IBOutlet weak var headerView: SentimentAnalysisHeaderView!
    @IBOutlet weak var textView: SentimentAnalysisTextView!
    @IBOutlet weak var footerView: SentimentAnalysisFooterView!
    @IBOutlet weak var footerViewHeightConstraint: NSLayoutConstraint!

    private var initialFooterViewHeightConstant: CGFloat!

    private var sentiment: SentimentType = .Neutral

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        initialFooterViewHeightConstant = footerViewHeightConstraint.constant

        configureFooterView()

        // Adds observers to monitor when the keyboard will show or hide.
        // This is necessary to keep `footerView` above the keyboard.
        let defaultCenter = NSNotificationCenter.defaultCenter()
        defaultCenter.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        defaultCenter.addObserver(self, selector: "keyboardWillhide:", name: UIKeyboardWillHideNotification, object: nil)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        textView.becomeFirstResponder()
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    // MARK: - UIKeyboard

    func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }

        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue
        let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey]!.doubleValue

        footerViewHeightConstraint.constant = keyboardSize.height + initialFooterViewHeightConstant

        UIView.animateWithDuration(animationDuration, delay: 0, options: [.BeginFromCurrentState, .CurveLinear], animations: { [unowned self] in
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    func keyboardWillhide(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }

        let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey]!.doubleValue

        footerViewHeightConstraint.constant = initialFooterViewHeightConstant

        UIView.animateWithDuration(animationDuration, delay: 0, options: [.BeginFromCurrentState, .CurveLinear], animations: { [unowned self] in
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    // MARK: - SentimentAnalysisFooterView

    private func configureFooterView() {
        footerView.updateWithSentiment(sentiment, animated: false)

        footerView.moreButton.touchUpHandler = {
            let url = NSURL(string: AppConfig.gitHubUrl)!
            UIApplication.sharedApplication().openURL(url)
        }

        footerView.doneButton.touchUpHandler = { [unowned self] in
            self.analyzeText()
        }
    }

    // MARK: - Sentiment Analysis

    private func analyzeText() {
        guard !textView.text.isEmpty else { return }

        var request = SentimentAnalysisRequest(type: .Text, parameterValue: textView.text)

        request.successHandler = { [unowned self] response in
            self.handleAnalyzedText(response)
        }

        request.failureHandler = { [unowned self] error in
            self.presentAlert(withErrorMessage: error.localizedDescription)
        }

        // Disables the `doneButton` to prevent extraneous requests.
        footerView.doneButton.enabled = false

        request.completionHandler = { [unowned self] in
            self.footerView.doneButton.enabled = true
        }

        request.makeRequest()
    }

    private func handleAnalyzedText(response: JSON) {
        // Return early if unable the response has an error.
        guard response["reason"].string == nil else {
            presentAlert(withErrorMessage: response["reason"].string! + ".")
            return
        }

        // Return early if unable to get a valid sentiment from the response.
        guard let
            sentimentName = response["aggregate"]["sentiment"].string,
            nextSentiment = SentimentType(rawValue: sentimentName) else {
            return
        }

        // Updates the view for the `nextSentiment`.
        sentiment = nextSentiment
        headerView.updateWithSentiment(sentiment)
        footerView.updateWithSentiment(sentiment)
        textView.updateWithSentiment(sentiment, response: response)
    }

    private func presentAlert(withErrorMessage message: String) {
        let alertController = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .Alert
        )

        let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(alertAction)

        self.presentViewController(alertController, animated: true, completion: nil)
    }
}