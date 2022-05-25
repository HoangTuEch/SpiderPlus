//
//  ErrorEx.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/25/22.
//

import Foundation

extension Error {
    var errorCode: Int? {
        return (self as NSError).code
    }

    var errorDomainMessage: String? {
        return (self as NSError).domain
    }

    var errorMessage: String? {
        return (self as NSError).localizedDescription
    }
}
