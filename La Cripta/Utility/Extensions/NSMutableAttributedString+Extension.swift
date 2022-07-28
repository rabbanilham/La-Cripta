//
//  NSAttributedString+Extension.swift
//  La Cripta
//
//  Created by Bagas Ilham on 26/07/22.
//

import UIKit

extension NSMutableAttributedString {
    func addLineSpacing(_ spacing: CGFloat) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.lineSpacing = spacing
        paragraphStyle.alignment = .justified
        self.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: string.count)
        )
        return self
    }
}
