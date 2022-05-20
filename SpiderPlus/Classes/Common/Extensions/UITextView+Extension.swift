//
//  UITextView+Extension.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/17/22.
//

import UIKit

extension UITextView {
    func displayHtmlText(_ htmlText: String, textColor: String?) {
        var newHtmlText = ""
        if textColor != nil {
            newHtmlText = "<span style=\"font-family: \(font?.familyName ?? ""); font-size: \(font?.pointSize ?? 0);color:\(textColor!)\">\(htmlText)</span>"
        } else {
            newHtmlText = "<span style=\"font-family: \(font?.familyName ?? ""); font-size: \(font?.pointSize ?? 0)\">\(htmlText)</span>"
        }

        guard let data = newHtmlText.data(using: String.Encoding.unicode) else {
            attributedText = nil
            return
        }
        do {
            let attStr = try NSAttributedString.init(data: data, options: [ NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            attributedText = attStr
        } catch {
            print(error)
        }
    }

    func updateCenterVerticalContent() {
        // Get height of text
        let newSize = self.sizeThatFits(CGSize(width: frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        let heightText = CGSize(width: max(newSize.width, frame.size.width), height: newSize.height).height
        // Update inset
        let top = (self.contentSize.height - heightText) / 2
        guard top > 0 else { return }

//        contentInset = UIEdgeInsetsMake(top, contentInset.left, top, contentInset.right)
        contentOffset.y = -top
    }

    func removeEmDashCharacter() {
        self.text = self.text.removeEmDashCharacter()
    }

    /// Will auto resize the contained text to a font size which fits the frames bounds.
    /// Uses the pre-set font to dynamically determine the proper sizing
    func fitTextToBounds(maximumFontSize: CGFloat) {
        guard let text = text, let currentFont = font else { return }

        var bestFittingFont = UIFont.bestFittingFont(for: text, in: bounds, fontDescriptor: currentFont.fontDescriptor, additionalAttributes: basicStringAttributes)

        bestFittingFont = bestFittingFont.withSize(min(bestFittingFont.pointSize - 1, maximumFontSize))
        font = bestFittingFont
    }

    private var basicStringAttributes: [NSAttributedString.Key: Any] {
        var attribs = [NSAttributedString.Key: Any]()

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = self.textAlignment
        paragraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        attribs[NSAttributedString.Key.paragraphStyle] = paragraphStyle

        return attribs
    }

    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
}

extension UITextField: UITextFieldDelegate {
    private struct AssociatedKey {
        static var limited = "limited"
    }
    var limited: Int {
        get {
            return (objc_getAssociatedObject(self, &AssociatedKey.limited) as? Int) ?? 0
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.limited, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        if self.delegate == nil {
            self.delegate = self
        }
        addTarget(self, action: #selector(textFieldDidEndEditingX(_:)), for: UIControl.Event.editingDidEnd)
    }

    // MARK: - UITextFieldDelegate
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let str = NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string)

        if limited > 0 && str.length > limited {
            return false
        }
        return true
    }

    @objc private func textFieldDidEndEditingX(_ textField: UITextField) {
        textField.text = textField.text?.removeEmDashCharacter()
    }
}

extension UIFont {

    /**
     Will return the best font conforming to the descriptor which will fit in the provided bounds.
     */
    static func bestFittingFontSize(for text: String, in bounds: CGRect, fontDescriptor: UIFontDescriptor, additionalAttributes: [NSAttributedString.Key: Any]? = nil) -> CGFloat {
        let constrainingDimension = min(bounds.width, bounds.height)
        // -10 is text view is set
        let properBounds = CGRect(origin: .zero, size: CGSize(width: bounds.size.width - 10, height: bounds.size.height))
        var attributes = additionalAttributes ?? [:]

        let infiniteBounds = CGSize(width: CGFloat.infinity, height: CGFloat.infinity)
        var bestFontSize: CGFloat = constrainingDimension

        for fontSize in stride(from: bestFontSize, through: 0, by: -0.5) {
            let newFont = UIFont(descriptor: fontDescriptor, size: fontSize)
            attributes[NSAttributedString.Key.font] = newFont

            let currentFrame = text.boundingRect(with: infiniteBounds, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: attributes, context: nil)

            if properBounds.contains(currentFrame) {
                bestFontSize = fontSize
                break
            }
        }
        return bestFontSize
    }

    static func bestFittingFont(for text: String, in bounds: CGRect, fontDescriptor: UIFontDescriptor, additionalAttributes: [NSAttributedString.Key: Any]? = nil) -> UIFont {
        let bestSize = bestFittingFontSize(for: text,
                                              in: CGRect(x: 0,
                                                         y: 0,
                                                         width: bounds.size.width,
                                                         height: bounds.size.height),
                                              fontDescriptor: fontDescriptor,
                                              additionalAttributes: additionalAttributes)
        return UIFont(descriptor: fontDescriptor, size: bestSize)
    }
}
