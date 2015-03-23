//
//  orderItemCell.swift
//  perkomatic
//
//  Created by Stewart Emerson on 3/23/15.
//  Copyright (c) 2015 Emerson Stewart. All rights reserved.
//

import UIKit

class orderItemCell: UITableViewCell {
    
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var sugarLabel: UILabel!
    @IBOutlet weak var dairyLabel: UILabel!
    @IBOutlet weak var ordererLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func loadItem(itemName: String, sugarAmount: String, dairyAmount: String, ordererName: String) {
        itemLabel.text = itemName
        sugarLabel.text = sugarAmount
        dairyLabel.text = dairyAmount
        ordererLabel.text = ordererName
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
