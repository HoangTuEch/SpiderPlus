//
//  DrawingListViewModel.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/19/22.
//

import Foundation
class DrawingListViewModel {

    var updateDataList: Observable<Bool> = Observable(false)
    var addNewDataList: Observable<Bool> = Observable(false)
    var categories: [Category] = []

    private var addNewCategory = Category(name: "DatND", subcategories: [])

    func getListCategory() {
        let data = Category.makeModel()
        categories = data
        updateDataList.value = true
    }

    func addNewData() {
        categories.append(addNewCategory)
        addNewDataList.value = true
    }
}
