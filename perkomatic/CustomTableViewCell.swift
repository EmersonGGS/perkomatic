//
//  CustomTableViewCell.swift
//  perkomatic
//
//  Created by Emerson Stewart on 2015-03-03.
//  Copyright (c) 2015 Emerson Stewart. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var friendImg: UIImageView!
    @IBOutlet weak var friendName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func loadItem(#title: String, image: String) {
        friendImg.image = UIImage(named: image)
        friendName.text = title
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
