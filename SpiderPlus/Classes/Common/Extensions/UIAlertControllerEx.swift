//
//  UIAlertControllerEx.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/25/22.
//

import Foundation
import UIKit

extension UIAlertController {

    //Set background color of UIAlertController
    func setBackgroundColor(color: UIColor) {
        if let bgView = self.view.subviews.first, let groupView = bgView.subviews.first, let contentView = groupView.subviews.first {
            contentView.backgroundColor = color
        }
    }

    //Set title font and title color
    func setTitlet(font: UIFont?, color: UIColor?) {
        guard let title = self.title else { return }
        let attributeString = NSMutableAttributedString(string: title)
        if let titleFont = font {
            attributeString.addAttributes(
                [NSAttributedString.Key.font: titleFont],
                range: NSRange(location: 0, length: attributeString.string.count))
        }
        if let titleColor = color {
            attributeString.addAttributes(
                [NSAttributedString.Key.foregroundColor: titleColor],
                range: NSRange(location: 0, length: attributeString.string.count))
        }
        self.setValue(attributeString, forKey: "attributedTitle")
    }

    //Set message font and message color
    func setMessage(font: UIFont?, color: UIColor?) {
        guard let message = self.message else { return }
        let attributeString = NSMutableAttributedString(string: message)
        if let messageFont = font {
            attributeString.addAttributes(
                [NSAttributedString.Key.font: messageFont],
                range: NSRange(location: 0, length: attributeString.string.count))
        }
        if let messageColorColor = color {
            attributeString.addAttributes(
                [NSAttributedString.Key.foregroundColor: messageColorColor],
                range: NSRange(location: 0, length: attributeString.string.count))
        }
        self.setValue(attributeString, forKey: "attributedMessage")
    }

    //Set tint color of UIAlertController
    func setTint(color: UIColor) {
        self.view.tintColor = color
    }
}
