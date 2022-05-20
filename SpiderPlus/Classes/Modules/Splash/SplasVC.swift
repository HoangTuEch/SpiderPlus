//
//  SplasVC.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/18/22.
//

import UIKit

class SplashVC: UIViewController {

    // MARK: - Properties
    private let launchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "sp_splash_screen")
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
    }

    private func initView() {
        self.view.addSubview(self.launchImageView)
        self.launchImageView.translatesAutoresizingMaskIntoConstraints = false
        self.launchImageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.launchImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.launchImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.launchImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
    }
}
