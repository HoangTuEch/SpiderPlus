//
//  SPConstants.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/18/22.
//

import UIKit
import Foundation

struct SPConstants {
    static let baseURL = "https://fakestoreapi.com/"

    struct TimeCountDown {
        static let secondInDay      = 24*3600
        static let secondInHour     = 3600
        static let secondInMinute   = 60

        static let maxSecond        = 100*24*3600 // 100*24*3600
    }

    static let appVersion: String = {
        var versionName = ""
        if let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String {
            versionName = appName
        }
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            let versionString = NSLocalizedString("text_version", comment: "") + version
            versionName = versionName.isEmpty ? versionString : versionName + "  " + versionString
        }
        return versionName
    }()

    struct BottomCellSize {
        static let width = 240.0
        static let widthLarge = 300.0
        static let height = 65.0
        static let itemSpace: CGFloat = 0
        static let lineSpace: CGFloat = 0
    }

    struct AppColor {
        static var baseColor = 0x00A03F
        static let backgroundColor = 0xD4D4D4
        static let topBarSelectedColor = 0xf7e9d5
        static let bottomDeleteQuote = 0xbb0000
        static var leftMenuTopbarUnSelectedColor = 0x00a03c
        static var leftMenuTopbarTitleSelectedColor = 0x643c32
        static var leftMenuSubTopbarSelectedColor = 0xd9f1e2
        static let leftMenuSubTopbarTitleSelectedColor = 0x00a03c
    }

    struct AppFormatters {
        static let debugConsoleDateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy年M月d日 HH:mm:ss.SSS"
            formatter.timeZone = TimeZone(identifier: "UTC")!
            return formatter
        }()

        static let baseDateFormate = "HH:mm:ss"
        static let tireMaintenanceDateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy年M月d日 HH時mm分"
            formatter.timeZone = TimeZone.ReferenceType.local
            return formatter
        }()

        static let searchCustomerDateFormat: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy年M月d日"
            formatter.timeZone = TimeZone.ReferenceType.local
            return formatter
        }()

        static let mainFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        static let basicFormat = "yyyy/MM/dd HH:mm:ss"
        static let startAtFormat = "作成日時：yyyy年M月d日 HH:mm"
        static let shortFormat = "yyyy年M月d日"
        static let tireImageDateFormat = "yyyy年M月d日HH時m分"
        static let nomarlFormat = "yyyy-MM-dd"
        static let hourMinuteFormat = "HH時m分"
        static let shortTimeFormat = "HH:mm"
        static let jpShortFormat = "GGy年M月d日"
        static let firstDayOfMonthFormat = "yyyy-MM-'01'"
        static let jpAgeShortFormat = "GG"
        static let longFormat = "yyyy年MM月dd日"
        static let monthYearFormat = "yyyy-MM"
        static let maintenanceDateFormat = "yyyy年M月dd日 HH時mm分"
        static let shortestFormat = "yyyy年M月"
        static let subMainFormat = "yyyy年M月d日 H時m分"
        static let superShortestFormat = "MM/dd"
        static let nextVisitFormat = "yy年M月d日"
        static let nextVisitAroundFormat = "yy年M月d日頃"
        static let carMaintenanceFormat = "yyyy年dd日"
        static let carMaintenancePrint = "yyyy年M月d日頃"
        static let baseFormat = "yyyy年M月d日 HH:mm"
    }

    struct Regex {
        static let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    }

    struct CharacterSpecial {
        static let characterNotAllowedForName: CharacterSet = {
            var characterAllowed: CharacterSet = CharacterSet.letters.union(CharacterSet.punctuationCharacters).union(CharacterSet.whitespaces)
            characterAllowed.insert(charactersIn: "゛-－0123456789０１２３４５６７８９㈱㈲㈹")

            var notAllowCharacter = characterAllowed.inverted

            // Append exception emoji in letters
            notAllowCharacter.insert(charactersIn: "0️⃣1️⃣2️⃣3️⃣4️⃣5️⃣6️⃣7️⃣8️⃣9️⃣#️⃣*️⃣")
            return notAllowCharacter
        }()
        static let numberCharacter = "0123456789０１２３４５６７８９*#"
        static let hyphen = "-"
        static let comma  = ","
    }

    struct HeaderKey {
        static let Accept               = "Accept"
        static let Authorization        = "Authorization"
        static let ContentType          = "Content-Type"
        static let ApplicationJson      = "application/json"
    }

    struct NotificationCenterKey {
        static let keyBoardViewWillShow                                      = "KeyBoardViewWillShow"
        static let keyBoardViewWillHide                                      = "keyBoardViewWillHide"
    }
}
