//
//  SPRouter.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/18/22.
//

import UIKit
import Alamofire

enum SPRouter: URLRequestConvertible {
    case login(body: Parameters?)
    case logout
    case getList(body: Parameters?, param: Parameters?)
    case fakeData

    var result: (path: String, method: HTTPMethod, body: Parameters?, params: Parameters?) {
        switch self {
        case .login(let body):
            return ("/login", .post, body, nil)
        case .logout:
            return ("/logout", .post, nil, nil)
        case .getList(let body, let param):
            return ("/getlist", .post, body, param)
        case .fakeData:
            return ("products", .get, nil, nil)
        }
    }

    // MARK: URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
//        let accessToken = "Access token"

        let url: URL =  try SPConstants.baseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(result.path))
        urlRequest.httpMethod = result.method.rawValue

//        urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: SPConstants.HeaderKey.Authorization)
        urlRequest.setValue(SPConstants.HeaderKey.ApplicationJson, forHTTPHeaderField: SPConstants.HeaderKey.ContentType)

        // Body data
        if let body = result.body {
            let bodyData = try JSONSerialization.data(withJSONObject: body, options: [])
            urlRequest.httpBody = bodyData
        }

        if let params = result.params {
            return try URLEncoding.default.encode(urlRequest, with: params)
        }
        return urlRequest
    }
}
