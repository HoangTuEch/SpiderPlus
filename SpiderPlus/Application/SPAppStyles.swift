//
//  SPAppStyles.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/25/22.
//

import UIKit

struct SPAppStyles {
    static func insertDefaultBackgroundView(to view: UIView) {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor(hex: "#1B2C3D").cgColor,
            UIColor(hex: "#16171A").cgColor
        ]
        let backgroundView = BackgroundView(layer: layer)
        view.addSubviewWithFit(backgroundView)
        view.sendSubviewToBack(backgroundView)
    }

    static func insertWalkthroughBackgroundView(to view: UIView) {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor(hex: "#387AC6").cgColor,
            UIColor(hex: "#16171A").cgColor
        ]
        layer.endPoint = CGPoint(x: 0.5, y: 0.5)
        let backgroundView = BackgroundView(layer: layer)
        view.addSubviewWithFit(backgroundView)
        view.sendSubviewToBack(backgroundView)
    }

    static func insertButtonBackgroundView(to view: UIView) {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor(hex: "#1FAAB3").withAlphaComponent(0.99).cgColor,
            UIColor(hex: "#1F85B3").withAlphaComponent(0.98).cgColor
        ]
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 0.98, y: 0.5)
        let backgroundView = BackgroundView(layer: layer)
        view.addSubviewWithFit(backgroundView)
        view.sendSubviewToBack(backgroundView)
    }

    class BackgroundView: UIView {
        convenience init(layer: CALayer) {
            self.init(frame: .zero)
            self.layer.addSublayer(layer)
            isUserInteractionEnabled = false
        }

        override func layoutSubviews() {
            layer.frame = bounds
            layer.sublayers?.forEach {$0.frame = bounds}
        }
    }
}
