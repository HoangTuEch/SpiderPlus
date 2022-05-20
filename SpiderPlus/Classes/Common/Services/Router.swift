//
//  Router.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/18/22.
//

import UIKit
import Alamofire

enum BSRouter: URLRequestConvertible {
    case login(body: Parameters?)
    case logout

    var result: (path: String, method: HTTPMethod, body: Parameters?, params: Parameters?) {
        switch self {
        case .login(let body):
            return ("", .post, body, nil)
        case .logout:
            return ("", .post, nil, nil)
        }
    }

    // MARK: URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let accessToken = "Access token"

        let url: URL =  try result.path.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(result.path))
        urlRequest.httpMethod = result.method.rawValue

        urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: SPConstants.HeaderKey.Authorization)
        urlRequest.setValue(SPConstants.HeaderKey.ApplicationJson, forHTTPHeaderField: SPConstants.HeaderKey.ContentType)

        // Body data
        let bodyData = try JSONSerialization.data(withJSONObject: result.body ?? Parameters(), options: [])
        urlRequest.httpBody = bodyData

        if let params = result.params {
            return try URLEncoding.default.encode(urlRequest, with: params)
        }
        return urlRequest
    }
}
