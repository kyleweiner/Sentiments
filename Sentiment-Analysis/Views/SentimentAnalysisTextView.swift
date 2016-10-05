//
//  SentimentAnalysisTextView.swift
//  Created by Kyle Weiner on 2/4/16.
//

import UIKit

class SentimentAnalysisTextView: UITextView {
    let defaultAlignment: NSTextAlignment = .center
    let defaultTextColor: UIColor = .black
    let defaultFontSize: CGFloat = 20
    let defaultLineSpacing: CGFloat = 2.5

    override func awakeFromNib() {
        super.awakeFromNib()

        configureView()
    }

    fileprivate func configureView() {
        textContainerInset = UIEdgeInsetsMake(10, 15, 15, 15)

        font = UIFont.systemFont(ofSize: defaultFontSize)
        textAlignment = defaultAlignment
        textColor = defaultTextColor

        layoutManager.delegate = self
    }
}

extension SentimentAnalysisTextView: NSLayoutManagerDelegate {
    func layoutManager(_ layoutManager: NSLayoutManager, lineSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return defaultLineSpacing
    }
}
