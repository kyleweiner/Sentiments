//
//  AppButton.swift
//  Created by Kyle Weiner on 2/4/16.
//

import UIKit

/// A `UIButton` subclass with "springy" touch behavior.

class AppButton: UIButton, TouchAnimatable {
    var touchDownHandler: (Void -> Void)?
    var touchUpHandler: (Void -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }

    // MARK: - User Interaction

    private func setup() {
        adjustsImageWhenHighlighted = false

        addTarget(self, action: "didTouchDown", forControlEvents: [.TouchDown, .TouchDragInside])
        addTarget(self, action: "didTap", forControlEvents: .TouchUpInside)
        addTarget(self, action: "didCancelTouch", forControlEvents: [.TouchCancel, .TouchDragOutside])
    }

    func didTouchDown() {
        animateTouchDown()
        touchDownHandler?()
    }

    func didTouchUp() {
        animateTouchUp()
        touchUpHandler?()
    }

    func didCancelTouch() {
        animateTouchUp()
    }

    func didTap() {
        didTouchUp()
    }
}