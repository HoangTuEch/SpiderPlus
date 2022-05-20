//
//  BaseViewController.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/17/22.
//

import UIKit
import PKHUD

class BaseViewController: UIViewController {
    // MARK: - Properties
    var viewWasMoved: Bool = false
    var activeTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    deinit {
        print("deinit viewcontroller : \(self.className)")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)

        // Register KeyBoard Event
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func initView() {
        view.backgroundColor = UIColor(netHex: SPConstants.AppColor.backgroundColor)
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapToHiddenKeyBroad(_:)))
        singleTap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(singleTap)
    }

    @objc private func tapToHiddenKeyBroad(_ sender: UIGestureRecognizer) {
        self.view.endEditing(true)
    }

    @objc func keyboardWillAppear(_ notification: NSNotification) {
        let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue

            var aRect: CGRect = self.view.frame
            aRect.size.height -= keyboardSize!.height

            let activeTextFieldRect: CGRect? = activeTextField?.frame
            let activeTextFieldOrigin: CGPoint? = activeTextFieldRect?.origin

        if let activeTextField = activeTextFieldOrigin {
            if !aRect.contains(activeTextField) {
                self.viewWasMoved = true
                self.view.frame.origin.y -= keyboardSize!.height
            } else {
                self.viewWasMoved = false
            }
        }
    }

    @objc func keyboardWillDisappear(_ notification: NSNotification) {
        if self.viewWasMoved {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    // Configure bottomBar data source.
//    func configureDataSourceForBottomBar() {
//        guard let mainScreen = BSMainViewController.getMainViewCotroller() else {
//            return
//        }
//        mainScreen.reloadBottomDataSource(with: .None, viewController: self)
//    }

    // Select bottom if need
//    func bottomBarDidSelected(at bottomBarIndex: BottomBarIndex) -> Void {
//        // Need to be overridden in subclass.
//    }

    func addToViewController(_ viewController: UIViewController) {
        self.willMove(toParent: viewController)
        viewController.addChild(self)
        viewController.view.addSubview(self.view)
        self.view.makeContraintToFullWithParentView()
        self.didMove(toParent: viewController)
//        self.configureDataSourceForBottomBar()
    }

    func removeFromSuperView() {
//        guard let parentViewController = self.parent else {
//            return
//        }
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
        self.didMove(toParent: nil)

//        if let baseVC = parentViewController as? BSBaseViewController {
//            baseVC.configureDataSourceForBottomBar()
//        }
    }

    func add(to parent: UIViewController) {
        self.willMove(toParent: parent)
        parent.addChild(self)
        parent.view.addSubview(self.view)
        self.view.makeContraintToFullWithParentView()
        self.didMove(toParent: parent)
    }

    func removeChildViewController() {
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
        self.didMove(toParent: nil)
    }

    // MARK: - Extension UIViewController
    func closePopup(_ cancel: Bool) {
//        guard let parentPopupViewController = self.parent as? BSHeaderPopupViewController else { return }
//        parentPopupViewController.close(cancel)
    }

    func closeContentPopup() {
//        guard let parentPopupViewController = self.parent as? BSPopupViewController else {
//            return
//        }
//        parentPopupViewController.hidePopup()
    }

    func hideTopViewController() {
//        guard let children = appDelegate().window?.rootViewController?.children else {
//            return
//        }

//        guard let topVC = children.last as? BSPopupViewController else { return }
//        topVC.removeFromSuperView()
    }
}

extension BaseViewController {
    func showAlert(tilte: String, message: String) {
        let alert = UIAlertController(title: tilte, message: message, preferredStyle: .alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}
