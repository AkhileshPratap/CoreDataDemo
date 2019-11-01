//
//  DashboardViewController.swift
//  CoreDataDemo
//
//  Created by Akhilesh Singh on 01/11/19.
//  Copyright © 2019 Akhilesh Singh. All rights reserved.
//
//

import UIKit

class UserViewController: UIViewController {

    // This property is a table view used to show all data of a list
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.separatorStyle = .none
            tableView.estimatedRowHeight = 80
            tableView.rowHeight = UITableView.automaticDimension
            registerCell()
        }
    }

    fileprivate var viewModel: UserInfoViewModel = UserInfoViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupDefaults()
    }

    private func setupDefaults() {
			self.title = "Users"
			viewModel.prepareDataSource()
			viewModel.reloadData = { [weak self] () in
				DispatchQueue.main.async {
					self?.tableView.reloadData()
				}
			}
    }

    private func registerCell() {
        viewModel.allCellTypes().forEach { tableView.registerNib(cell: $0) }
    }

}

extension UserViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSection()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // return if data model nil
        guard let dataModel = viewModel.itemForRow(indexPath: indexPath) else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(cell: dataModel.cellType.self) else { return UITableViewCell() }
        cell.representedObject = dataModel
        return cell
    }
}
