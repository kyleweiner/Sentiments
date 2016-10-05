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

    fileprivate var initialFooterViewHeightConstant: CGFloat!

    fileprivate var sentiment: SentimentType = .neutral

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        initialFooterViewHeightConstant = footerViewHeightConstraint.constant

        configureFooterView()

        // Adds observers to monitor when the keyboard will show or hide.
        // This is necessary to keep `footerView` above the keyboard.
        let defaultCenter = NotificationCenter.default
        defaultCenter.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        defaultCenter.addObserver(self, selector: #selector(keyboardWillhide(_:)), name: .UIKeyboardWillHide, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        textView.becomeFirstResponder()
    }

    // MARK: - UIKeyboard

    func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = (notification as NSNotification).userInfo else { return }

        let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue
        let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey]! as AnyObject).doubleValue

        footerViewHeightConstraint.constant = (keyboardSize?.height)! + initialFooterViewHeightConstant

        UIView.animate(withDuration: animationDuration!, delay: 0, options: [.beginFromCurrentState, .curveLinear], animations: { [unowned self] in
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    func keyboardWillhide(_ notification: Notification) {
        guard let userInfo = (notification as NSNotification).userInfo else { return }

        let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey]! as AnyObject).doubleValue

        footerViewHeightConstraint.constant = initialFooterViewHeightConstant

        UIView.animate(withDuration: animationDuration!, delay: 0, options: [.beginFromCurrentState, .curveLinear], animations: { [unowned self] in
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    // MARK: - SentimentAnalysisFooterView

    fileprivate func configureFooterView() {
        footerView.update(with: sentiment, animated: false)

        footerView.moreButton.touchUpHandler = {
            let url = URL(string: AppConfig.gitHubUrl)!
            UIApplication.shared.openURL(url)
        }

        footerView.doneButton.touchUpHandler = { [unowned self] in
            self.analyzeText()
        }
    }

    // MARK: - Sentiment Analysis

    fileprivate func analyzeText() {
        guard !textView.text.isEmpty else { return }

        // Disables the `doneButton` to prevent extraneous requests.
        footerView.doneButton.isEnabled = false

        var request = SentimentAnalysisRequest(type: .text, parameterValue: textView.text)

        request.successHandler = { [unowned self] response in
            self.handleAnalyzedText(response)
        }

        request.failureHandler = { [unowned self] error in
            self.presentAlert(with: error.localizedDescription)
        }

        request.completionHandler = { [unowned self] in
            self.footerView.doneButton.isEnabled = true
        }

        request.make()
    }

    fileprivate func handleAnalyzedText(_ response: JSON) {
        // Return early if the response has an error.
        guard response["reason"].string == nil else {
            presentAlert(with: response["reason"].string! + ".")
            return
        }

        // Return early if unable to get a valid sentiment from the response.
        guard let
            sentimentName = response["aggregate"]["sentiment"].string,
            let nextSentiment = SentimentType(rawValue: sentimentName) else {
            return
        }

        // Updates the view for the `nextSentiment`.
        sentiment = nextSentiment
        headerView.update(with: sentiment)
        footerView.update(with: sentiment)
        textView.update(with: sentiment, response: response)
    }

    fileprivate func presentAlert(with message: String) {
        let alertController = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )

        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)

        self.present(alertController, animated: true, completion: nil)
    }
}
