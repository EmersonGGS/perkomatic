//
//  notificationsVC.swift
//  perkomatic
//
//  Created by Emerson Stewart on 2015-03-05.
//  Copyright (c) 2015 Emerson Stewart. All rights reserved.
//

import UIKit

class notificationsVC: UIViewController {
    @IBOutlet weak var notificationsTable: UITableView!
    
    //Define user
    var currentUser = PFUser.currentUser()
    
    //Notification Properties
    var notiNameArray : [String] = []
    var notiTypeArray : [String] = []
    var rowSelected = 0
    var acceptedReq = ""
    
    //init views and buttons
    var background = UIView()
    var confirmationView = UIView()
    var userNameLabel = UILabel()
    var fromUserLabel = UILabel()
    var typeLabel = UILabel()
    var acceptBtn = UIButton()
    var declineBtn = UIButton()
    
    override func viewDidLoad() {
        
        var nib = UINib(nibName: "notificationTableCell", bundle: nil)
        
        notificationsTable.registerNib(nib, forCellReuseIdentifier: "notificationCell")
        
        //define background color of view
        self.view.backgroundColor = UIColor(red: 241/255.0, green: 241/255.0, blue: 241/255.0, alpha: 1.0)
        
        self.title = "Notifications"
        
        //Adding navigation button to nav bar
        let menuButton: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        menuButton.frame = CGRectMake(0, 0, 30, 30)
        menuButton.setImage(UIImage(named:"menuIcon.png"), forState: UIControlState.Normal)
        menuButton.addTarget(self, action: "toggleNavMenu:", forControlEvents: UIControlEvents.TouchUpInside)
        
        var leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: menuButton)
        
        self.navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: false)
        
        
        //define current user
        var currentUser = PFUser.currentUser()
        
        ///////////////////////////
        // The Contingency Loop //
        /////////////////////////
        
        //////////////////
        // Initial Loop //
        /////////////////
        var query = PFQuery(className:"Notifications")
        query.whereKey("To", equalTo:currentUser.username)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects.count) scores.")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        var tempNotificationName = object["From"] as String
                        var tempNotificationType = object["Type"] as String
                        
                        self.notiNameArray.append(tempNotificationName as NSString)
                        self.notiTypeArray.append(tempNotificationType as NSString)
                        println(self.notiNameArray)
                        println(self.notiTypeArray)
                    }
                    self.notificationsTable.reloadData()
                }
            } else {
                // Log details of the failure
                println("Error: \(error) \(error.userInfo!)")
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @IBAction func toggleNavMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notiNameArray.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: notificationTableCell = self.notificationsTable.dequeueReusableCellWithIdentifier("notificationCell") as notificationTableCell
        
        var nameText = String(self.notiNameArray[indexPath.row] as NSString)
        var typeText = String(self.notiTypeArray[indexPath.row] as NSString)
        
        if String(self.notiTypeArray[indexPath.row] as NSString) == "Friend Request"{
            cell.loadItem(nameText, type: typeText, typeBG: UIColor(red: 52/255.0, green: 152/255.0, blue: 219/255.0, alpha: 1.0) , image: "friendProfile.png")
        } else {
            cell.loadItem(nameText, type: typeText, typeBG: UIColor(red: 241/255.0, green: 196/255.0, blue: 15/255.0, alpha: 1.0) , image: "groupIcon.png")
        }
        
        
        //alternate cell background colour
        if ( indexPath.row % 2 == 0 ){
            cell.backgroundColor = UIColor(red: 248/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1.0)
        }else{
            cell.backgroundColor = UIColor.whiteColor()
        }
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var frameWidth = self.view.frame.width
        var frameHeight = self.view.frame.height
        
        self.background = UIView(frame: CGRectMake(0, 0, frameWidth, frameHeight))
        self.background.backgroundColor = UIColor(red: 241/255.0, green: 241/255.0, blue: 241/255.0, alpha: 0.85)
        self.view.addSubview(self.background)
        
        self.confirmationView = UIView(frame: CGRectMake(20, 100, 280, 200))
        self.confirmationView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.confirmationView)
        
        self.typeLabel = UILabel(frame: CGRectMake(0, 0, self.confirmationView.frame.width, 35))
        self.typeLabel.backgroundColor = UIColor(red: 26/255.0, green: 188/255.0, blue: 156/255.0, alpha: 1.0)
        self.typeLabel.text = String(self.notiTypeArray[indexPath.row] as NSString)
        self.typeLabel.textAlignment = NSTextAlignment.Center
        self.typeLabel.textColor = UIColor(red: 236/255.0, green: 240/255.0, blue: 241/255.0, alpha: 1.0)
        
        if String(self.notiTypeArray[indexPath.row] as NSString) == "Friend Request"{
            self.typeLabel.backgroundColor = UIColor(red: 52/255.0, green: 152/255.0, blue: 219/255.0, alpha: 1.0)
        }else{
            self.typeLabel.backgroundColor = UIColor(red: 241/255.0, green: 196/255.0, blue: 15/255.0, alpha: 1.0)
        }
        self.confirmationView.addSubview(self.typeLabel)
        
        
        //Style and place "From" label
        self.fromUserLabel = UILabel(frame: CGRectMake(5, 45, self.confirmationView.frame.width-5, 35))
        self.fromUserLabel.text = "From"
        self.fromUserLabel.textAlignment = NSTextAlignment.Left
        self.fromUserLabel.font = UIFont(name: "Raleway-Light", size: 22)
        self.fromUserLabel.textColor = UIColor(red: 127/255.0, green: 140/255.0, blue: 141/255.0, alpha: 1.0)
        self.confirmationView.addSubview(self.fromUserLabel)
        
        
        //Style and place the username of the notification sender
        self.userNameLabel = UILabel(frame: CGRectMake(0, 70, self.confirmationView.frame.width, 45))
        self.userNameLabel.text = String(self.notiNameArray[indexPath.row] as NSString)
        self.userNameLabel.textAlignment = NSTextAlignment.Center
        self.userNameLabel.font = UIFont(name: "Raleway-Regular", size: 22)
        self.userNameLabel.textColor = UIColor(red: 127/255.0, green: 140/255.0, blue: 141/255.0, alpha: 1.0)
        self.confirmationView.addSubview(self.userNameLabel)
        
        //Style and place accept button
        self.acceptBtn   = UIButton.buttonWithType(UIButtonType.System) as UIButton
        self.acceptBtn.frame = CGRectMake(self.confirmationView.frame.width/2, self.confirmationView.frame.height-50, self.confirmationView.frame.width/2, 50)
        self.acceptBtn.titleLabel!.font = UIFont(name: "Raleway-Regular", size: 24)
        self.acceptBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.acceptBtn.backgroundColor = UIColor(red: 46/255.0, green: 204/255.0, blue: 113/255.0, alpha: 1.0)
        self.acceptBtn.setTitle("Accept", forState: UIControlState.Normal)
        self.acceptBtn.addTarget(self, action: "acceptInvite:", forControlEvents: UIControlEvents.TouchUpInside)
        self.confirmationView.addSubview(self.acceptBtn)
        
        //rgba(236, 240, 241,1.0)
        
        //Style and place decline button
        self.declineBtn   = UIButton.buttonWithType(UIButtonType.System) as UIButton
        self.declineBtn.frame = CGRectMake(0, self.confirmationView.frame.height-50, self.confirmationView.frame.width/2, 50)
        self.declineBtn.titleLabel!.font = UIFont(name: "Raleway-Regular", size: 24)
        self.declineBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.declineBtn.backgroundColor = UIColor(red: 231/255.0, green: 76/255.0, blue: 60/255.0, alpha: 1.0)
        self.declineBtn.setTitle("Decline", forState: UIControlState.Normal)
        self.declineBtn.addTarget(self, action: "declineInvite:", forControlEvents: UIControlEvents.TouchUpInside)
        self.confirmationView.addSubview(self.declineBtn)
        
        self.rowSelected = indexPath.row
        
    }
    
    func declineInvite(sender:UIButton!)
    {
        println("Invite Declined")
        
        //Retrieve clicked row data
        var selectedNot = PFQuery(className:"Notifications")
        selectedNot.whereKey("To", equalTo:currentUser.username)
        selectedNot.whereKey("From", equalTo:self.notiNameArray[self.rowSelected] as NSString)
        selectedNot.whereKey("Type", equalTo:self.notiTypeArray[self.rowSelected] as NSString)
        selectedNot.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects.count) scores.")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        
                        //remove declined invitation
                        object.removeObjectForKey("From")
                        object.removeObjectForKey("To")
                        object.removeObjectForKey("Type")
                        object.save()
                    }
                }
            } else {
                // Log details of the failure
                println("Error: \(error) \(error.userInfo!)")
            }
        }
        
        //remove accept/decline interface
        self.background.removeFromSuperview()
        self.confirmationView.removeFromSuperview()
        self.fromUserLabel.removeFromSuperview()
        self.typeLabel.removeFromSuperview()
        self.acceptBtn.removeFromSuperview()
        self.declineBtn.removeFromSuperview()
        
        //remove items from front-facing data
        self.notiNameArray.removeAtIndex(self.rowSelected)
        self.notiTypeArray.removeAtIndex(self.rowSelected)
        
        //reload altered tabel data
        self.notificationsTable.reloadData()
    }
    
    func acceptInvite(sender:UIButton!) {
        //if the notification is a friend request
        
        //remove accept/decline interface while communication occurs
        self.background.removeFromSuperview()
        self.confirmationView.removeFromSuperview()
        self.fromUserLabel.removeFromSuperview()
        self.typeLabel.removeFromSuperview()
        self.acceptBtn.removeFromSuperview()
        self.declineBtn.removeFromSuperview()
        
        
        //Removing notification from parse
        //Retrieve clicked row data
        var selectedNot = PFQuery(className:"Notifications")
        selectedNot.whereKey("To", equalTo:currentUser.username)
        selectedNot.whereKey("From", equalTo:self.notiNameArray[self.rowSelected] as NSString)
        selectedNot.whereKey("Type", equalTo:self.notiTypeArray[self.rowSelected] as NSString)
        selectedNot.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects.count) scores.")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        
                        //remove declined invitation
                        object.removeObjectForKey("From")
                        object.removeObjectForKey("To")
                        object.removeObjectForKey("Type")
                        object.save()
                    }
                }
            } else {
                // Log details of the failure
                println("Error: \(error) \(error.userInfo!)")
            }
        }
        
        
        if self.notiTypeArray[self.rowSelected] == "Friend Request" {
            //retrieves current freinds list, alters, then re-uploads
            var alterFriends = PFUser.query()
            alterFriends.whereKey("username", equalTo:currentUser.username)
            alterFriends.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]!, error: NSError!) -> Void in
                if error == nil {
                    //Utilize "Friends" information as table data
                    if let objects = objects as? [PFObject] {
                        for object in objects {
                            
                            //The user has no friends yet
                            self.acceptedReq = self.notiNameArray[self.rowSelected] as String
                            
                            //add friend to parse array
                            object.addObject(self.acceptedReq, forKey: "Friends")
                            object.saveInBackgroundWithBlock {
                                (success: Bool, error: NSError!) -> Void in
                                
                                
                                //remove items from front-facing data
                                self.notiNameArray.removeAtIndex(self.rowSelected)
                                self.notiTypeArray.removeAtIndex(self.rowSelected)
                                
                                //reload altered tabel data
                                self.notificationsTable.reloadData()
                                
                            }
                            
                        }
                    }
                }
            }
            //if its a group invite
        }else{
            println("not a fr.")
        }
        
        //reload altered tabel data
        self.notificationsTable.reloadData()
    }
}