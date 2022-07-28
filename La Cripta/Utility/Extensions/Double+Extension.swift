//
//  CGFloat+Extension.swift
//  La Cripta
//
//  Created by Bagas Ilham on 28/07/22.
//

import UIKit

extension Double {
    func convertToCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.locale = Locale(identifier: "en_US")
        if let str = formatter.string(for: self) {
            return str
        } else {
            return "Error converting to currency"
        }
    }
}
