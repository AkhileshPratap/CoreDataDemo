//
//  NetworkManager.swift
//  CoreDataDemo
//
//  Created by Akhilesh Singh on 01/11/19.
//  Copyright © 2019 Akhilesh Singh. All rights reserved.
//

import UIKit
import CoreData

typealias CompletionBlock = (_ success: Bool, _ error: NSError?) -> Void

// MARK: - UserProtocol
protocol UserProtocol {
	var items: [DataModel?]? { get }
	func fetchItems(_ completionBlock: @escaping CompletionBlock)
}

extension UserProtocol {
	var items: [DataModel?]? {
		return items
	}
}

class NetworkManager: UserProtocol {
	
	private static let entityName = "User"
	private let persistentContainer: NSPersistentContainer
	private var completionBlock: CompletionBlock?
	var items: [DataModel?]? = []
	
	init(persistentContainer: NSPersistentContainer) {
		self.persistentContainer = persistentContainer
	}
	
	func fetchItems(_ completion: @escaping CompletionBlock) {
		completionBlock = completion
		loadData()
	}
	
}

private extension NetworkManager {
	
	func parseJSONData(_ jsonData: Data) -> Bool {
		do {
			guard let codingManagedObjectContext = CodingUserInfoKey.managedObjectContext else {
				fatalError("Failed")
			}
			
			// Parse JSON data
			let managedObjectContext = persistentContainer.viewContext
			let decoder = JSONDecoder()
			decoder.userInfo[codingManagedObjectContext] = managedObjectContext
			_ = try decoder.decode([User].self, from: jsonData)
			try managedObjectContext.save()
			
			return true
		} catch let error {
			print(error)
			return false
		}
	}
	
	func fetchSavedData() -> [User]? {
		let managedObjectContext = persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<User>(entityName: NetworkManager.entityName)
		//				let sortDescriptor = NSSortDescriptor(key: "employeeName", ascending: true)
		//				fetchRequest.sortDescriptors = [sortDescriptor]
		do {
			let users = try managedObjectContext.fetch(fetchRequest)
			return users
		} catch let error {
			print(error)
			return nil
		}
	}
	
	func convertViewModels(_ users: [User?]) -> [DataModel?]? {
		return users.map { user in
			if let user = user {
				return DataModel(user: user)
			} else {
				return nil
			}
		}
	}
	
	//MARK: load data from api
	func loadData() {
		
		let urlString = "https://jsonblob.com/api/jsonBlNetworkManagerob/ba89a542-e691-11e9-8b82-55e5c4fb2afb"
		
		guard let url = URL(string: urlString) else {
			completionBlock?(false, nil)
			return
		}
		
		// URLSession
		let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
			
			guard let jsonData = data, error == nil else {
				DispatchQueue.main.async {
					self?.completionBlock?(false, error as NSError?)
				}
				return
			}
			
			if self?.parseJSONData(jsonData) ?? false {
				if let users = self?.fetchSavedData() {
					if let newUsersPage = self?.convertViewModels(users) {
						self?.items?.append(contentsOf: newUsersPage)
					}
				}
				DispatchQueue.main.async {
					self?.completionBlock?(true, nil)
				}
			} else {
				DispatchQueue.main.async {
					self?.completionBlock?(false, nil )
				}
			}
		}
		task.resume()
	}
}
