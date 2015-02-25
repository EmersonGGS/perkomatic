//
//  orderVC.swift
//  perkomatic
//
//  Created by Stewart Emerson on 2/24/15.
//  Copyright (c) 2015 Emerson Stewart. All rights reserved.
//

import Foundation
import UIKit

class orderVC: UIViewController {
    
    override func viewDidLoad() {
        
        //define background color of view
        self.view.backgroundColor = UIColor(red: 241/255.0, green: 241/255.0, blue: 241/255.0, alpha: 1.0)
        
        self.title = "Order"
        
        //Adding navigation button to nav bar
        let menuButton: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        menuButton.frame = CGRectMake(0, 0, 30, 30)
        menuButton.setImage(UIImage(named:"menuIcon.png"), forState: UIControlState.Normal)
        menuButton.addTarget(self, action: "toggleNavMenu:", forControlEvents: UIControlEvents.TouchUpInside)
        
        var leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: menuButton)
        
        self.navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: false)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @IBAction func toggleNavMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
}
