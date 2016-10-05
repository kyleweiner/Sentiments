//
//  SentimentAnalysisFooterView+SentimentHelper.swift
//  Created by Kyle Weiner on 2/4/16.
//

import UIKit

extension SentimentAnalysisFooterView {
    /// Updates the view for the specified `SentimentType`.
    func update(with sentiment: SentimentType, animated: Bool = true) {
        faceImageView.image = sentiment.image

        guard animated else {
            backgroundColor = sentiment.color

            return
        }

        UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState, .curveEaseOut], animations: { [unowned self] in
            self.backgroundColor = sentiment.color
        }, completion: nil)
    }
}
