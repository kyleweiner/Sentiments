//
//  UIColor+CustomColors.swift
//  Created by Kyle Weiner on 2/4/16.
//

import UIKit

extension UIColor {
    // MARK: - Sentiments

    class func negativeColor() -> UIColor {
        return UIColor(red: 0.957, green: 0.263, blue: 0.212, alpha: 1)
    }

    class func neutralColor() -> UIColor {
        return UIColor(red: 0.012, green: 0.663, blue: 0.957, alpha: 1)
    }

    class func positiveColor() -> UIColor {
        return UIColor(red: 0.545, green: 0.765, blue: 0.29, alpha: 1)
    }

    // MARK: - Grey

    class func grey500Color() -> UIColor {
        return UIColor(white: 0.62, alpha: 1)
    }
}