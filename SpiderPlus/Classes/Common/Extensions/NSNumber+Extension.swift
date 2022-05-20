//
//  NSNumber+Extension.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/17/22.
//

import UIKit

extension NSNumber {
    func string(numberStyle: NumberFormatter.Style = .decimal, maximumFractionDigits: Int = 2) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = numberStyle
        formatter.maximumFractionDigits = maximumFractionDigits
        formatter.locale = Locale(identifier: "ja_JP")
        let outputString = formatter.string(from: self)
        return outputString
    }
}
