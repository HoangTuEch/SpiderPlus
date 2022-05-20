//
//  NSObject+Extension.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/18/22.
//

import Foundation

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }

    class var className: String {
        return String(describing: self)
    }
}
