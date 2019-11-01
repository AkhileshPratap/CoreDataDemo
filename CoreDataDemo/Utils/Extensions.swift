//
//  Extensions.swift
//  CoreDataDemo
//
//  Created by Akhilesh Singh on 01/11/19.
//  Copyright © 2019 Akhilesh Singh. All rights reserved.
//

import UIKit

extension UITableView {

	func dequeueReusableCell<T: UITableViewCell>(cell: T.Type) -> T? {
		return self.dequeueReusableCell(withIdentifier: cell.identifier()) as? T
	}

	func registerNib<T: UITableViewCell>(cell: T.Type) {
		self.register(cell.nibForCell(), forCellReuseIdentifier: cell.identifier())
	}

}

extension UITableViewCell {
	class func nibForCell() -> UINib {
		return UINib(nibName: self.identifier(), bundle: nil)
	}
}

extension UIView {
	/// Return the class of View in string
	class func identifier() -> String {
		return "\(self)"
	}
}

public extension CodingUserInfoKey {
	// Helper property to retrieve the Core Data managed object context
	static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}
