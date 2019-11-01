//
//  InfoCell.swift
//  CoreDataDemo
//
//  Created by Akhilesh Singh on 01/11/19.
//  Copyright © 2019 Akhilesh Singh. All rights reserved.
//

import UIKit
import SDWebImage

protocol InfoCellProtocol {
    var title: String { get }
    var profileImage: String { get }
}

class InfoCell: GenericBaseTableViewCell {

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = UIColor.black
            titleLabel.font = UIFont.systemFont(ofSize: 16)
        }
    }

    @IBOutlet weak var cellImageView: UIImageView!

    @IBOutlet weak var bgView: UIView! {
        didSet {
            bgView.layer.borderWidth = 0.8
            bgView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    override func bind() {
        guard let model = self.representedObject as? InfoCellProtocol else { return }

        self.titleLabel.text = model.title
				self.cellImageView.sd_setImage(with: URL(string: model.profileImage), placeholderImage: nil)
    }
    
}
