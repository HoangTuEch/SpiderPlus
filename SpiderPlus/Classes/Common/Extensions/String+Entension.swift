//
//  String+Entension.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/17/22.
//

import UIKit
import Foundation

public func LS(_ key: String, comment: String = "", tableName: String? = nil, bundle: Bundle = Bundle.main, value: String = "") -> String {
    return NSLocalizedString(key, tableName: tableName, bundle: bundle, value: value, comment: comment)
}

extension String {
    public static func isNullOrWhiteSpace(_ string: String?) -> Bool {
        let stringToCheck = (string ?? "").trimmingCharacters(in: .whitespaces)
        if stringToCheck.isEmpty { return true}
        return false
    }

    var image: UIImage? {
        return isEmpty == false ? UIImage(named: self) : nil
    }

    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }

    func localizedString(_ comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }

    static func floatToString(_ value: Float?, numberAfterDot: Int? = nil) -> String {
        var numberAfter = numberAfterDot ?? 1
        let valueExist = value ?? 0

        if String(valueExist).doubleStringIsInt() {
            numberAfter = 0
        }
        return String(format: "%.\(numberAfter)f", valueExist)
    }

    var containsEmoji: Bool {
        return self.unicodeScalars.contains { $0.properties.isEmoji && $0.properties.isEmojiPresentation }
    }

    var trim: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func toDouble() -> Double {
        return Double(self) ?? 0
    }

    func toSpecialDouble() -> Double? {
        return Double(self)
    }

    func toInt64() -> Int64 {
        return Int64(self) ?? 0
    }
    func toInt() -> Int {
        return Int(self) ?? 0
    }

    func toFloat() -> Float {
        return Float(self) ?? 0.0
    }

    func containsCharactersInRegexString(regexString: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: regexString,
                                                options: NSRegularExpression.Options(rawValue: 0))
            let matches = regex.numberOfMatches(in: self,
                                                options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                                range: NSRange(location: 0, length: self.count))
            return (matches > 0)
        } catch let error {
            ERRORLog("Invalid regex: \(error.localizedDescription)")
            return false
        }
    }

    func changeSpecialCharacter() -> String {
        return self.replacingOccurrences(of: "ー", with: "ｰ")
    }

    func convertSpaceFullSizeToHalfSize() -> String {
        return self.replacingOccurrences(of: "　", with: " ")
    }

    func removeEmDashCharacter() -> String {
        return self.replacingOccurrences(of: "—", with: "--")
    }

    var isKanjiCharacters: Bool {
        return self.containsCharactersInRegexString(regexString: "^([一-龯]*)?$")
    }

//    var isCharactersProductName: Bool {
//        return self.containsCharactersInRegexString(regexString: "^(([一-龯ぁ-んァ-ン]|[A-Z]|[a-z]|[0-9]|[-^¥@\\[;:\\],.\\/\\!“#$%&‘()=~\\|`{+\\*}<>?_・ー　 ])*)?$") // " '
//    }

    var isKanaFullWidthCharacters: Bool {
        return self.containsCharactersInRegexString(regexString: "^([ァ-ンヴ]*)?$")
    }

    var isKanaHalfWidthCharacters: Bool {
        return self.containsCharactersInRegexString(regexString: "^([ｧ-ﾝｳﾞｦ]*)?$")
    }

    var isHiraFullWidthCharacters: Bool {
        return self.containsCharactersInRegexString(regexString: "^([ぁ-ん]*)?$")
    }

    var isKanjiOrHiraganaOrKatagana: Bool {
        return self.containsCharactersInRegexString(regexString: "^([一-龯ぁ-んァ-ンヴ]*)?$")
    }

    var isFullAlphabet: Bool {
        return self.containsCharactersInRegexString(regexString: "^([A-ZＡ-Ｚa-zａ-ｚ]*)?$")
    }

    // MARK: - Check character not remember Kana,Hira,Kanji
    var isNotKanaHiraKanji: Bool {
        return !self.containsCharactersInRegexString(regexString: "[ァ-ンぁ-んｧ-ﾝ一-龯ヴｳﾞ]+?")
    }

    var isFullSpecialCharacter: Bool {
        return !self.containsCharactersInRegexString(regexString: "[A-ZＡ-Ｚa-zａ-ｚ0-9０-９ぁ-んｧ-ﾝァ-ンヴｳﾞ]+?")
    }

    var isFullNumber: Bool {
        return self.containsCharactersInRegexString(regexString: "^([0-9０-９]*)?$")
    }

    func isKanjiOrHiraganaOrKataganaOrRomajiOrNumber() -> Bool {
        return self.containsCharactersInRegexString(regexString: "^([一-龯ぁ-んァ-ンヴ]|[A-Z]|[a-z]|[0-9])*?$")
    }

    func isDecimalNumber() -> Bool {
        return self.containsCharactersInRegexString(regexString: "^([1-9]{1}[0-9]*|0{1})(\\.([0-9]+)?)?$")
    }

    func isDecimalNumber(_ preDot: Int, afterDot: Int) -> Bool {
        return self.containsCharactersInRegexString(regexString: "^(([1-9]\\d{0,\(preDot - 1)})|0)(\\.\\d{0,\(afterDot)})?$")
    }

    func isCarNumber() -> Bool {
        return self.containsCharactersInRegexString(regexString: "^(([.]{0,3})([0-9]*))?$")
    }

    func isNumber() -> Bool {
        return self.containsCharactersInRegexString(regexString: "^\\d*$")
    }

    func isAlphabet() -> Bool {
        return self.containsCharactersInRegexString(regexString: "^([A-Z]|[a-z]|[0-9]*)?$")
    }

    func isRomaji() -> Bool {
        return self.containsCharactersInRegexString(regexString: "^([A-Z]|[a-z]*)?$")
    }

    func isPostCode() -> Bool {
        return self.containsCharactersInRegexString(regexString: "^[0-9]{3}+[-][0-9]{4}")
    }

    func isJustAllZero() -> Bool {
        return self.containsCharactersInRegexString(regexString: "^0*$")
    }

    func isValidName(_ withCharacterSet: CharacterSet = SPConstants.CharacterSpecial.characterNotAllowedForName) -> Bool {
        let strToCheck = self.filter { !SPConstants.CharacterSpecial.numberCharacter.contains(String($0)) }

        let range = String(strToCheck).rangeOfCharacter(from: withCharacterSet)
        if let rangeData = range, rangeData.isEmpty == false {
            return false
        }
        return true
    }

    func isDouble(numberAfterDot: Int? = nil) -> Bool {
        let number = numberAfterDot ?? 1
        return self.containsCharactersInRegexString(regexString: "^([0-9]{0,})+(\\.[0-9]{0,\(number)})?$")
    }

    func doubleStringIsInt(numberAfterDot: Int? = nil) -> Bool {
        let number = numberAfterDot ?? 1
        return self.containsCharactersInRegexString(regexString: "^([0-9]{0,})+(\\.[0]{0,\(number)})?$")
    }

    func isValidEmail() -> Bool {
        let emailTest = NSPredicate(format: "SELF MATCHES[c] %@", SPConstants.Regex.emailRegEx)
        return emailTest.evaluate(with: self)
    }

    mutating func addNewLineIfNeed(with text: String) {
        self = (self != "") ? self + "\n" + text : text
    }

    var length: Int {
        return self.count
    }

    var countByteShiftJISEncode: Int {
        var lenghResult = 0
        var tmpString = ""
        for c in self {
            let s = String(c)
            if s.canBeConverted(to: String.Encoding.shiftJIS) {
                tmpString += s
            } else {
                lenghResult += 1
            }
        }

        return (tmpString.data(using: String.Encoding.shiftJIS)?.count ?? 0) + lenghResult
    }

    func dateRepresentation(format: String, useCurrentTimeZone: Bool = false) -> Date? {
        guard !self.isEmpty, !format.isEmpty else {
            return nil
        }

        let dateFormatter = DateFormatter()
        let locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.locale = locale
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = useCurrentTimeZone ? TimeZone.current : TimeZone(identifier: "UTC")

        return dateFormatter.date(from: self)
    }

    // MARK: - Validate product name
    var isSanSearchWithProductName: Bool {
        guard !self.isEmpty else { return false }
        let isContainHira = self.containsCharactersInRegexString(regexString: "[ぁ-ん]+?")
        let isContainKana = self.containsCharactersInRegexString(regexString: "[ｧ-ﾝｳﾞ]+?") || self.containsCharactersInRegexString(regexString: "[ァ-ンヴ]+?")
        let isContainKanji = self.containsCharactersInRegexString(regexString: "[一-龯]+?")

        let isContainHiraKana = isContainHira && isContainKana
        let isContainHiraKanzi = isContainHira && isContainKanji
        let isContainKanaKanzi = isContainKana && isContainKanji

        if isContainHiraKana || isContainHiraKanzi || isContainKanaKanzi {
            // product name invalid
            return true
        }
        return false
    }

    // MARK: - Convert param search procuct name
    // swiftlint:disable cyclomatic_complexity
    func convertParamSearch() -> [String] {
        func convert(str: String, type: CFString, isFullWidth: Bool) -> String {
            let s2 = NSMutableString(string: str)
            var cfRange = CFRangeMake(0, str.count)
            CFStringTransform(s2, &cfRange, type, isFullWidth)
            return String(s2)
        }

        func makeParam(input: [Int: String], type: CFString, isConvert: Bool, isFullWidth: Bool) -> [Int: String] {
            var output: [Int: String] = [:]
            for (key, value) in input {
                var KF = value
                if isConvert {
                    KF = convert(str: value, type: kCFStringTransformHiraganaKatakana, isFullWidth: false)
                }
                output[key] = convert(str: KF, type: type, isFullWidth: isFullWidth)
            }
            return output
        }

        var arrLetter: [String] = []
        var type: Int = 0 // Romaji and special is 0, else is 1
        var string: String = ""
        // Split this String follow group Kana, Hira, Kanji, Romaji
        for char in self {
            if char.description.isNotKanaHiraKanji {
                if type == 0 {
                    string += char.description
                } else {
                    arrLetter.append(string)
                    // reset when currentType != previousType
                    string = ""
                    string += char.description
                }
                type = 0
            } else {
                if type == 1 {
                    string += char.description
                } else {
                    arrLetter.append(string)
                    // reset when currentType != previousType
                    string = ""
                    string += char.description
                }
                type = 1
            }
        }

        arrLetter.append(string)

        // #1: Split value for the Romaji or other
        var dicRomani: [Int: String] = [:]
        var dicOrther: [Int: String] = [:]
        for (index, item) in arrLetter.enumerated() {
            if item.isNotKanaHiraKanji {
                dicRomani[index] = item
            } else {
                dicOrther[index] = item
            }
        }
        // Convert text -> Fullwidth, halfwidth
        let romaniF = makeParam(input: dicRomani, type: kCFStringTransformFullwidthHalfwidth, isConvert: false, isFullWidth: true)
        let romaniH = makeParam(input: dicRomani, type: kCFStringTransformFullwidthHalfwidth, isConvert: false, isFullWidth: false)
        let ortherH = makeParam(input: dicOrther, type: kCFStringTransformHiraganaKatakana, isConvert: true, isFullWidth: true)
        let ortherKF = makeParam(input: dicOrther, type: kCFStringTransformHiraganaKatakana, isConvert: false, isFullWidth: false)
        let ortherKH = makeParam(input: dicOrther, type: kCFStringTransformFullwidthHalfwidth, isConvert: true, isFullWidth: false)

        let arrOrther: [[Int: String]] = [ortherH, ortherKF, ortherKH]
        var outPut: Set<String> = []
        // After convert -> append
        for otherItemList in arrOrther {
            var otherAndRomaF = ""
            var otherAndRomaH = ""
            for index in 0..<arrLetter.count {
                // #2: Index is key by #1
                if let otherItem = otherItemList[index] {
                    otherAndRomaF += otherItem
                    otherAndRomaH += otherItem
                } else {
                    if let romaF = romaniF[index] {
                        otherAndRomaF += romaF
                    }

                    if let romaH = romaniH[index] {
                        otherAndRomaH += romaH
                    }
                }
            }
            outPut.insert(otherAndRomaF)
            outPut.insert(otherAndRomaH)
        }
        return Array(outPut)
    }

    // swiftlint:enable cyclomatic_complexity
    func jp_dateRepresentation(format: String) -> Date? {
        guard !format.isEmpty else {
            return nil
        }

        let dateFormatter = DateFormatter()
        let locale = Locale(identifier: "ja_JP")
        dateFormatter.locale = locale
        dateFormatter.calendar = Calendar(identifier: .japanese)
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current// TimeZone(identifier: "UTC")
        return dateFormatter.date(from: self)
    }

    mutating func japanMoneyFomater() -> String {
        guard self.count > 0 else {
            return ""
        }

        self = self.replacingOccurrences(of: ",", with: "")
        self = self.replacingOccurrences(of: "￥", with: "")
        self = self.replacingOccurrences(of: "¥", with: "")

        if let input = Double(self) {
            // let money: Money = Money(input)
            return input.formatted(withStyle: .decimal, forLocale: japanLocate)
        }
       return ""
    }

    func matches(for regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = self as NSString
            let results = regex.matches(in: self, range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        } catch let error {
            DEBUGLog("invalid regex: \(error.localizedDescription)")
            return []
        }
    }

    // 全角文字→半角文字
    // @param reverse, default is false, if true then convert Halfwidth -> Fullwidth, is false then convert Fullwidth -> Halfwidth
    static func convZenToHan(string: String, range: NSRange? = nil, reverse: Bool = false) -> String {
        var makeRange: NSRange!

        let str = NSMutableString(string: string)

        if let rangeChecking = range {
            makeRange = rangeChecking
        } else {
            makeRange = NSRange(location: 0, length: str.length)
        }

        var cfr = CFRangeMake(makeRange.location == NSNotFound ? kCFNotFound : makeRange.location, makeRange.length)
        CFStringTransform(str, &cfr, kCFStringTransformFullwidthHalfwidth, reverse)
        return str as String
    }

    // String is hira => convert kana and back
    static func converHiraKana(string: String) -> String {

        let isHiraFullWidth = string.isHiraFullWidthCharacters
        let isKanaFullWidth = string.isKanaFullWidthCharacters
        let isKanaHalfWidth = string.isKanaHalfWidthCharacters

        // Required full string same type (`fullWidth Hira` OR `fullWidth Kana` OR `halfWidth Kana`)
        guard isHiraFullWidth || isKanaFullWidth || isKanaHalfWidth else { return string }

        // Is KanaHalfWidth => Convert to kana FullWidth
        let str = NSMutableString(string: isKanaHalfWidth ? convZenToHan(string: string, reverse: true) : string)

        let range = NSRange(location: 0, length: str.length)
        var cfr = CFRangeMake(range.location == NSNotFound ? kCFNotFound : range.location, range.length)

        // Hira <=> Kana
        CFStringTransform(str, &cfr, kCFStringTransformHiraganaKatakana, !isHiraFullWidth)

        return str as String
    }

    func convertHasCharacterKanaFullWidthToHalfWidth() -> String {
        let result = NSMutableString(capacity: self.length)

        for c in self {
            let s = String(c)
            guard s.isKanaFullWidthCharacters else {
                // Keep old
                result.append(s)
                continue
            }

            // Convert half width kana
            let s2 = NSMutableString(string: s)
            var cfRange = CFRangeMake(0, 1)

            CFStringTransform(s2, &cfRange, kCFStringTransformFullwidthHalfwidth, false)
            result.append(s2 as String)
        }
        return result as String
    }

    func substringNumberOnly() -> String {
        return self.map { let str = String($0); return Int(str) != nil ? str : "" }.joined()
    }

    func toNSNumber() -> NSNumber? {
        if let myInteger = Int(self) {
            return NSNumber(value: myInteger)
        }

        if let myFloat = Double(self) {
            return NSNumber(value: myFloat)
        }
        return nil
    }

    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func subString(from: Int) -> String {
        return self[from..<count]
    }

    func subString(to: Int) -> String {
        guard self.count > to else { return self }
        return self[0..<to]
    }

    func subString(from: Int, to: Int) -> String {
        return self[from..<to]
    }

    /// Remove prefix string
    ///
    /// - Parameter value: string need remove
    mutating func removePrefix(value: String) {
        guard self.hasPrefix(value) else { return }
        self.removeSubrange((self.startIndex..<self.index(startIndex, offsetBy: value.length)))
        self.removePrefix(value: value)
    }

    subscript(r: Range<Int>) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
        let endIndex = self.index(self.startIndex, offsetBy: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
}

func fillStringOptional(_ value: String?, defaultValue: String = "-") -> String {
    if let valueString = value, !valueString.isEmpty { return valueString }
    return defaultValue
}

enum ScanResult {
    case scanBarCodeForCustomerCode(String)
    case scanBarCodeForProductCode(String)

    var parseValue: String {
        switch self {
        case .scanBarCodeForCustomerCode(let data):
            // 29(Constant) +SPART customer code (10 digit) + check digit (1)
            if data.length < 13 { return data}
            return data[2..<(data.length - 1)]
        case .scanBarCodeForProductCode(let data):
            return data
        }
    }
}

// MARK: - Check valid string
enum ValidationError: Error {
    case invalidFormat
    case invalidRange
    case invalidValue

    var localizedDescription: String {
        switch self {
        case .invalidFormat:
            return "Valid format faild"
        case .invalidValue:
            return "Valid format value"
        case .invalidRange:
            return "Valid format range"
        }
    }
}

enum Validation {
    case checkDecimaFormatDouble(preDot: Int, afterDot: Int, minValue: Double?, maxValue: Double?)
    case checkDecimaFormatInt64(preDot: Int, afterDot: Int, minValue: Int64?, maxValue: Int64?)
    case checkDecimaFormatInt(preDot: Int, afterDot: Int, minValue: Int?, maxValue: Int?)
    case checkByteShiftJISEncode(maxlength: Int)
}

extension String {
    func checkValidValue(minValue: Double?, maxValue: Double?) -> Bool {
        if let minValue = minValue, self.toDouble() < minValue {
            return false
        }

        if let maxValue = maxValue, self.toDouble() > maxValue {
            return false
        }

        return true
    }

    func checkValidValue(minValue: Int64?, maxValue: Int64?) -> Bool {
        if let minValue = minValue, self.toInt64() < minValue {
            return false
        }

        if let maxValue = maxValue, self.toInt64() > maxValue {
            return false
        }

        return true
    }

    func checkValidValue(minValue: Int?, maxValue: Int?) -> Bool {
        if let minValue = minValue, self.toFloat() < Float(minValue) {
            return false
        }

        if let maxValue = maxValue, self.toFloat() > Float(maxValue) {
            return false
        }

        return true
    }

    func checkValid(with validation: Validation?) -> Bool {
        guard let v = validation else {
            return true
        }

        switch v {
        case .checkDecimaFormatDouble(let preDot, let afterDot, let minValue, let maxValue):
            return self.isDecimalNumber(preDot, afterDot: afterDot) && self.checkValidValue(minValue: minValue, maxValue: maxValue)
        case .checkDecimaFormatInt64(let preDot, let afterDot, let minValue, let maxValue):
            return self.isDecimalNumber(preDot, afterDot: afterDot) && self.checkValidValue(minValue: minValue, maxValue: maxValue)
        case .checkDecimaFormatInt(let preDot, let afterDot, let minValue, let maxValue):
            return self.isDecimalNumber(preDot, afterDot: afterDot) && self.checkValidValue(minValue: minValue, maxValue: maxValue)
        case .checkByteShiftJISEncode(let maxlength):
            return self.countByteShiftJISEncode <= maxlength
        }
    }

    var westernArabicNumeralsOnly: String {
        let pattern = UnicodeScalar("0")..."9"
        return String(unicodeScalars
            .compactMap { pattern ~= $0 ? Character($0) : nil })
    }

    var notificationName: NSNotification.Name {
        return NSNotification.Name(self)
    }
}

// MARK: GetSize
extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}

// MARK: until function
extension String {
    static func + (left: String, intValue: Int?) -> String {
        guard let intValue = intValue else { return left }
        return left + intValue.toString
    }

    static func + (intValue: Int?, right: String) -> String {
        guard let intValue = intValue else { return right }
        return intValue.toString + right
    }

    static func + (lhs: String, rhs: String?) -> String {
        return lhs + (rhs ?? "")
    }

    static func + (lhs: String?, rhs: String) -> String {
        return (lhs ?? "") + rhs
    }
}

extension UnicodeScalar {
    var isEmoji: Bool {
        switch value {
        case 0x1F600...0x1F64F, // Emoticons
        0x1F300...0x1F5FF, // Misc Symbols and Pictographs
        0x1F680...0x1F6FF, // Transport and Map
        0x1F1E6...0x1F1FF, // Regional country flags
        0x2600...0x26FF,   // Misc symbols
        0x2700...0x27BF,   // Dingbats
        0xFE00...0xFE0F,   // Variation Selectors
        0x1F900...0x1F9FF,  // Supplemental Symbols and Pictographs
        127000...127600, // Various asian characters
        65024...65039, // Variation selector
        9100...9300, // Misc items
        8400...8447, // Combining Diacritical Marks for Symbols
        0x3030, 0x2122, 0x00AE, 0x00A9: // add more
            return true

        default: return false
        }
    }
}
