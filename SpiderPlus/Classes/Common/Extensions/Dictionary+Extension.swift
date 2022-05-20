//
//  Dictionary+Extension.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/17/22.
//

import UIKit

extension Dictionary where Key: Hashable, Value: Any {
    func allKeys() -> [Key] { return Array(keys) }
    func allValues() -> [Value] { return Array(values) }
}
