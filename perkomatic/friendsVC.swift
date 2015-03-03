//
//  friendsVC.swift
//  perkomatic
//
//  Created by Emerson Stewart on 2015-02-21.
//  Copyright (c) 2015 Emerson Stewart. All rights reserved.
//

import UIKit

class friendsVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var addFriendText: UITextField!
    
    var friendsArray : [String] = []
    
    @IBOutlet var friendTable: UITableView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        var nib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        
        friendTable.registerNib(nib, forCellReuseIdentifier: "friendCell")
        
        //retrieve current friends
        
        //define current user
        var currentUser = PFUser.currentUser()
        if currentUser != nil {
            //if logged in
        } else {
            //if not logged in
        }
        
        
        var query = PFUser.query()
        query.whereKey("email", equalTo:currentUser.email)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                //Utilize "Friends" information as table data
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        if object["Friends"] == nil{
                            println("No one likes you....")
                        }else{
                            self.friendsArray = object["Friends"] as AnyObject as [String]
                            println(self.friendsArray)
                            
                            //When the query information is updated, reload table
                            self.friendTable.reloadData()
                        }
                    }
                }
            }else {
                // Log details of the failure
                println("Error: \(error) \(error.userInfo!)")
            }
        }
        
        self.title = "Friends"
        
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
    
    //add friend
    @IBAction func addFriendButton(sender: AnyObject) {
        
        //define current user
        var currentUser = PFUser.currentUser()
        if currentUser != nil {
            //if logged in
        } else {
            //if not logged in
        }
        
        
        ///////////////////////////
        // The Contingency Loop //
        /////////////////////////
        
        //////////////////
        // Initial Loop //
        /////////////////
        var query = PFUser.query()
        query.whereKey("username", equalTo:addFriendText.text)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                //Utilize "Friends" information as table data
                if let objects = objects as? [PFObject] {
                    //if there is a match
                    if objects.count != 0 {
                        //run add
                        for object in objects {
                            
                            /////////////////////
                            // Secondary Loop //
                            ///////////////////
                            
                            //retrieves current freinds list, alters, then re-uploads
                            var alterFriends = PFUser.query()
                            alterFriends.whereKey("email", equalTo:currentUser.email)
                            alterFriends.findObjectsInBackgroundWithBlock {
                                (objects: [AnyObject]!, error: NSError!) -> Void in
                                if error == nil {
                                    //Utilize "Friends" information as table data
                                    if let objects = objects as? [PFObject] {
                                        for object in objects {
                                            if object["Friends"] == nil && currentUser.username != self.addFriendText.text{
                                                
                                                //The user has no friends yet
                                                self.friendsArray = [self.addFriendText.text as NSString]
                                                //add friend to parse array
                                                
                                                //refresh local data
                                                self.friendTable.reloadData()
                                                
                                                object.addObject(self.addFriendText.text, forKey: "Friends")
                                                object.saveInBackgroundWithBlock {
                                                    (success: Bool, error: NSError!) -> Void in
                                                    if (success) {
                                                        let addedAlert = UIAlertController(title: "Added", message:
                                                            "Congrats on your new buddy!", preferredStyle: UIAlertControllerStyle.Alert)
                                                        addedAlert.addAction(UIAlertAction(title: "Thanks!", style: UIAlertActionStyle.Default,handler: nil))
                                                        
                                                        self.presentViewController(addedAlert, animated: true, completion: nil)
                                                        self.addFriendText.text = ""
                                                    } else {
                                                        // There was a problem, check error.description
                                                        self.addFriendText.text = ""
                                                    }
                                                }
                                            }else{
                                                
                                                //Add friend to user WITH friends already
                                                
                                                if contains(self.friendsArray,self.addFriendText.text) || self.addFriendText.text == currentUser.username
                                                {
                                                    self.addFriendText.text = ""
                                                    //do nothing
                                                }
                                                else{
                                                    self.friendsArray.append(self.addFriendText.text as NSString)
                                                    println(self.friendsArray)
                                                    
                                                    object.addObject(self.addFriendText.text, forKey: "Friends")
                                                    object.saveInBackgroundWithBlock {
                                                        (success: Bool, error: NSError!) -> Void in
                                                        if (success) {
                                                            let addedAlert = UIAlertController(title: "Added", message:
                                                                "Congrats on your new buddy!", preferredStyle: UIAlertControllerStyle.Alert)
                                                            addedAlert.addAction(UIAlertAction(title: "Thanks!", style: UIAlertActionStyle.Default,handler: nil))
                                                            
                                                            self.presentViewController(addedAlert, animated: true, completion: nil)
                                                        } else {
                                                            // There was a problem, check error.description
                                                        }
                                                    }
                                                    //When the query information is updated, reload table
                                                    self.friendTable.reloadData()
                                                }
                                            }
                                        }
                                    }
                                }else {
                                    // Log details of the failure
                                    println("Error: \(error) \(error.userInfo!)")
                                }
                            }
                            
                            
                            
                        }
                        //no user with that name exists
                    }else{
                        let alertController = UIAlertController(title: "User Not Found", message:
                            "Couldn't find that user, make sure you have it spelled correctly. Usernames are case sensitive.", preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default,handler: nil))
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                }
            }else {
                // Log details of the failure
                println("Error: \(error) \(error.userInfo!)")
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println(self.friendsArray)
        println(self.friendsArray.count)
        
        return self.friendsArray.count;
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: CustomTableViewCell = self.friendTable.dequeueReusableCellWithIdentifier("friendCell") as CustomTableViewCell
        
        var stringText = String(self.friendsArray[indexPath.row] as NSString)
        println(self.friendsArray)
        
        cell.loadItem(title: stringText, image: "addedFriendTable.png")
        
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
