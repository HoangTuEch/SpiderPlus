//
//  UIColor+Extension.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/17/22.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(netHex: Int) {
        self.init(red: (netHex >> 16) & 0xff, green: (netHex >> 8) & 0xff, blue: netHex & 0xff)
    }

    public convenience init(hex: String) {
           let noHashString = hex.replacingOccurrences(of: "#", with: "")
           let scanner: Scanner = Scanner(string: noHashString)
           scanner.charactersToBeSkipped = CharacterSet.symbols

           var rgbValue: UInt64 = 0
           scanner.scanHexInt64(&rgbValue)
           let r = (rgbValue & 0xff0000) >> 16
           let g = (rgbValue & 0xff00) >> 8
           let b = rgbValue & 0xff

           self.init(
               red: CGFloat(r) / 0xff,
               green: CGFloat(g) / 0xff,
               blue: CGFloat(b) / 0xff, alpha: 1
           )
       }
}
