//
//  SentimentType+Helper.swift
//  Created by Kyle Weiner on 2/4/16.
//

import UIKit

extension SentimentType {
    var color: UIColor {
        switch self {
        case .Negative: return .negativeColor()
        case .Neutral: return . neutralColor()
        case .Positive: return .positiveColor()
        }
    }

    var image: UIImage {
        return UIImage(named: "icon_sentiment_\(self.rawValue)")!
    }
}