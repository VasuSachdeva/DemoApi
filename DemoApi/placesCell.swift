//
//  placesCell.swift
//  DemoApi
//
//  Created by MAC on 13/03/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit

class placesCell: UITableViewCell {

	@IBOutlet weak var placeImageview: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var adressLabel: UILabel!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
