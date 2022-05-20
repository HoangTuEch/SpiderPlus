//
//  DrawingListViewController.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/19/22.
//

import UIKit

class DrawingListViewController: BaseViewController {

    @IBOutlet private weak var drawingTable: TreeTableView!
    private var nodes: [Node] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureTreeTableView()
    }

    // MARK: - Private
    private func configureTreeTableView() {
        drawingTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        drawingTable.treeDataSource = self
        drawingTable.treeDelegate = self
        drawingTable.tableFooterView = UIView()
    }
}
