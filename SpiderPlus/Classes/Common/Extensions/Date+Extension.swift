//
//  Date+Extension.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/18/22.
//

import Foundation
extension Date {
    // Date debug log
    func dblog() -> String {
        return SPConstants.AppFormatters.debugConsoleDateFormatter.string(from: self)
    }

    func searchCustomer() -> String {
        return SPConstants.AppFormatters.searchCustomerDateFormat.string(from: self)
    }

    func currentDate() -> DateComponents {
        let date = Date()
        let calendar = Calendar.current
        return calendar.dateComponents([.year, .month, .day], from: date)
    }

    func allDateOf(month: Int?, year: Int?) -> Int {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        let range = calendar.range(of: .day, in: .month, for: date)
        return range?.count ?? 0
    }

    func stringRepresentation(format: String, timeZone: TimeZone? = .current) -> String? {
        guard !format.isEmpty else {
            return nil
        }

        let dateFormatter = DateFormatter()
        let locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.locale = locale
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = timeZone// TimeZone(identifier: "UTC")
        return dateFormatter.string(from: self)
    }

    /// For show the Japanese Calendar
    func jp_stringRepresentation(format: String) -> String? {
        guard !format.isEmpty else {
            return nil
        }

        let dateFormatter = DateFormatter()
        let locale = Locale(identifier: "ja_JP")
        dateFormatter.locale = locale
        dateFormatter.calendar = Calendar(identifier: .japanese)
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current// TimeZone(identifier: "UTC")
        return dateFormatter.string(from: self)
    }

    func getCurrentDate(with dateFormat: String) -> String {
        let date = Date()
        let locale = Locale(identifier: "en_US_POSIX")
        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone.current// TimeZone(identifier: "UTC")
        return dateFormatter.string(from: date)
    }
}

// MARK: Calculator Date
extension Date {
    func calculatorDate(type: Calendar.Component, value: Int, format: String) -> String? {
        guard let date = Calendar.current.date(byAdding: type, value: value, to: self) else { return nil }
        return date.stringRepresentation(format: format)
    }
}

extension TimeZone {
    static let jpTimeZone = TimeZone(abbreviation: "JST")
    static let vnTimeZone = TimeZone(abbreviation: "WIT")
}
