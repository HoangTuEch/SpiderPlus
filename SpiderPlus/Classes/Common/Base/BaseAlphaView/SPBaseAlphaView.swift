//
//  SPBaseAlphaView.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/17/22.
//

import Foundation
import UIKit

class BSBaseAlphaView: UIView {
    private lazy var alphaView: UIView = {
        var view = UIView()
        view.backgroundColor = .clear
        let gestureAlphaView = UITapGestureRecognizer(target: self, action: #selector (self.alphaViewPress (_:)))
        view.addGestureRecognizer(gestureAlphaView)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initView()
    }

    private func initView() {
        self.addSubview(alphaView)
        alphaView.translatesAutoresizingMaskIntoConstraints = false
        alphaView.topAnchor.constraint(equalTo: self.topAnchor).isActive              = true
        alphaView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive        = true
        alphaView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive      = true
        alphaView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive    = true
    }

    @objc func alphaViewPress(_ sender: UITapGestureRecognizer) {
        // self.removeView()
    }

    func removeView() {
        self.removeFromSuperview()
    }
}
