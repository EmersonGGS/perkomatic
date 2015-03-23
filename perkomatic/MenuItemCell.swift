//
//  MenuItemCell.swift
//  perkomatic
//
//  Created by Emerson Stewart on 2015-03-20.
//  Copyright (c) 2015 Emerson Stewart. All rights reserved.
//

import UIKit

class MenuItemCell: UITableViewCell {
    @IBOutlet weak var menuIcon: UIImageView!
    @IBOutlet weak var menuItem: UILabel!
    @IBOutlet weak var menuItemCost: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func loadItem(item: String, cost: String, image: String) {
        menuIcon.image = UIImage(named: image)
        menuItem.text = item
        menuItemCost.text = cost
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
