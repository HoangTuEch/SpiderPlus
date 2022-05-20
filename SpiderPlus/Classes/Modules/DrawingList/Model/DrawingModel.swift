//
//  DrawingModel.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/19/22.
//

import Foundation

struct Category: BaseModel {
  let name: String
  let subcategories: [Category]
}

extension Category {
    static func makeModel() -> [Category] {
        let categories: [Category] = [Category(name: "iOS",
                                             subcategories: [Category(name: "iPhone",
                                                                      subcategories: [Category(name: "iPhone XS", subcategories: []),
                                                                                      Category(name: "iPhone XS Max", subcategories: []),
                                                                                      Category(name: "iPhone XR", subcategories: [])]),
                                                             Category(name: "iPad",
                                                                      subcategories: [Category(name: "iPad (6th generation)", subcategories: []),
                                                                                      Category(name: "iPad Pro (11-inch)", subcategories: []),
                                                                                      Category(name: "iPad Pro (12.9-inch)", subcategories: [])]),
                                                             Category(name: "iPod",
                                                                      subcategories: [Category(name: "iPod touch (6th generation)", subcategories: [])])]),
                                    Category(name: "macOS",
                                             subcategories: [Category(name: "Desktops",
                                                                      subcategories: [Category(name: "iMac",
                                                                                               subcategories: [Category(name: "iMac (Retina 4K, 21.5-inch)",
                                                                                                                        subcategories: []),
                                                                                                               Category(name: "iMac (Retina 5K, 27-inch)",
                                                                                                                        subcategories: []),
                                                                                                               Category(name: "iMac Pro",
                                                                                                                        subcategories: [])]),
                                                                                      Category(name: "Mac mini",
                                                                                               subcategories: [Category(name: "Mac mini",
                                                                                                                        subcategories: [])]),
                                                                                      Category(name: "Mac Pro",
                                                                                               subcategories: [Category(name: "Mac Pro",
                                                                                                                        subcategories: [])])]),
                                                             Category(name: "Notebooks",
                                                                      subcategories: [Category(name: "MacBook",
                                                                                               subcategories: [Category(name: "MacBook",
                                                                                                                        subcategories: [])]),
                                                                                      Category(name: "MacBook Air",
                                                                                               subcategories: [Category(name: "MacBook Air (11-inch)",
                                                                                                                        subcategories: []),
                                                                                                               Category(name: "MacBook Air (13-inch)",
                                                                                                                        subcategories: []),
                                                                                                               Category(name: "MacBook Air (Retina, 13-inch)",
                                                                                                                        subcategories: [])]),
                                                                                      Category(name: "MacBook Pro",
                                                                                               subcategories: [Category(name: "MacBook Pro (13-inch)",
                                                                                                                        subcategories: []),
                                                                                                               Category(name: "MacBook Pro (15-inch)",
                                                                                                                        subcategories: [])])])])]
        return categories
    }
}
