//
//  BaseService.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/18/22.
//

import Foundation
import Alamofire
import SwiftyJSON

class SPSession {
    private static var manager: Alamofire.Session = {
        var configuration = URLSessionConfiguration.default
        let delegate = LoggingSessionDelegate()
        let sessionManager = Alamofire.Session(configuration: configuration, delegate: delegate)
        return sessionManager
    }()

    class func request(_ url: URLRequestConvertible) -> DataRequest {
        return manager.request(url)
    }

    class func cancelAllRequest() {
        manager.session.invalidateAndCancel()
    }
 }

class LoggingSessionDelegate: Alamofire.SessionDelegate {

    override func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        #if DEBUG
            logRequest(session, dataTask: dataTask, didReceiveData: data)
            logResponse(session, dataTask: dataTask, didReceiveData: data)
        #endif
        super.urlSession(session, dataTask: dataTask, didReceive: data)
    }

    private func logRequest(_ session: Foundation.URLSession, dataTask: URLSessionDataTask, didReceiveData data: Data) {
        DEBUGLog("Request: " + (dataTask.currentRequest?.url?.absoluteString ?? ""))
        let request = dataTask.currentRequest
        if let headers = request?.allHTTPHeaderFields {
            DEBUGLog("Request Headers: " + headers.description)
        }
        if let bodyStream = request?.httpBodyStream {
            let bodyString = String(data: Data(reading: bodyStream), encoding: .utf8) ?? ""
            DEBUGLog("Request Body: " + bodyString)
        }

        if let httpMethod = request?.httpMethod {
            DEBUGLog("HTTP Request Method:" + httpMethod)
        }
        if let body = request?.httpBody {
            if let stringOutput = NSString(data: body, encoding: String.Encoding.utf8.rawValue) as String? {
                DEBUGLog("Request Body" + stringOutput)
            }
        }
    }

    private func logResponse(_ session: Foundation.URLSession, dataTask: URLSessionDataTask, didReceiveData data: Data) {
        do {
            let dataAsJSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
            if let jsonString = NSString(data: prettyData, encoding: String.Encoding.utf8.rawValue) {
                DEBUGLog("Response: \(jsonString)")
            }
        } catch {
            DEBUGLog("\(error)")
        }
    }
}
