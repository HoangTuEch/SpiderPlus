//
//  BaseNavigator.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/25/22.
//

import UIKit

protocol Navigatable {
    var scheme: String {get}
    var routes: [String] {get}

    func getScreen(path: String) -> Screen
}

protocol BaseNavigatorDelegate: AnyObject {
    func didPushViewController(_ vc: UIViewController, _ fromRoot: Bool, _ animate: Bool)
    func didPresentViewController(_ vc: UIViewController, _ animate: Bool)
    func didReplaceViewController(_ vc: UIViewController)
    func didPopViewController(_ result: Any?, _ animate: Bool)
    func didDismissViewController(_ result: Any?, _ animate: Bool)
}

/// Navigator基底クラス
open class BaseNavigator: Navigatable {

    // MARK: - Variables
    weak var delegate: BaseNavigatorDelegate?

    // MARK: - Initializer

    public init() {
        Navigator.scheme = scheme
        Navigator.routes = routes
        Navigator.handle = { [weak self] location in
            guard let weakSelf = self else { return }
            let animate = location.arguments.keys.contains("Animate")
            let fromRoot = location.arguments.keys.contains("FromRoot")
            var args = location.arguments
            args.removeValue(forKey: "Animate")
            args.removeValue(forKey: "FromRoot")
            let payload: Any?
            if location.payload == nil && !args.isEmpty {
                payload = args
            } else {
                payload = location.payload
            }
            let screen = weakSelf.getScreen(path: location.path)
            let vc = screen.createViewController(payload)
            vc.modalPresentationStyle = .fullScreen
            switch screen.transition {
            case .replace:
                weakSelf.delegate?.didReplaceViewController(vc)
            case .push:
                weakSelf.delegate?.didPushViewController(vc, fromRoot, animate)
            case .present:
                weakSelf.delegate?.didPresentViewController(vc, animate)
            }
        }
    }

    // MARK: - Navigatable

    /// Scheme
    open var scheme: String {
        fatalError("Not implemented")
    }

    /// ルート一覧
    open var routes: [String] {
        fatalError("Not implemented")
    }

    /// スクリーン取得
    open func getScreen(path: String) -> Screen {
        if let screen = SystemScreens(rawValue: path) {
            return screen
        }
        fatalError("Not implemented")
    }
}

// MARK: - Navigate
extension BaseNavigator {

    /// 遷移
    ///
    /// - Parameters:
    ///   - screen: スクリーン
    ///   - payload: ペイロード
    ///   - fromRoot: true:RootのNavigationControllerから遷移 false:カレントのNavigationControllerから遷移
    ///   - animate: アニメーションするかどうか
    public func navigate<T: Screen>(screen: T, payload: Any? = nil, fromRoot: Bool = false, animate: Bool = true) {
        do {
            var arg = [String: String]()
            if fromRoot {
                arg["FromRoot"] = "true"
            }
            if animate {
                arg["Animate"] = "true"
            }
            try Navigator.navigate(location: Location(path: screen.path, arguments: arg, payload: payload))
        } catch {
            fatalError("error")
        }
    }

    /// 遷移
    ///
    /// - Parameter url: URL
    public func navigate(url: URL) {
        do {
            try Navigator.navigate(url: url)
        } catch {
            fatalError("error")
        }
    }

    /// 戻る
    public func popScreen(result: Any? = nil, animate: Bool = true) {
        delegate?.didPopViewController(result, animate)
    }

    /// スクリーンを非表示
    public func dismissScreen(result: Any? = nil, animate: Bool = true) {
        delegate?.didDismissViewController(result, animate)
    }
}
