//
//  UITextField+Extension.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/17/22.
//

import UIKit

extension UITextField {
    func focusTextToEnd() {
        DispatchQueue.main.async(execute: {
            self.selectedTextRange = self.textRange(from: self.endOfDocument, to: self.endOfDocument)
        })
    }
}

class BSMarginLable: UILabel {
    open var spacing: CGFloat = 0

    @IBInspectable open var space: CGFloat = 0 {
        didSet {
            spacing = space
        }
    }

    override func draw(_ rect: CGRect) {
        let insets = UIEdgeInsets.init(top: 0, left: spacing, bottom: 0, right: spacing)
        super.drawText(in: rect.inset(by: insets))
    }
}

class BSMarginTextField: UITextField {
    open var spacing: CGFloat = 0
    fileprivate var insets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)

    @IBInspectable open var space: CGFloat = 0 {
        didSet {
            spacing = space
            insets = UIEdgeInsets.init(top: 0, left: spacing, bottom: 0, right: spacing)
        }
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
}
