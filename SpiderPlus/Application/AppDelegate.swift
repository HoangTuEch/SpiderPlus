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
    static var shared: AppDelegate {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            assertionFailure()
            exit(0)
        }
        return delegate
    }

    var window: UIWindow?

    /// AppRootViewController
    var appRootViewController: AppRootViewController {
        return window!.rootViewController as! AppRootViewController
    }

    /// Navigator
    var navigator: BaseNavigator {
        return AppNavigator.shared
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Initiallize UIWindow
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        let navigation = AppRootViewController(navigator: navigator)
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
