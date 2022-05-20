//
//  SPHelpers.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/18/22.
//

import Foundation
import UIKit
import SwiftyJSON

// Define log function - start
func DEBUGLog(_ message: String,
              file: String = #file,
              line: Int = #line,
              function: String = #function) {
    #if DEBUG
        let fileURL = NSURL(fileURLWithPath: file)
        let fileName = fileURL.deletingPathExtension?.lastPathComponent ?? ""
        print("DEBUG: \(Date().dblog()) \(fileName)::\(function)[L:\(line)] \(message)")
    #endif
    // Nothing to do if not debugging
}

func ERRORLog(_ message: String,
              file: String = #file,
              line: Int = #line,
              function: String = #function) {
    #if DEBUG
        let fileURL = NSURL(fileURLWithPath: file)
        let fileName = fileURL.deletingPathExtension?.lastPathComponent ?? ""
        print("ERROR: \(Date().dblog()) \(fileName)::\(function)[L:\(line)] \(message)")
    #endif
    // Nothing to do if not debugging
}

func DEBUGJson(_ value: AnyObject) {
    #if DEBUG
//        if Constants.Debug.jsonResponse {
//            //            print(JSONStringify(value))
//        }
    #endif
}
// Define log function - end

// Define delegate
func appDelegate() -> AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
}
