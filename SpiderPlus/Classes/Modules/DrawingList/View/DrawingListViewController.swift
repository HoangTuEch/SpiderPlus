//
//  DrawingListViewController.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/19/22.
//

import UIKit

class DrawingListViewController: BaseViewController {

    // MARK: - Stored Properties
    var drawingListViewModel = DrawingListViewModel()

    // MARK: - IBOutlet
    @IBOutlet private weak var treeTableView: TreeTableView!

    private var nodes: [Node] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateDataList()
        testListTable()
    }

    // MARK: - Private
    private func configureTreeTableView() {
        registerTableViewCells()
        treeTableView.treeDataSource = self
        treeTableView.treeDelegate = self
        treeTableView.tableFooterView = UIView()
    }

    private func registerTableViewCells() {
        let cell = UINib(nibName: "DrawingListCell",
                                  bundle: nil)
        treeTableView.register(cell,
                                forCellReuseIdentifier: "DrawingListCell")
    }

    private func testListTable() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.drawingListViewModel.getListCategory()
        }
    }

    private func updateDataList() {
        drawingListViewModel.updateDataList.bind { [weak self] isSuccess in
            guard isSuccess else { return }
            self?.configureTreeTableView()
        }
    }

    private func addNode(from category: Category) {
        let node = Node(name: category.name)
        nodes.append(node)
        category.subcategories.forEach {
            addSubnodes(from: $0, to: node)
        }
    }

    private func addSubnodes(from category: Category, to parentNode: Node) {
        let node = Node(name: category.name)
        node.parentNode = parentNode
        nodes.append(node)
        category.subcategories.forEach {
            addSubnodes(from: $0, to: node)
        }
    }
}

// MARK: - TreeTableViewDataSource implementationn
extension DrawingListViewController: TreeTableViewDataSource {
    func configureNodes() -> [Node] {
        drawingListViewModel.categories.forEach {
            addNode(from: $0)
        }
        return nodes
    }
}

// MARK: - TreeTableViewDelegate implementationn
extension DrawingListViewController: TreeTableViewDelegate {
    func treeTableView(_ treeTableView: TreeTableView, cellForRowAt indexPath: IndexPath, node: Node) -> UITableViewCell {
        let cell = treeTableView.dequeueReusableCell(withIdentifier: "DrawingListCell", for: indexPath)
        cell.textLabel?.text = node.name
        let inset = 25 * node.depth
        cell.layoutMargins = UIEdgeInsets(top: 0, left: CGFloat(inset), bottom: 0, right: 0)
        return cell
    }

    func treeTableView(_ treeTableView: TreeTableView, didExpandRowAt indexPath: IndexPath, node: Node) {
        treeTableView.deselectRow(at: indexPath, animated: true)
        print("Did expand node '\(node.name)' at indexPath \(indexPath)")
    }

    func treeTableView(_ treeTableView: TreeTableView, didCollapseRowAt indexPath: IndexPath, node: Node) {
        treeTableView.deselectRow(at: indexPath, animated: true)
        print("Did collapse node '\(node.name)' at indexPath \(indexPath)")
    }

    func treeTableView(_ treeTableView: TreeTableView, didSelectRowAt indexPath: IndexPath, node: Node) {
        treeTableView.deselectRow(at: indexPath, animated: true)
        print("Did select node '\(node.name)' at indexPath \(indexPath)")
    }
}
