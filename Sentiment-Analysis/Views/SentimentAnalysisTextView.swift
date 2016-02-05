//
//  SentimentAnalysisTextView.swift
//  Created by Kyle Weiner on 2/4/16.
//

import UIKit

class SentimentAnalysisTextView: UITextView {
    let defaultAlignment: NSTextAlignment = .Center
    let defaultTextColor: UIColor = .blackColor()
    let defaultFontSize: CGFloat = 20
    let defaultLineSpacing: CGFloat = 2.5

    override func awakeFromNib() {
        super.awakeFromNib()

        configureView()
    }

    private func configureView() {
        textContainerInset = UIEdgeInsetsMake(10, 15, 15, 15)

        font = UIFont.systemFontOfSize(defaultFontSize)
        textAlignment = defaultAlignment
        textColor = defaultTextColor

        layoutManager.delegate = self
    }
}

extension SentimentAnalysisTextView: NSLayoutManagerDelegate {
    func layoutManager(layoutManager: NSLayoutManager, lineSpacingAfterGlyphAtIndex glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return defaultLineSpacing
    }
}