//
//  runnerDashboardVC.swift
//  perkomatic
//
//  Created by Emerson Stewart on 2015-03-23.
//  Copyright (c) 2015 Emerson Stewart. All rights reserved.
//
//
//  notificationsVC.swift
//  perkomatic
//
//  Created by Emerson Stewart on 2015-03-05.
//  Copyright (c) 2015 Emerson Stewart. All rights reserved.
//

import UIKit

class runnerDashboardVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var ordersTable: UITableView!
    override func viewDidLoad() {
        
        var nib = UINib(nibName: "orderItemCell", bundle: nil)
        
        ordersTable.registerNib(nib, forCellReuseIdentifier: "orderItem")
        
        //define background color of view
        self.view.backgroundColor = UIColor(red: 241/255.0, green: 241/255.0, blue: 241/255.0, alpha: 1.0)
        
        self.title = "Runner Dashboard"
        
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell = self.ordersTable.dequeueReusableCellWithIdentifier("orderItem") as UITableViewCell
        
        
        //alternate cell background colour
        if ( indexPath.row % 2 == 0 ){
            cell.backgroundColor = UIColor(red: 248/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1.0)
        }else{
            cell.backgroundColor = UIColor.whiteColor()
        }
        
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
}