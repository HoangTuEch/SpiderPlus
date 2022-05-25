//
//  AppScreens.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/25/22.
//

import UIKit

enum AppScreens: String, Screen, CaseIterable {
    case login
    case mainList
    case pdfEditor

    var path: String {
        return rawValue
    }

    var transition: NavigateTransions {
        switch self {
        case .login, .mainList:
            return .replace
        case .pdfEditor:
            return .present
        }
    }

    func createViewController(_ payload: Any?) -> UIViewController {
        switch self {
        case .login:
            return LoginViewController()
        case .mainList:
            let mainVC = MainViewController()
            let navigationController = UINavigationController(rootViewController: mainVC)
            return navigationController
        case .pdfEditor:
            return PDFEditorViewController()
        }
    }
}
