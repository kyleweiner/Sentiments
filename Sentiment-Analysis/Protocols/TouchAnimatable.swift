//
//  TouchAnimatable.swift
//  Created by Kyle Weiner on 2/4/16.
//

import UIKit

protocol TouchAnimatable {
    func animateTouchDown()
    func animateTouchUp()
}

extension TouchAnimatable where Self: UIView {
    func animateTouchDown() {
        transform = CGAffineTransformMakeScale(0.9, 0.9)
    }

    func animateTouchUp() {
        UIView.animateWithDuration(0.6,
            delay: 0.0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 6.0,
            options: [.AllowUserInteraction, .BeginFromCurrentState, .CurveEaseOut],
            animations: { [unowned self] in
                self.transform = CGAffineTransformIdentity
            },
            completion: nil
        )
    }
}
