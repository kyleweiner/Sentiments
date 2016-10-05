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

    fileprivate func addDividerLayer() {
        // Adds a divider `CAShapeLayer` to the view.
        let height: CGFloat = 0.5
        let horizontalPadding: CGFloat = 15

        let screenWidth = UIScreen.main.bounds.width
        let origin = CGPoint(x: horizontalPadding, y: frame.height - height)
        let size = CGSize(width: screenWidth - horizontalPadding - origin.x, height: height)

        let dividerLayer = CAShapeLayer()
        dividerLayer.frame = CGRect(origin: origin, size: size)
        dividerLayer.backgroundColor = AppColor.grey500.cgColor

        layer.addSublayer(dividerLayer)
    }
}
