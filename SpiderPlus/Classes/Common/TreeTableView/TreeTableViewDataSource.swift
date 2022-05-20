//
//  TreeTableViewDataSource.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/19/22.
//

import Foundation

public protocol TreeTableViewDataSource: AnyObject {
  func configureNodes() -> [Node]
}
