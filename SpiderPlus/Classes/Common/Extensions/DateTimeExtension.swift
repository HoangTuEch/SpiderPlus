//
//  DateTimeExtension.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/17/22.
//

import UIKit

// MARK: - Date Extension
/* Date Extensions */
public extension Date {

    func isBetween(date date1: Date, andDate date2: Date) -> Bool {
        return date1.compare(self).rawValue * self.compare(date2).rawValue >= 0
    }

    // MARK: - Properties
    var timeStamp: Int64 {
        return Int64(self.timeIntervalSince1970)
    }

    static var now: Date {
        return Date()
    }

    var components: DateComponents {
        let calendar = Calendar.current
        return calendar.dateComponents([.year, .weekOfMonth, .month, .day, .hour, .minute, .second], from: self)
    }

    static func from(_ timeStamp: Double) -> Date {
        let date = Date(timeIntervalSince1970: timeStamp)
        return date
    }

    static func from(_ timeStamp: String) -> Date {
        let interval: TimeInterval = Double(timeStamp) ?? 0
        let date = Date(timeIntervalSince1970: interval)
        return date
    }

    static func from(_ string: String, format: String = "dd/MM/yyyy", timeZone: String = TimeZone.current.identifier) -> Date? {
        if String.isNullOrWhiteSpace(string) { return nil }
        let timeZone: TimeZone = TimeZone(identifier: timeZone)!
        let dateFormat: DateFormatter = DateFormatter()
        dateFormat.timeZone = timeZone
        dateFormat.dateFormat = format
        return dateFormat.date(from: string)
    }

    static func from(_ components: DateComponents) -> Date? {
        let calendar = Calendar.current
        return calendar.date(from: components)
    }

    static func timeStamp(from string: String, format: String = "dd/MM/yyyy", timeZone: String = TimeZone.current.identifier) -> Double {
        let timeZone: TimeZone = TimeZone(identifier: timeZone)!
        let dateFormat: DateFormatter = DateFormatter()
        dateFormat.timeZone = timeZone
        dateFormat.dateFormat = format
        let dateConvert: Date = dateFormat.date(from: string)!
        return dateConvert.timeIntervalSince1970
    }

    func toString(format: String = "dd/MM/yyyy") -> String {
        let dateFormat: DateFormatter = DateFormatter()
        let timeZone: TimeZone = TimeZone.current
        dateFormat.timeZone = timeZone
        dateFormat.dateFormat = format
        return dateFormat.string(from: self)
    }

    func toString(format: String = "dd/MM/yyyy", timeZone: String = TimeZone.current.identifier) -> String {
        let dateFormat: DateFormatter = DateFormatter()
        let timeZone: TimeZone = TimeZone(identifier: timeZone)!
        dateFormat.timeZone = timeZone
        dateFormat.dateFormat = format
        return dateFormat.string(from: self)
    }

    // Operator Overload
    static func - (lhs: Date, rhs: Date) -> DateComponents {
        let calendar = Calendar.current
        return calendar.dateComponents([.year, .weekOfMonth, .month, .day, .hour, .minute, .second], from: lhs, to: rhs)

    }

    static func + (lhs: Date, rhs: Date) -> DateComponents {
        let calendar = Calendar.current
        return calendar.dateComponents([.year, .weekOfMonth, .month, .day, .hour, .minute, .second], from: rhs)
    }
}

// MARK: - Date Components
extension DateComponents {
    public var date: Date {
        let calendar = Calendar.current
        return calendar.date(from: self)!
    }

    // MARK: - Date Component Operator
    public static func - (lhs: DateComponents, rhs: DateComponents) -> DateComponents {
        var result = DateComponents()
        result.year = (lhs.year ?? 0) - (rhs.year ?? 0)
        result.month = (lhs.month ?? 0) - (rhs.month ?? 0)
        result.day = (lhs.day ?? 0) - (rhs.day ?? 0)
        result.hour = (lhs.hour ?? 0) - (rhs.hour ?? 0)
        result.minute = (lhs.minute ?? 0) - (rhs.minute ?? 0)
        result.second = (lhs.minute ?? 0) - (rhs.second ?? 0)
        return result
    }
}
