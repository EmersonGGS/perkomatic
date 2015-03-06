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
    
    //Notification Properties
    var notiNameArray : [String] = []
    var notiTypeArray : [String] = []
    
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
        println("clicked a cell")
        
        var frameWidth = self.view.frame.width
        var frameHeight = self.view.frame.height
        
        var background = UIView(frame: CGRectMake(0, 0, frameWidth, frameHeight))
        background.backgroundColor = UIColor(red: 241/255.0, green: 241/255.0, blue: 241/255.0, alpha: 0.7)
        self.view.addSubview(background)
        
        var confirmationView = UIView(frame: CGRectMake(20, 100, 280, 200))
        confirmationView.backgroundColor = UIColor(red: 236/255.0, green: 240/255.0, blue: 241/255.0, alpha: 1.0)
        self.view.addSubview(confirmationView)
        
        var typeLabel = UILabel(frame: CGRectMake(0, 0, confirmationView.frame.width, 35))
        typeLabel.backgroundColor = UIColor(red: 26/255.0, green: 188/255.0, blue: 156/255.0, alpha: 1.0)
        typeLabel.text = String(self.notiTypeArray[indexPath.row] as NSString)
        typeLabel.textAlignment = NSTextAlignment.Center
        typeLabel.textColor = UIColor(red: 236/255.0, green: 240/255.0, blue: 241/255.0, alpha: 1.0)
        
        if String(self.notiTypeArray[indexPath.row] as NSString) == "Friend Request"{
            typeLabel.backgroundColor = UIColor(red: 52/255.0, green: 152/255.0, blue: 219/255.0, alpha: 1.0)
        }else{
            typeLabel.backgroundColor = UIColor(red: 241/255.0, green: 196/255.0, blue: 15/255.0, alpha: 1.0)
        }
        confirmationView.addSubview(typeLabel)
        
        var fromUserLabel = UILabel(frame: CGRectMake(5, 45, confirmationView.frame.width-5, 35))
        fromUserLabel.text = "From"
        fromUserLabel.textAlignment = NSTextAlignment.Left
        fromUserLabel.textColor = UIColor(red: 236/255.0, green: 240/255.0, blue: 241/255.0, alpha: 1.0)
        confirmationView.addSubview(fromUserLabel)
        
        var userNameLabel = UILabel(frame: CGRectMake(0, 90, confirmationView.frame.width, 45))
        userNameLabel.text = String(self.notiNameArray[indexPath.row] as NSString)
        userNameLabel.textAlignment = NSTextAlignment.Center
        userNameLabel.textColor = UIColor(red: 236/255.0, green: 240/255.0, blue: 241/255.0, alpha: 1.0)
        confirmationView.addSubview(userNameLabel)
        
    }

}
