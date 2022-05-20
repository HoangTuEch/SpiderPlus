//
//  AppDelegate.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/17/22.
//

import UIKit
import PKHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Initiallize UIWindow
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        let viewController = LoginViewController()
        let navigation = UINavigationController(rootViewController: viewController)
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
        return true
    }
}

extension AppDelegate {
    func showSplashScreen() {
        guard Thread.isMainThread else {
            DispatchQueue.main.async { self.showSplashScreen() }
            return
        }

        if HUD.isVisible { HUD.hide() }
        self.window?.rootViewController = SplashVC()
        self.window?.makeKeyAndVisible()
    }
}
