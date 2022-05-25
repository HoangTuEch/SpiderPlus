//
//  BaseRootViewController.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/25/22.
//

import UIKit

open class BaseRootViewController: UIViewController {

    // MARK: - Variables

    /// Current RootViewController
    public var currentRootViewController: UIViewController?

    /// Whether layoutSubViews is finished
    public private(set) var didLayoutSubviews = false

    /// Navigator
    public private(set) var navigator: BaseNavigator!

    private var currentRootNavigationController: UINavigationController? {
        if let current = currentRootViewController as? UINavigationController {
            return current
        } else if let current = currentRootViewController as? UITabBarController,
            let selected = current.selectedViewController as? UINavigationController {
            return selected
        }
        return nil
    }

    // MARK: - Initializer

    public convenience init(navigator: BaseNavigator) {
        self.init(nibName: nil, bundle: nil)
        self.navigator = navigator
        self.navigator.delegate = self
    }
}

// MARK: - Life-Cycle
extension BaseRootViewController {

    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        didLayoutSubviews = true
    }
}

// MARK: - GetViewController
extension BaseRootViewController {

    /// Get the CurrentViewController
    open func currentViewController(from: UIViewController? = nil) -> UIViewController? {
        if let from = from {
            if let presented = from.presentedViewController {
                return currentViewController(from: presented)
            }
            if let nav = from as? UINavigationController {
                if let last = nav.children.last {
                    return currentViewController(from: last)
                }
                return nav
            }
            if let tab = from as? UITabBarController {
                if let selected = tab.selectedViewController {
                    return currentViewController(from: selected)
                }
                return tab
            }
            return from
        } else if let presented = presentedViewController {
            return currentViewController(from: presented)
        } else if let currentRootViewController = currentRootViewController {
            return currentViewController(from: currentRootViewController)
        } else {
            return nil
        }
    }

    open func currentNavigationController(from: UIViewController?) -> UINavigationController? {
        if let from = from {
            if let nav = from as? UINavigationController {
                return nav
            }
            if let navigationController = from.navigationController {
                return navigationController
            }
            if let parent = from.parent {
                return currentNavigationController(from: parent)
            }
            return nil
        } else {
            return currentNavigationController(from: currentViewController(from: from)!)
        }
    }

    open func currentFirstViewControllerOfNavigationController(from: UIViewController?) -> UIViewController? {
        let currentNavigationController = self.currentNavigationController(from: navigationController)
        return currentNavigationController?.viewControllers[0]
    }
}

// MARK: - Navigate
extension BaseRootViewController {

    /// Replace
    public func replaceChildViewController(_ vc: UIViewController) {
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController?.dismiss(animated: false, completion: nil)
        func change() {
            addChild(vc)
            view.addSubviewWithFit(vc.view)
            vc.didMove(toParent: self)
            currentRootViewController = vc
        }

        if let current = currentRootViewController {
            current.willMove(toParent: nil)
            change()
            current.view.removeFromSuperview()
            current.removeFromParent()
        } else {
            change()
        }
    }

    /// Push
    public func pushChildViewController(_ vc: UIViewController, _ fromRoot: Bool, _ animate: Bool) {
        if fromRoot {
            currentRootNavigationController?.pushViewController(vc, animated: animate)
        } else {
            currentNavigationController(from: nil)?.pushViewController(vc, animated: animate)
        }
    }

    /// Pop
    public func popChildViewController(_ result: Any?, _ animate: Bool) {
        currentViewController()?.navigationController?.popViewController(animated: animate)

        func completed() {
            if let current = currentViewController() {
                setBackResultIfCan(vc: current, result: result)
            }
        }

        if let coordinator = currentViewController()?.navigationController?.transitionCoordinator, animate {
            coordinator.animate(alongsideTransition: nil) { _ in
                completed()
            }
        } else {
            completed()
        }
    }

    /// Present
    public func presentChildViewController(_ vc: UIViewController, _ animate: Bool) {
        currentViewController()?.present(vc, animated: animate)
    }

    /// Dismiss
    public func dismisssChildViewController(_ result: Any?, _ animate: Bool, _ completion: (() -> Void)? = nil) {
        currentViewController()?.dismiss(animated: animate, completion: { [weak self] in
            guard let weakSelf = self else { return }
            if let current = weakSelf.currentViewController() {
                weakSelf.setBackResultIfCan(vc: current, result: result)
            }
            completion?()
        })
    }
}

extension BaseRootViewController: BaseNavigatorDelegate {
    func didPushViewController(_ vc: UIViewController, _ fromRoot: Bool, _ animate: Bool) {
        self.pushChildViewController(vc, fromRoot, animate)
    }

    func didPresentViewController(_ vc: UIViewController, _ animate: Bool) {
        self.presentChildViewController(vc, animate)
        // 左上に閉じるボタンを追加
        let buttonDismiss = UIBarButtonItem(barButtonSystemItem: .stop)
        buttonDismiss.action = #selector(dissMissChildView)
        buttonDismiss.target = self
        if let top = (vc as? UINavigationController)?.topViewController {
            top.navigationItem.leftBarButtonItem = buttonDismiss
        } else {
            vc.navigationItem.leftBarButtonItem = buttonDismiss
        }
    }

    @objc private func dissMissChildView() {
        self.dismisssChildViewController(nil, true)
    }

    func didReplaceViewController(_ vc: UIViewController) {
        self.replaceChildViewController(vc)
    }

    func didPopViewController(_ result: Any?, _ animate: Bool) {
        self.popChildViewController(result, animate)
    }

    func didDismissViewController(_ result: Any?, _ animate: Bool) {
        self.dismisssChildViewController(result, animate)
    }
}

// MARK: - Private
extension BaseRootViewController {

    private func setBackResultIfCan(vc: UIViewController, result: Any?) {
        guard let backFromNextHandleable = vc as? BackFromNextHandleable else {
            return
        }
        backFromNextHandleable.onBackFromNext(result)
    }
}
