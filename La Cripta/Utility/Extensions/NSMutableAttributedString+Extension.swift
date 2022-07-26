//
//  NSAttributedString+Extension.swift
//  La Cripta
//
//  Created by Bagas Ilham on 26/07/22.
//

import UIKit

extension NSMutableAttributedString {
    func formatForNewsDescription() -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.lineSpacing = 4
        paragraphStyle.alignment = .justified
        self.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: string.count)
        )
        return self
    }
}
