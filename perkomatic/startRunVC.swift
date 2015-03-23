//
//  startRunVC.swift
//  perkomatic
//
//  Created by Emerson Stewart on 2015-03-14.
//  Copyright (c) 2015 Emerson Stewart. All rights reserved.
//

import UIKit

class startRunVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var startRunTable: UITableView!
    var groupsArray : [String] = []
    var groupSelection: [String] = []
    
    var groupRunName = ""
    
    var acceptBtn = UIButton()
    var declineBtn = UIButton()
    
    override func viewDidLoad() {
        
        var viewWidth = self.view.frame.width
        var viewHeight = self.view.frame.height
        
        var nib = UINib(nibName: "notificationTableCell", bundle: nil)
        
        self.startRunTable.registerNib(nib, forCellReuseIdentifier: "groupRunCell")
        
        super.viewDidLoad()
        
        self.title = "Run"
        
        //Adding navigation button to nav bar
        let menuButton: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        menuButton.frame = CGRectMake(0, 0, 30, 30)
        menuButton.setImage(UIImage(named:"menuIcon.png"), forState: UIControlState.Normal)
        menuButton.addTarget(self, action: "toggleNavMenu:", forControlEvents: UIControlEvents.TouchUpInside)
        
        var leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: menuButton)
        
        self.navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: false)
        
        //define current user
        var currentUser = PFUser.currentUser()
        
        //retrieves current freinds list, alters, then re-uploads
        
        var getGroups = PFQuery(className:"Groups")
        getGroups.whereKey("Members", equalTo:currentUser.username)
        getGroups.whereKey("Active", equalTo:"false")
        getGroups.findObjectsInBackgroundWithBlock{
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                //Utilize "Friends" information as table data
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        
                        //if no friends are found
                        println(object)
                        var groupName = object["Name"] as AnyObject as String
                        
                        
                        self.groupsArray.append(groupName)
                        self.groupSelection.append("Not Selected")
                        
                        //When the query information is updated, reload table
                        self.startRunTable.reloadData()
                    }
                }
            }else {
                // Log details of the failure
                println("Error: \(error) \(error.userInfo!)")
            }
        }
        
        
        //Style and place accept button
        self.acceptBtn   = UIButton.buttonWithType(UIButtonType.System) as UIButton
        self.acceptBtn.frame = CGRectMake(viewWidth/2, viewHeight-60, viewWidth/2, 60)
        self.acceptBtn.titleLabel!.font = UIFont(name: "Raleway-Regular", size: 24)
        self.acceptBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.acceptBtn.backgroundColor = UIColor(red: 32/255.0, green: 179/255.0, blue: 255/255.0, alpha: 1.0)
        self.acceptBtn.setTitle("Start", forState: UIControlState.Normal)
        self.acceptBtn.addTarget(self, action: "createRun:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.acceptBtn)
        
        //Style and place decline button
        self.declineBtn   = UIButton.buttonWithType(UIButtonType.System) as UIButton
        self.declineBtn.frame = CGRectMake(0, viewHeight-60, viewWidth/2, 60)
        self.declineBtn.titleLabel!.font = UIFont(name: "Raleway-Regular", size: 24)
        self.declineBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.declineBtn.backgroundColor = UIColor(red: 231/255.0, green: 76/255.0, blue: 60/255.0, alpha: 1.0)
        self.declineBtn.setTitle("Cancel", forState: UIControlState.Normal)
        self.declineBtn.addTarget(self, action: "cancelRun:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.declineBtn)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @IBAction func toggleNavMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    func cancelRun(sender:UIButton!) {
        self.performSegueWithIdentifier("cancelRun", sender: self)
        println("canceled")
    }
    
    func createRun(sender:UIButton!) {
        
        //init current user variable
        var currentUser = PFUser.currentUser()
        
        var notificationsArray : AnyObject = []
        
        //query for the users/friends within the selected group
        var getGroupMemebers = PFQuery(className:"Groups")
        getGroupMemebers.whereKey("Name", equalTo:self.groupRunName)
        getGroupMemebers.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects.count) scores.")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        object["Active"] = "true"
                        object["CurrentRunner"] = currentUser.username
                        object.saveInBackgroundWithBlock {
                            (success: Bool, error: NSError!) -> Void in
                            if (success) {
                                // The object has been saved.
                            } else {
                                // There was a problem, check error.description
                            }
                        }
                        
                        //Taking each member item and appending them into a local array
                        notificationsArray = object["Members"]
                        var tempNoti : [String] = []
                        for(var i = 0; i < notificationsArray.count; i++){
                            if( currentUser.username != notificationsArray[i] as String){
                                tempNoti.append(notificationsArray[i] as String)
                            }
                            println(tempNoti)
                        }
                        notificationsArray = tempNoti
                        println(notificationsArray)
                        for (var i = 0; i < notificationsArray.count; i++){
                            var notification = PFObject(className:"Notifications")
                            notification["To"] = notificationsArray[i]
                            notification["From"] = self.groupRunName
                            notification["Type"] = "Run Started"
                            notification.saveInBackgroundWithBlock {
                                (success: Bool, error: NSError!) -> Void in
                                if (success) {
                                    // The object has been saved.
                                } else {
                                    // There was a problem, check error.description
                                }
                            }
                        }
                    }
                } else {
                    // Log details of the failure
                    println("Error: \(error) \(error.userInfo!)")
                }
            }
            
        }
        
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.groupsArray.count;
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: notificationTableCell = self.startRunTable.dequeueReusableCellWithIdentifier("groupRunCell") as notificationTableCell
        
        var stringText = String(self.groupsArray[indexPath.row] as NSString)
        println(self.groupsArray)
        
        if(self.groupSelection[indexPath.row] == "Selected"){
            cell.loadItem(stringText, type: self.groupSelection[indexPath.row], typeBG: UIColor(red: 52/255.0, green: 152/255.0, blue: 219/255.0, alpha: 1.0) , image: "groupIcon.png")
        }else{
            cell.loadItem(stringText, type: self.groupSelection[indexPath.row], typeBG: UIColor(red: 162/255.0, green: 162/255.0, blue: 162/255.0, alpha: 1.0) , image: "groupIcon.png")
        }
        
        
        
        //alternate cell background colour
        if ( indexPath.row % 2 == 0 ){
            cell.backgroundColor = UIColor(red: 248/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1.0)
        }else{
            cell.backgroundColor = UIColor.whiteColor()
        }
        
        if cell.typeText.text! == "Added"{
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow();
        
        let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as notificationTableCell;
        
        for(var i = 0; i < self.groupSelection.count; i++){
            self.groupSelection[i] = "Not Selected"
        }
        self.groupSelection[indexPath!.row] = "Selected"
        
        self.groupRunName = self.groupsArray[indexPath!.row]
        
        println(self.groupRunName)
        
        self.startRunTable.reloadData()
        
    }
    
}
