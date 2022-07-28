//
//  UIView+Extension.swift
//  La Cripta
//
//  Created by Bagas Ilham on 26/07/22.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach{
            addSubview($0)
        }
    }
    
    func fadeIn(
        _ duration: TimeInterval = 0.15,
        delay: TimeInterval = 0.0,
        completion: @escaping ((Bool) -> Void) = { (finished: Bool) -> Void in }
    ) {
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: UIView.AnimationOptions.curveEaseIn,
            animations: { self.alpha = 1.0 },
            completion: completion
        )
    }
    
    func fadeOut(
        _ duration: TimeInterval = 0.15,
        delay: TimeInterval = 0.0,
        completion: @escaping (Bool) -> Void = { (finished: Bool) -> Void in}
    ) {
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: UIView.AnimationOptions.curveEaseIn,
            animations: { self.alpha = 0.0 },
            completion: completion
        )
    }
}
