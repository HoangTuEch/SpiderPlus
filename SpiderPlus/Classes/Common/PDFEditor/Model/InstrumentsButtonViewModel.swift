//
//  InstrumentsButtonViewModel.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/19/22.
//

import UIKit

struct InstrumentsButtonViewModel {
    let index: Int
    var image: UIImage
    var tintColor: UIColor
    var isSelected: Bool

    mutating func updateIsSelected(_ isSelected: Bool) {
        self.isSelected = isSelected
    }
}
