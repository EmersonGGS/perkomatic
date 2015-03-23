//
//  placeOrderVC.swift
//  perkomatic
//
//  Created by Emerson Stewart on 2015-03-18.
//  Copyright (c) 2015 Emerson Stewart. All rights reserved.
//

//
//  startRunVC.swift
//  perkomatic
//
//  Created by Emerson Stewart on 2015-03-14.
//  Copyright (c) 2015 Emerson Stewart. All rights reserved.
//

import UIKit

class placeOrderVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let menuItems : [String] = ["Coffee - XL", "Coffee - L", "Coffee - M", "Coffee - S"]
    let menuPrices = [2.10, 1.89, 1.65, 1.32]
    var groupsRunning : [String] = []
    var groupName : String = ""
    var selectedRow = 0
    
    @IBOutlet weak var orderingFrom: UILabel!
    @IBOutlet weak var placeOrderTable: UITableView!
    
    var acceptBtn = UIButton()
    var declineBtn = UIButton()
    
    //elements to choose group to order from
    var confirmationView = UIView()
    var groupRunHeading = UILabel()
    var groupButton = UIButton()
    
    override func viewDidLoad() {
        
        var viewWidth = self.view.frame.width
        var viewHeight = self.view.frame.height
        
        var nib = UINib(nibName: "MenuItemCell", bundle: nil)
        
        self.placeOrderTable.registerNib(nib, forCellReuseIdentifier: "menuItemCell")
        
        super.viewDidLoad()
        
        self.title = "Place Order"
        
        //define current user
        var currentUser = PFUser.currentUser()
        
        //retrieves current freinds list, alters, then re-uploads
        
        var getGroups = PFQuery(className:"Groups")
        getGroups.whereKey("Members", equalTo:currentUser.username)
        getGroups.whereKey("Active", equalTo:"true")
        getGroups.findObjectsInBackgroundWithBlock{
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                //Utilize "Friends" information as table data
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        if(object["CurrentRunner"] as NSString != currentUser.username){
                            self.groupsRunning.append(object["Name"] as String)
                            println(self.groupsRunning)
                        }
                    }
                    
                    for (var i = 0; i < self.groupsRunning.count; i++){
                        
                        var inc:CGFloat = CGFloat(130+(60*i))
                        
                        //Style and place group button
                        self.groupButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
                        self.groupButton.frame = CGRectMake(20, inc, self.confirmationView.frame.width-40, 50)
                        self.groupButton.titleLabel!.font = UIFont(name: "Raleway-Regular", size: 24)
                        self.groupButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                        self.groupButton.backgroundColor = UIColor(red: 32/255.0, green: 179/255.0, blue: 255/255.0, alpha: 1.0)
                        self.groupButton.setTitle(self.groupsRunning[i], forState: UIControlState.Normal)
                        self.groupButton.addTarget(self, action: "choseGroup:", forControlEvents: UIControlEvents.TouchUpInside)
                        self.confirmationView.addSubview(self.groupButton)
                        
                    }
                    
                }
            }else {
                // Log details of the failure
                println("Error: \(error) \(error.userInfo!)")
            }
        }
        
        
        
        /////////////////////
        // Secondary View //
        ///////////////////
        
        //view to select group
        self.confirmationView = UIView(frame: CGRectMake(0, 0, viewWidth, viewHeight))
        self.confirmationView.backgroundColor = UIColor(red: 241/255.0, green: 241/255.0, blue: 241/255.0, alpha: 1.0)
        self.view.addSubview(self.confirmationView)
        
        //Style and place the username of the notification sender
        self.groupRunHeading = UILabel(frame: CGRectMake(5, 75, self.confirmationView.frame.width, 40))
        self.groupRunHeading.text = "Choose a group to order from"
        self.groupRunHeading.textAlignment = NSTextAlignment.Center
        self.groupRunHeading.font = UIFont(name: "Raleway-Regular", size: 22)
        self.groupRunHeading.textColor = UIColor(red: 127/255.0, green: 140/255.0, blue: 141/255.0, alpha: 1.0)
        self.confirmationView.addSubview(self.groupRunHeading)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @IBAction func toggleNavMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    func cancelRun(sender:UIButton!) {
        self.performSegueWithIdentifier("cancelOrder", sender: self)
    }
    
    func createRun(sender:UIButton!) {
        
    }
    
    //clicking a group to order from
    func choseGroup(sender:UIButton!){
        var tempLbl = "Ordering from - "
        self.groupName = sender.titleLabel!.text!
        tempLbl += sender.titleLabel!.text!
        self.orderingFrom.text = tempLbl
        self.confirmationView.removeFromSuperview()
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuItems.count;
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: MenuItemCell = self.placeOrderTable.dequeueReusableCellWithIdentifier("menuItemCell") as MenuItemCell
        //convert array item to string
        var stringText = String(self.menuItems[indexPath.row] as NSString)
        
        //create $ string
        var priceString = "$ "
        //concat the price
        priceString += self.menuPrices[indexPath.row].description
        
        cell.loadItem(stringText, cost:priceString, image: "menuItem.png")
        
        
        //alternate cell background colour
        if ( indexPath.row % 2 == 0 ){
            cell.backgroundColor = UIColor(red: 248/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1.0)
        }else{
            cell.backgroundColor = UIColor.whiteColor()
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedRow = indexPath.row
        performSegueWithIdentifier("moveToCreamer", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "moveToCreamer") {
            var creamerView = segue.destinationViewController as creamerVC;
            
            creamerView.menuItem = menuItems [self.selectedRow]
            creamerView.menuPrice = menuPrices[self.selectedRow]
            creamerView.groupName = self.groupName
            creamerView.groupName = self.groupName
            
        }
    }
    
}
