//
//  friendsVC.swift
//  perkomatic
//
//  Created by Emerson Stewart on 2015-02-21.
//  Copyright (c) 2015 Emerson Stewart. All rights reserved.
//

import UIKit

class orderVC: UIViewController{
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
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
