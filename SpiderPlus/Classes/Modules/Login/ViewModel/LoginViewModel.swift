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
        SPSession.request(SPRouter.fakeData).validate().responseDecodable(of: [ResponseData].self) { response in
            print(response)
        }
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

struct ResponseData: BaseModel {
    let id: Int
    let title: String
    let price: Double
    let welcomeDescription: String
    let category: CategoryData
    let image: String
    let rating: Rating

    enum CodingKeys: String, CodingKey {
        case id, title, price
        case welcomeDescription = "description"
        case category, image, rating
    }
}

enum CategoryData: String, Codable {
    case electronics = "electronics"
    case jewelery = "jewelery"
    case menSClothing = "men's clothing"
    case womenSClothing = "women's clothing"
}

// MARK: - Rating
struct Rating: BaseModel {
    let rate: Double
    let count: Int
}
