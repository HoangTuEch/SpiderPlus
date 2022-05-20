//
//  MainViewController.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/18/22.
//

import UIKit

class MainViewController: BaseViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewCenter: UIView!
    @IBOutlet weak var viewBottom: UIView!

    @IBOutlet weak var interfaceSegmented: CustomSegmentedControl! {
        didSet {
            interfaceSegmented.setButtonTitles(buttonTitles: ["Drawing", "Drawed", "Images"])
            interfaceSegmented.selectorViewColor = .orange
            interfaceSegmented.selectorTextColor = .orange
            interfaceSegmented.delegate = self
        }
    }

    // MARK: - Stored properties
    var currentIndex = 0

    private let drawingListVC = DrawingListViewController(nibName: DrawingListViewController.className, bundle: nil)
    private let drawedListVC = DrawedListViewController(nibName: DrawedListViewController.className, bundle: nil)
    private let imagesListVC = ImagesListViewController(nibName: ImagesListViewController.className, bundle: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addDrawingList()
    }

    // MARK: - Action
    @IBAction func didTapHomeButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func didTapSettingButton(_ sender: UIButton) {
        let viewController = PDFEditorViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    // MARK: - Private
    func addDrawingList() {
        if (getCurrentVCInSpecialContentView() as? DrawingListViewController) != nil {
            return
        }
        self.addChildViewWithDelayTime(drawingListVC)
    }

    func addDrawedList() {
        if (getCurrentVCInSpecialContentView() as? DrawedListViewController) != nil {
            return
        }
        self.addChildViewWithDelayTime(drawedListVC)
    }

    func addImagesList() {
        if (getCurrentVCInSpecialContentView() as? ImagesListViewController) != nil {
            return
        }
        self.addChildViewWithDelayTime(imagesListVC)
    }

    private func addChildViewWithDelayTime(_ viewController: BaseViewController) {
        self.viewCenter.removeAllSubviews()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let weakSelf = self else { return }
            viewController.view.frame = CGRect(x: 0, y: 0, width: weakSelf.viewCenter.width, height: weakSelf.viewCenter.height)
            weakSelf.viewCenter.addSubview(viewController.view)
        }
    }
}

extension MainViewController {
    func getCurrentVCInSpecialContentView() -> BaseViewController? {
        guard let viewC = self.viewCenter else { return nil }

        for childVC in self.children where childVC.view.superview === viewC {
            return childVC as? BaseViewController
        }
        return nil
    }
}
