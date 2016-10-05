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
        transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
    }

    func animateTouchUp() {
        UIView.animate(withDuration: 0.6,
            delay: 0.0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 6.0,
            options: [.allowUserInteraction, .beginFromCurrentState, .curveEaseOut],
            animations: { [unowned self] in
                self.transform = CGAffineTransform.identity
            },
            completion: nil
        )
    }
}
