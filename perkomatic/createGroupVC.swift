//
//  createGroupVC.swift
//  perkomatic
//
//  Created by Emerson Stewart on 2015-03-03.
//  Copyright (c) 2015 Emerson Stewart. All rights reserved.
//

import UIKit

class createGroupVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var friendsToAdd : [String] = []
    var addStatus : [String] = []
    var addedMembers : [String] = []
    
    //init views and buttons
    var background = UIView()
    var imgBG = UIView()
    var confirmationView = UIView()
    var userNameLabel = UILabel()
    var groupName = UITextField()
    var groupImg = UIImageView()
    var acceptBtn = UIButton()
    var declineBtn = UIButton()
    
    @IBOutlet weak var addedMemberTable: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        var nib = UINib(nibName: "notificationTableCell", bundle: nil)
        
        addedMemberTable.registerNib(nib, forCellReuseIdentifier: "memberCell")
        
        self.title = "Friends"
        
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
        var getFriends = PFUser.query()
        getFriends.whereKey("email", equalTo:currentUser.email)
        getFriends.findObjectsInBackgroundWithBlock{
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                //Utilize "Friends" information as table data
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        if object["Friends"] == nil{
                            
                            //if no friends are found
                            
                        }else{
                            
                            self.friendsToAdd = object["Friends"] as AnyObject as [String]
                            for (var i = 0; i < self.friendsToAdd.count; i++){
                                self.addStatus.append("Not Added")
                            }
                        }
                        
                        //When the query information is updated, reload table
                        self.addedMemberTable.reloadData()
                    }
                }
            }else {
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
        
        return self.friendsToAdd.count;
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: notificationTableCell = self.addedMemberTable.dequeueReusableCellWithIdentifier("memberCell") as notificationTableCell
        
        var stringText = String(self.friendsToAdd[indexPath.row] as NSString)
        
        var addedString = String(self.addStatus[indexPath.row] as NSString)
        
        if addedString == "Added"{
            cell.loadItem(stringText, type: addedString, typeBG: UIColor(red: 39/255.0, green: 174/255.0, blue: 96/255.0, alpha: 1.0)   , image: "friendProfile.png")
        }else{
            cell.loadItem(stringText, type: addedString, typeBG: UIColor(red: 192/255.0, green: 57/255.0, blue: 43/255.0, alpha: 1.0) , image: "friendProfile.png")
        }
        for (var i = 0; i < self.friendsToAdd.count; i++) {
            
            if cell.typeText.text! == "Added"{
                
                if contains(self.addedMembers, cell.fromText.text!) {
                    //Don't add.
                }else{
                    self.addedMembers.append(cell.fromText.text!)
                }
            }
            //output aselected
            println(self.addedMembers)
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
        
        self.addedMembers = []
        
        let indexPath = tableView.indexPathForSelectedRow();
        
        let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as notificationTableCell;
        
        
        if self.addStatus[indexPath!.row] == "Not Added"{
            self.addStatus[indexPath!.row] = "Added"
            currentCell.typeText.backgroundColor = UIColor(red: 39/255.0, green: 174/255.0, blue: 96/255.0, alpha: 1.0)
            self.addedMemberTable.reloadData()
        }else{
            self.addStatus[indexPath!.row] = "Not Added"
            currentCell.typeText.backgroundColor = UIColor(red: 192/255.0, green: 57/255.0, blue: 43/255.0, alpha: 1.0)
            self.addedMemberTable.reloadData()
        }
    }
    
    @IBAction func createGroup(sender: AnyObject) {
        
        var frameWidth = self.view.frame.width
        var frameHeight = self.view.frame.height
        
        self.background = UIView(frame: CGRectMake(0, 0, frameWidth, frameHeight))
        self.background.backgroundColor = UIColor(red: 241/255.0, green: 241/255.0, blue: 241/255.0, alpha: 0.85)
        self.view.addSubview(self.background)
        
        self.confirmationView = UIView(frame: CGRectMake(20, 100, 280, 200))
        self.confirmationView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.confirmationView)
        
        //create textfield for group name
        self.groupName.frame = CGRectMake(10, self.confirmationView.frame.height/2-30, self.confirmationView.frame.width-20, 50)
        self.groupName.backgroundColor = UIColor(red: 241/255.0, green: 241/255.0, blue: 241/255.0, alpha: 1.0)
        self.groupName.placeholder = "Name"
        self.groupName.font = UIFont(name: "Raleway-Regular", size: 22)
        self.groupName.textColor = UIColor(red: 127/255.0, green: 140/255.0, blue: 141/255.0, alpha: 1.0)
        self.groupName.textAlignment = NSTextAlignment.Center
        self.confirmationView.addSubview(self.groupName)
        
        self.imgBG = UIView(frame: CGRectMake(10, self.confirmationView.frame.height/2-30, 50, 50))
        self.imgBG.backgroundColor = UIColor(red: 52/255.0, green: 152/255.0, blue: 219/255.0, alpha: 1.0)
        self.confirmationView.addSubview(self.imgBG)
        
        //rgb(52, 152, 219)
        let imageName = "newAddWhite.png"
        let image = UIImage(named: imageName)
        self.groupImg.frame = CGRectMake(10, 10, 30, 30)
        self.groupImg.image = (image: image!)
        self.imgBG.addSubview(self.groupImg)
        
        //Style and place the username of the notification sender
        self.userNameLabel = UILabel(frame: CGRectMake(0, 5, self.confirmationView.frame.width, 45))
        self.userNameLabel.text = "Name your group"
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
        self.acceptBtn.setTitle("Create", forState: UIControlState.Normal)
        self.acceptBtn.addTarget(self, action: "acceptInvite:", forControlEvents: UIControlEvents.TouchUpInside)
        self.confirmationView.addSubview(self.acceptBtn)
        
        //Style and place decline button
        self.declineBtn   = UIButton.buttonWithType(UIButtonType.System) as UIButton
        self.declineBtn.frame = CGRectMake(0, self.confirmationView.frame.height-50, self.confirmationView.frame.width/2, 50)
        self.declineBtn.titleLabel!.font = UIFont(name: "Raleway-Regular", size: 24)
        self.declineBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.declineBtn.backgroundColor = UIColor(red: 231/255.0, green: 76/255.0, blue: 60/255.0, alpha: 1.0)
        self.declineBtn.setTitle("Cancel", forState: UIControlState.Normal)
        self.declineBtn.addTarget(self, action: "declineInvite:", forControlEvents: UIControlEvents.TouchUpInside)
        self.confirmationView.addSubview(self.declineBtn)
    }
    
    func declineInvite(sender:UIButton!) {
        
        //remove accept/decline interface while communication occurs
        self.background.removeFromSuperview()
        self.confirmationView.removeFromSuperview()
        self.acceptBtn.removeFromSuperview()
        self.declineBtn.removeFromSuperview()
    }
    
    func acceptInvite(sender:UIButton!) {
        
        //remove accept/decline interface while communication occurs
        self.background.removeFromSuperview()
        self.confirmationView.removeFromSuperview()
        self.acceptBtn.removeFromSuperview()
        self.declineBtn.removeFromSuperview()
        
        var currentUser = PFUser.currentUser()
        for(var i = 0; i < self.addedMembers.count; i++){
            var createNotification = PFObject(className:"Notifications")
            createNotification["To"] = self.addedMembers[i]
            createNotification["From"] = currentUser.username
            createNotification["Type"] = "Group Invite"
            createNotification.saveInBackgroundWithBlock {
                (success: Bool, error: NSError!) -> Void in
                if (success) {
                    // The object has been saved.
                } else {
                    // There was a problem, check error.description
                }
            }

        }
        
        
        self.addedMembers.append(currentUser.username)
        var createGroup = PFObject(className:"Groups")
        createGroup["Members"] = self.addedMembers
        createGroup["Admin"] = currentUser.username
        createGroup["Name"] = groupName.text
        createGroup["Active"] = "false"
        createGroup.saveInBackgroundWithBlock {
            (success: Bool, error: NSError!) -> Void in
            if (success) {
                // The object has been saved.
            } else {
                // There was a problem, check error.description
            }
        }

        
    }
    
}