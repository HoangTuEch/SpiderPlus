//
//  UIBarButtonItemEx.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/25/22.
//

import UIKit

/// - previous: Previous
/// - next: Next
/// - up: Up
/// - down: Down
/// - locate: Locate
/// - trash: Trash
public enum UIBarButtonHiddenItem: Int {
    case previous = 101
    case next     = 102
    case up       = 103
    case down     = 104
    case locate   = 100
    case trash    = 110

    /// - Returns: UIBarButtonSystemitem
    public func convert() -> UIBarButtonItem.SystemItem {
        return UIBarButtonItem.SystemItem(rawValue: self.rawValue)!
    }
}

extension UIBarButtonItem {

    /// - Parameters:
    ///   - item: item
    public convenience init(title: String, style: UIBarButtonItem.Style) {
        self.init(title: title, style: style, target: nil, action: nil)
    }

    /// - Parameters:
    ///   - item: item
    public convenience init(image: UIImage, style: UIBarButtonItem.Style) {
        self.init(image: image, style: style, target: nil, action: nil)
    }

    /// - Parameters:
    ///   - item: item
    public convenience init(barButtonSystemItem item: UIBarButtonItem.SystemItem) {
        self.init(barButtonSystemItem: item, target: nil, action: nil)
    }

    /// - Parameters:
    ///   - item: item
    public convenience init(barButtonHiddenItem item: UIBarButtonHiddenItem) {
        self.init(barButtonSystemItem: item.convert(), target: nil, action: nil)
    }

    /// - Parameters:
    ///   - item: item
    ///   - target: target
    ///   - action: action
    public convenience init(barButtonHiddenItem item: UIBarButtonHiddenItem, target: AnyObject?, action: Selector?) {
        self.init(barButtonSystemItem: item.convert(), target: target, action: action)
    }
}
