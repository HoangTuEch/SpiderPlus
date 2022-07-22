//
//  Screen.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/25/22.
//

import UIKit

/// Screen protocol
public protocol Screen {

    /// パス
    var path: String { get }

    /// 遷移Transition
    var transition: NavigateTransions { get }

    /// ViewController
    func createViewController(_ payload: Any?) -> UIViewController
}

/// 遷移Transition
///
/// - replace: replace
/// - push: push
/// - present: present
public enum NavigateTransions: String {
    case replace
    case push
    case present
}
