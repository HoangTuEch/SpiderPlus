//
//  AppNavigator.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/25/22.
//

import Foundation

final class AppNavigator: BaseNavigator {

    /// インスタンス
    static let shared = AppNavigator()

    // MARK: - Navigatable

    override var scheme: String {
        return "Spider"
    }

    override var routes: [String] {
        return SystemScreens.allCases.map { $0.rawValue }
            + AppScreens.allCases.map { $0.rawValue }
    }

    override func getScreen(path: String) -> Screen {
        if let screen = AppScreens(rawValue: path) {
            return screen
        }
        return super.getScreen(path: path)
    }

    // MARK: - Initializer

    private override init() {
        super.init()
    }
}
