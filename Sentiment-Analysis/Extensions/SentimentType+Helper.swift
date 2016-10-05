//
//  SentimentType+Helper.swift
//  Created by Kyle Weiner on 2/4/16.
//

import UIKit

extension SentimentType {
    var color: UIColor {
        switch self {
        case .negative: return AppColor.negative
        case .neutral: return AppColor.neutral
        case .positive: return AppColor.positive
        }
    }

    var image: UIImage {
        return UIImage(named: "icon_sentiment_\(self.rawValue)")!
    }
}
