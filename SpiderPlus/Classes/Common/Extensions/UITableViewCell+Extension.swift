//
//  UITableViewCell+Extension.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/17/22.
//

import UIKit

extension UITableViewCell {
    func removeMargins() {
        // Prevent the cell from inheriting the Table View's margin settings
        self.preservesSuperviewLayoutMargins = false
        // Explictly set your cell's layout margins
        self.layoutMargins = UIEdgeInsets.zero
    }
}
