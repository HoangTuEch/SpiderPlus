//
//  UILable+Extension.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/17/22.
//

import Foundation
import UIKit

class UnderlinedLabel: UILabel {
    @IBInspectable var showUnderline: Bool = true
    override var text: String? {
        didSet {
            guard let text = text, showUnderline else { return }
            let textRange = NSRange(location: 0, length: text.length)
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: textRange)
            // Add other attributes if needed
            self.attributedText = attributedText
        }
    }
}

@IBDesignable class PaddingLabel: UILabel {
    @IBInspectable var topInset: CGFloat = 0.0
    @IBInspectable var bottomInset: CGFloat = 0.0
    @IBInspectable var leftInset: CGFloat = 0.0
    @IBInspectable var rightInset: CGFloat = 0.0

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }
}

extension UILabel {
    func updateFontSize() {
        guard let text = self.text, !text.isEmpty else {  return  }
        let resultW = text.matches(for: "W")
        if resultW.count >= 15 {
            self.font = UIFont.systemFont(ofSize: 9)
        }
    }
}
