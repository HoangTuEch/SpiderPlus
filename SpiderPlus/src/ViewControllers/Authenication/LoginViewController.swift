//
//  LoginViewController.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/18/22.
//

import UIKit

class LoginViewController: BaseViewController {

    // MARK: - Stored Properties
    var loginViewModel = LoginViewModel()

    // MARK: - IBOutlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginErrorDescriptionLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        setupButton()
        bindData()
    }

    // MARK: - IBActions
    @IBAction func loginButtonPressed(_ sender: UIButton) {
//        // Here we ask viewModel to update model with existing credentials from text fields
//        loginViewModel.updateDataLogin(username: usernameTextField.text!, password: passwordTextField.text!)
//
//        // Here we check user's credentials input - if it's correct we call login()
//        switch loginViewModel.credentialsInput() {
//        case .correct:
//            login()
//        case .incorrect:
//            return
//        }
//        navigator.navigate(screen: AppScreens.mainList)
        login()
    }

    func bindData() {
        loginViewModel.loginModelInputErrorMessage.bind { [weak self] in
            self?.loginErrorDescriptionLabel.isHidden = false
            self?.loginErrorDescriptionLabel.text = $0
        }

        loginViewModel.isUsernameTextFieldHighLighted.bind { [weak self] in
            if $0 { self?.highlightTextField(self!.usernameTextField)}
        }

        loginViewModel.isPasswordTextFieldHighLighted.bind { [weak self] in
            if $0 { self?.highlightTextField(self!.passwordTextField)}
        }

        loginViewModel.errorMessage.bind {
            guard let errorMessage = $0 else { return }
            // Handle presenting of error message (e.g. UIAlertController)
            self.showAlert(tilte: "Login failed", message: errorMessage)
        }
    }

    private func login() {
        loginViewModel.login()
    }

    private func setupButton() {
        loginButton.layer.cornerRadius = 5
    }

    private func setDelegates() {
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }

    private func highlightTextField(_ textField: UITextField) {
        textField.resignFirstResponder()
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.cornerRadius = 3
    }
}

// MARK: - Text Field Delegate Methods
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
        loginErrorDescriptionLabel.isHidden = true
        usernameTextField.layer.borderWidth = 0
        passwordTextField.layer.borderWidth = 0
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeTextField = nil
    }
}
