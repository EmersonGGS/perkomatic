//
//  manageGroupVC.swift
//  perkomatic
//
//  Created by Emerson Stewart on 2015-02-21.
//  Copyright (c) 2015 Emerson Stewart. All rights reserved.
//

import UIKit

class manageGroupVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var groupTable: UITableView!
    
    var groupsArray : [String] = ["my group 1", "my group 2"]
    
    override func viewDidLoad() {
        
        var nib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        
        groupTable.registerNib(nib, forCellReuseIdentifier: "groupCell")
        
        //define background color of view
        self.view.backgroundColor = UIColor(red: 241/255.0, green: 241/255.0, blue: 241/255.0, alpha: 1.0)
        
        self.title = "Groups"
        
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
        
        return self.groupsArray.count;
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: CustomTableViewCell = self.groupTable.dequeueReusableCellWithIdentifier("groupCell") as CustomTableViewCell
        
        var stringText = String(self.groupsArray[indexPath.row] as NSString)
        println(self.groupsArray)
        
        cell.loadItem(title: stringText, image: "groupIcon.png")
        
        //alternate cell background colour
        if ( indexPath.row % 2 == 0 ){
            cell.backgroundColor = UIColor(red: 248/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1.0)
        }else{
            cell.backgroundColor = UIColor.whiteColor()
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("clicked a cell")
    }

}
