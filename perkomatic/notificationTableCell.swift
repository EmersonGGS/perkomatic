//
//  notificationTableCell.swift
//  perkomatic
//
//  Created by Emerson Stewart on 2015-03-05.
//  Copyright (c) 2015 Emerson Stewart. All rights reserved.
//


import UIKit

class notificationTableCell: UITableViewCell {
    @IBOutlet weak var fromText: UILabel!
    @IBOutlet weak var typeText: UILabel!
    @IBOutlet weak var notifImg: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func loadItem(from: String, type: String, typeBG: UIColor, image: String) {
        notifImg.image = UIImage(named: image)
        fromText.text = from
        typeText.backgroundColor = typeBG
        typeText.text = type
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
