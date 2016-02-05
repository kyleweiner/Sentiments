//
//  SentimentAnalysisHeaderView.swift
//  Created by Kyle Weiner on 2/4/16.
//

import UIKit

class SentimentAnalysisHeaderView: UIView {
    @IBOutlet weak var sentimentIcon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        addDividerLayer()
    }

    private func addDividerLayer() {
        // Adds a divider `CAShapeLayer` to the view.
        let height: CGFloat = 0.5
        let horizontalPadding: CGFloat = 15

        let screenWidth = UIScreen.mainScreen().bounds.width
        let origin = CGPointMake(horizontalPadding, frame.height - height)
        let size = CGSizeMake(screenWidth - horizontalPadding - origin.x, height)

        let dividerLayer = CAShapeLayer()
        dividerLayer.path = UIBezierPath(rect: CGRect(origin: origin, size: size)).CGPath
        dividerLayer.fillColor = UIColor.grey500Color().CGColor

        layer.addSublayer(dividerLayer)
    }
}