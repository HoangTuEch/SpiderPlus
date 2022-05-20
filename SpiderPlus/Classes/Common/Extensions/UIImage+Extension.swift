//
//  UIImage+Extension.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/17/22.
//

import UIKit

extension UIImage {
    func imageWithColor(tintColor: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        tintColor.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }

    func generateBarcode(from string: String) -> UIImage? {
        guard let filter = CIFilter(name: "CICode128BarcodeGenerator") else { return nil }

        let data = string.data(using: String.Encoding.ascii)
        filter.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 3, y: 3)

        if let output = filter.outputImage?.transformed(by: transform) {
            return UIImage(ciImage: output)
        }
        return nil
    }

    func getScaledImage(with targetSize: CGSize) -> UIImage {
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height

        let ratio = min(widthRatio, heightRatio)

        let newWidth = ratio * size.width
        let newHeight = ratio * size.height

        let frame = CGRect(x: (targetSize.width - newWidth) / 2, y: (targetSize.height - newHeight) / 2, width: newWidth, height: newHeight)

        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)

        draw(in: frame)

        let result = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return result!
    }
}
