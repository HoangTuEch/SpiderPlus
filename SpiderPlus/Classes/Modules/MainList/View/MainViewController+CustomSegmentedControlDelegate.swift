//
//  MainViewController+CustomSegmentedControlDelegate.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/19/22.
//

import Foundation

extension MainViewController: CustomSegmentedControlDelegate {
    func didChange(to index: Int) {
        checkOpenTheSpecialView(index: index)
    }

    func checkOpenTheSpecialView(index: Int) {
        guard currentIndex != index else { return }
        switch index {
        case 0:
            addDrawingList()
        case 1:
            addDrawedList()
        case 2:
            addImagesList()
        default:
            break
        }
        currentIndex = index
    }
}
