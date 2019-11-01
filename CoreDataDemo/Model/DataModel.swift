//
//  DataModel.swift
//  CoreDataDemo
//
//  Created by Akhilesh Singh on 01/11/19.
//  Copyright © 2019 Akhilesh Singh. All rights reserved.
//

import UIKit
import CoreData

@objc(User)
class User: NSManagedObject, Codable {
	
	enum CodingKeys: String, CodingKey {
		case employeeName = "employee_name"
		case profileImage = "profile_image"
	}

	// MARK: - Core Data Managed Object
	@NSManaged var profileImage: String?
	@NSManaged var employeeName: String?


	// MARK: - Decodable
	required convenience init(from decoder: Decoder) throws {
		guard let codingManagedObjectContext = CodingUserInfoKey.managedObjectContext,
			let managedObjectContext = decoder.userInfo[codingManagedObjectContext] as? NSManagedObjectContext,
			let entity = NSEntityDescription.entity(forEntityName: "User", in: managedObjectContext) else {
				fatalError("Failed to decode")
		}

		self.init(entity: entity, insertInto: managedObjectContext)

		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.profileImage = try container.decodeIfPresent(String.self, forKey: .profileImage)
		self.employeeName = try container.decodeIfPresent(String.self, forKey: .employeeName)
	}

	// MARK: - Encodable
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(profileImage, forKey: .profileImage)
		try container.encode(employeeName, forKey: .employeeName)
	}
}

struct DataModel {

	let employeeName: String
	let profileImage: String

	init(user: User) {
		profileImage = user.profileImage ?? ""
		employeeName = user.employeeName ?? ""
	}
}
