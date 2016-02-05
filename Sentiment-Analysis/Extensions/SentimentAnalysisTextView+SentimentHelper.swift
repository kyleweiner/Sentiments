//
//  SentimentAnalysisTextView+SentimentHelper.swift
//  Created by Kyle Weiner on 2/4/16.
//

import UIKit
import SwiftyJSON

extension SentimentAnalysisTextView {
    /// Updates the view with the `SentimentType` and analyzed text response.
    func updateWithSentiment(sentiment: SentimentType, response: JSON) {
        // Hides the view, processes the text and then shows the view.
        UIView.animateWithDuration(0.3, delay: 0, options: [.BeginFromCurrentState, .CurveEaseOut], animations: {
            [unowned self] in
            self.alpha = 0
        }) {
            [unowned self] finished in
            self.normalizeText()
            self.highlightTextWithResponse(response)
            self.tintColor = sentiment.color

            UIView.animateWithDuration(0.6, delay: 0, options: .CurveEaseOut, animations: {
                self.alpha = 1
            }, completion: nil)
        }
    }

    /// Normalizes the text (e.g. removes highlights and resets foreground color)
    func normalizeText() {
        textColor = defaultTextColor

        let normalizedText = NSMutableAttributedString(attributedString: attributedText)
        let range = (text as NSString).rangeOfString(text)
        normalizedText.removeAttribute(NSBackgroundColorAttributeName, range: range)

        attributedText = normalizedText
    }

    /// Highlights the "positive" and "negative" text from the response.
    func highlightTextWithResponse(response: JSON) {
        let highlightedText = NSMutableAttributedString(attributedString: attributedText)

        if let positiveElements = response["positive"].array {
            for element in positiveElements {
                guard let elementText = element["original_text"].string else {
                    continue
                }

                highlightedText.addAttribute(NSForegroundColorAttributeName,
                    value: UIColor.whiteColor(),
                    range: (text as NSString).rangeOfString(elementText)
                )

                highlightedText.addAttribute(NSBackgroundColorAttributeName,
                    value: UIColor.positiveColor(),
                    range: (text as NSString).rangeOfString(elementText)
                )
            }
        }

        if let negativeElements = response["negative"].array {
            for element in negativeElements {
                guard let elementText = element["original_text"].string else {
                    continue
                }

                highlightedText.addAttribute(NSForegroundColorAttributeName,
                    value: UIColor.whiteColor(),
                    range: (text as NSString).rangeOfString(elementText)
                )

                highlightedText.addAttribute(NSBackgroundColorAttributeName,
                    value: UIColor.negativeColor(),
                    range: (text as NSString).rangeOfString(elementText)
                )
            }
        }
        
        self.attributedText = highlightedText
    }
}
