//
//  LoginViewModel.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/18/22.
//

import Foundation
import UIKit

class LoginViewModel {
    // MARK: - Stored Properties
//    private let loginManager: LoginManager

    // Here our model notify that was updated
    private var loginModel = LoginModel() {
        didSet {
            username = loginModel.username
            password = loginModel.password
        }
    }

    private var username = ""
    private var password = ""

    var loginModelInputErrorMessage: Observable<String> = Observable("")
    var isUsernameTextFieldHighLighted: Observable<Bool> = Observable(false)
    var isPasswordTextFieldHighLighted: Observable<Bool> = Observable(false)
    var errorMessage: Observable<String?> = Observable(nil)

//    init(loginManager: LoginManager) {
//        self.loginManager = loginManager
//    }

    // Here we update our model
    func updateDataLogin(username: String, password: String, otp: String? = nil) {
        loginModel.username = username
        loginModel.password = password
    }

    func login() {
//        loginManager.loginWithCredentials(username: username, password: password) { [weak self] (error) in
//            guard let error = error else {
//                return
//            }
//
//            self?.errorMessage.value = error.localizedDescription
//        }
    }

    func credentialsInput() -> CredentialsInputStatus {
        if username.isEmpty && password.isEmpty {
            loginModelInputErrorMessage.value = "Please provide username and password."
            return .incorrect
        }
        if username.isEmpty {
            loginModelInputErrorMessage.value = "Username field is empty."
            isUsernameTextFieldHighLighted.value = true
            return .incorrect
        }
        if password.isEmpty {
            loginModelInputErrorMessage.value = "Password field is empty."
            isPasswordTextFieldHighLighted.value = true
            return .incorrect
        }
        return .correct
    }
}

extension LoginViewModel {
    enum CredentialsInputStatus {
        case correct
        case incorrect
    }
}
