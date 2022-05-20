//
//  NSDecimalNumber+Extension.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/17/22.
//

import Foundation

extension NSDecimalNumber {

    class func spDecimalNumber(with anotherNumber: NSNumber) -> NSDecimalNumber {
        return NSDecimalNumber(decimal: anotherNumber.decimalValue)
    }

    func spAbsoluteValue() -> NSDecimalNumber {
        if self.spIsSmallerThan(NSDecimalNumber.zero) {
            return multiplying(by: NSDecimalNumber(mantissa: 1, exponent: 0, isNegative: true))
        }
        return self
    }

    func spIsGreaterThan(_ anotherNumber: NSNumber) -> Bool {
        return self.compare(anotherNumber) == .orderedDescending
    }

    func spIsEqual(to anotherNumber: NSNumber) -> Bool {
        return self.compare(anotherNumber) == .orderedSame
    }

    func spIsSmallerThan(_ anotherNumber: NSNumber) -> Bool {
        return self.compare(anotherNumber) == .orderedAscending
    }

// Enable after remove pod 'Money'
//    static func >  (left: NSDecimalNumber, right: NSDecimalNumber) -> Bool { return left.bs_isGreaterThan(right) }
//    static func >= (left: NSDecimalNumber, right: NSDecimalNumber) -> Bool { return !left.bs_isSmallerThan(right) }
//    static func <  (left: NSDecimalNumber, right: NSDecimalNumber) -> Bool { return left.bs_isSmallerThan(right) }
//    static func <= (left: NSDecimalNumber, right: NSDecimalNumber) -> Bool { return !left.bs_isGreaterThan(right) }

    // Non-Opt
    static func + (left: NSDecimalNumber, right: NSDecimalNumber) -> NSDecimalNumber { return left.adding(right) }
    static func - (left: NSDecimalNumber, right: NSDecimalNumber) -> NSDecimalNumber { return left.subtracting(right) }
    static func * (left: NSDecimalNumber, right: NSDecimalNumber) -> NSDecimalNumber { return left.multiplying(by: right) }
    static func / (left: NSDecimalNumber, right: NSDecimalNumber) -> NSDecimalNumber { return left.dividing(by: right) }

    static func += (left: inout NSDecimalNumber, right: NSDecimalNumber) { left = left + right }
    static func -= (left: inout NSDecimalNumber, right: NSDecimalNumber) { left = left - right }
    static func *= (left: inout NSDecimalNumber, right: NSDecimalNumber) { left = left * right }
    static func /= (left: inout NSDecimalNumber, right: NSDecimalNumber) { left = left / right }

    // Optional
    static func + (left: NSDecimalNumber?, right: NSDecimalNumber) -> NSDecimalNumber? { return left?.adding(right) }
    static func - (left: NSDecimalNumber?, right: NSDecimalNumber) -> NSDecimalNumber? { return left?.subtracting(right) }
    static func * (left: NSDecimalNumber?, right: NSDecimalNumber) -> NSDecimalNumber? { return left?.multiplying(by: right) }
    static func / (left: NSDecimalNumber?, right: NSDecimalNumber) -> NSDecimalNumber? { return left?.dividing(by: right) }

    static func += (left: inout NSDecimalNumber?, right: NSDecimalNumber) { left = left + right }
    static func -= (left: inout NSDecimalNumber?, right: NSDecimalNumber) { left = left - right }
    static func *= (left: inout NSDecimalNumber?, right: NSDecimalNumber) { left = left * right }
    static func /= (left: inout NSDecimalNumber?, right: NSDecimalNumber) { left = left / right }

    static func < (lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> Bool {
        return lhs.compare(rhs) == .orderedAscending
    }
}

extension LosslessStringConvertible {
    var dcmn: NSDecimalNumber {
        let dcm = NSDecimalNumber(string: String(self))
        return dcm == .notANumber ? .zero : dcm
    }

    func formatted(withStyle: NumberFormatter.Style, forLocale: Locale) -> String {
        let formater = NumberFormatter()
        formater.numberStyle = withStyle
        formater.locale = forLocale
        return formater.string(from: self.dcmn) ?? ""
    }
}

let japanLocate = Locale(identifier: "ja")
