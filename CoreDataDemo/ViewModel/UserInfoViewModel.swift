//
//  UserInfoViewModel.swift
//  CoreDataDemo
//
//  Created by Akhilesh Singh on 01/11/19.
//  Copyright © 2019 Akhilesh Singh. All rights reserved.
//

import UIKit

protocol GenericTableViewBaseModel {
	var cellType: GenericBaseTableViewCell.Type { get set }
}

class UserInfoViewModel: NSObject {

	private var dataSource: [GenericTableViewBaseModel] = []
	private var service: UserProtocol?
	var dataList: [DataModel] = []
	var reloadData: (()->())?

	// MARK: - Helper
	public func numberOfSection() -> Int {
		return 1
	}

	/// get number of rows
	public func numberOfRows(section: Int) -> Int {
		return dataSource.count
	}

	public func itemForRow(indexPath: IndexPath) -> GenericTableViewBaseModel? {
		if indexPath.row >= dataSource.count {
			return nil
		}
		return dataSource[indexPath.row]
	}

	/// get cell type
	public func allCellTypes() -> [GenericBaseTableViewCell.Type] {
		return [InfoCell.self]
	}

	/// This func is used to prepare data source
	public func prepareDataSource() {
		self.dataSource.removeAll()
		self.dataList.removeAll()
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let networkManager = NetworkManager(persistentContainer: appDelegate.persistentContainer)
		service = networkManager
		service?.fetchItems { [weak self] (success, error) in
			if success {
				guard let dataModels = self?.service?.items else {
					return
				}
				self?.dataList = dataModels as! [DataModel]

				/// get data source
				if let mappedModel = self?.dataList.map({CellModel(cellType: InfoCell.self, dataModel: $0)}) {
					self?.dataSource.append(contentsOf: mappedModel)
				}
				self?.reloadData?()
			}
		}
	}

}

class CellModel: InfoCellProtocol, GenericTableViewBaseModel {

	var cellType: GenericBaseTableViewCell.Type
	var title: String = ""
	var profileImage: String = ""

	init(cellType: GenericBaseTableViewCell.Type) {
		self.cellType = cellType
	}

	convenience init(cellType: GenericBaseTableViewCell.Type, dataModel: DataModel) {
		self.init(cellType: cellType)
		self.title = dataModel.employeeName.capitalized
		self.profileImage = dataModel.profileImage
	}
	
}
