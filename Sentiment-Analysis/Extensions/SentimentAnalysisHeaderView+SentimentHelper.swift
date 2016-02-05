//
//  SentimentAnalysisHeaderView+SentimentHelper.swift
//  Created by Kyle Weiner on 2/5/16.
//

import UIKit

extension SentimentAnalysisHeaderView {
    /// Updates the view for the specified `SentimentType`.
    func updateWithSentiment(sentiment: SentimentType) {
        sentimentIcon.tintColor = sentiment.color
    }
}
