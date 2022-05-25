//
//  AppRootViewController.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/25/22.
//

import UIKit
import Foundation
/// アプリRootViewController
final class AppRootViewController: BaseRootViewController {

    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    private let isLogined: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        SPAppStyles.insertDefaultBackgroundView(to: view)
        navigateToTheScreen()
    }

    func navigateToTheScreen() {
        registerNotificationScreenTransition()
        guard isLogined else {
            navigator.navigate(screen: AppScreens.login, fromRoot: true, animate: true)
            return
        }
        navigator.navigate(screen: AppScreens.mainList)
    }

    func setSignedOut() {
        guard let current = currentViewController() as? BaseViewController else {
            return
        }
        print("=========> \(current)")
    }

    func showLoginScreen() {
        navigator.navigate(screen: AppScreens.login)
    }

    private func registerNotificationScreenTransition() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changeCurrentViewController(_:)),
                                               name: .changeCurrentViewController,
                                               object: nil)
    }

    @objc func changeCurrentViewController(_ notification: Notification) {
        guard let currentVC = self.currentViewController() else { return }
        print("================> \(currentVC)")
    }
}
