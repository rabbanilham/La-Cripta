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
}
