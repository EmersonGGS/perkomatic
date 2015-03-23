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
    
    @IBOutlet weak var orderingFrom: UILabel!
    @IBOutlet weak var placeOrderTable: UITableView!
    
    var acceptBtn = UIButton()
    var declineBtn = UIButton()
    
    //elements to choose group to order from
    var confirmationView = UIView()
    var groupRunHeading = UILabel()
    var groupButton = UIButton()
    
    //view for inputs of milk/sugar
    var addativesView = UIView()
    
    //Dairy Button declarations
    var dairyHeading = UIButton()
    var milkBttn = UIButton()
    var creamBttn = UIButton()
    var nonDairyBttn = UIButton()
    var noneBttn = UIButton()
    var dairyStepper = UIStepper()
    var nextBttn = UIButton()
    var backToMenu = UIButton()
    
    var dairyType = ""
    var dairyAmount = 0
    
    var sugarType = ""
    var sugarAmount = 0
    
    override func viewDidLoad() {
        
        var viewWidth = self.view.frame.width
        var viewHeight = self.view.frame.height
        
        var nib = UINib(nibName: "MenuItemCell", bundle: nil)
        
        self.placeOrderTable.registerNib(nib, forCellReuseIdentifier: "menuItemCell")
        
        super.viewDidLoad()
        
        self.title = "Place Order"
        
        //Adding navigation button to nav bar
        let menuButton: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        menuButton.frame = CGRectMake(0, 0, 30, 30)
        menuButton.setImage(UIImage(named:"menuIcon.png"), forState: UIControlState.Normal)
        menuButton.addTarget(self, action: "toggleNavMenu:", forControlEvents: UIControlEvents.TouchUpInside)
        
        var leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: menuButton)
        
        self.navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: false)
        
        
        //Style and place accept button
        self.acceptBtn   = UIButton.buttonWithType(UIButtonType.System) as UIButton
        self.acceptBtn.frame = CGRectMake(viewWidth/2, viewHeight-60, viewWidth/2, 60)
        self.acceptBtn.titleLabel!.font = UIFont(name: "Raleway-Regular", size: 22)
        self.acceptBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.acceptBtn.backgroundColor = UIColor(red: 32/255.0, green: 179/255.0, blue: 255/255.0, alpha: 1.0)
        self.acceptBtn.setTitle("Place", forState: UIControlState.Normal)
        self.acceptBtn.addTarget(self, action: "createRun:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.acceptBtn)
        
        //Style and place decline button
        self.declineBtn   = UIButton.buttonWithType(UIButtonType.System) as UIButton
        self.declineBtn.frame = CGRectMake(0, viewHeight-60, viewWidth/2, 60)
        self.declineBtn.titleLabel!.font = UIFont(name: "Raleway-Regular", size: 22)
        self.declineBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.declineBtn.backgroundColor = UIColor(red: 231/255.0, green: 76/255.0, blue: 60/255.0, alpha: 1.0)
        self.declineBtn.setTitle("Cancel", forState: UIControlState.Normal)
        self.declineBtn.addTarget(self, action: "cancelRun:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.declineBtn)
        
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
                        self.groupsRunning.append(object["Name"] as String)
                        println(self.groupsRunning)
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
        //self.view.addSubview(self.confirmationView)
        
        //Style and place the username of the notification sender
        self.groupRunHeading = UILabel(frame: CGRectMake(5, 75, self.confirmationView.frame.width, 40))
        self.groupRunHeading.text = "Choose a group to order from"
        self.groupRunHeading.textAlignment = NSTextAlignment.Center
        self.groupRunHeading.font = UIFont(name: "Raleway-Regular", size: 22)
        self.groupRunHeading.textColor = UIColor(red: 127/255.0, green: 140/255.0, blue: 141/255.0, alpha: 1.0)
        self.confirmationView.addSubview(self.groupRunHeading)
        
        
        //init addative view, to be invoked later
        self.addativesView = UIView(frame: CGRectMake(0, 0, viewWidth, viewHeight))
        self.addativesView.backgroundColor = UIColor(red: 241/255.0, green: 241/255.0, blue: 241/255.0, alpha: 1.0)
        
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
        
//        //Style and place the username of the notification sender
//        var dairyHeading = UILabel(frame: CGRectMake(5, 75, self.addativesView.frame.width, 40))
//        dairyHeading.text = "What kind of creamer do you want?"
//        dairyHeading.textAlignment = NSTextAlignment.Center
//        dairyHeading.font = UIFont(name: "Raleway-Regular", size: 22)
//        dairyHeading.textColor = UIColor(red: 127/255.0, green: 140/255.0, blue: 141/255.0, alpha: 1.0)
//        self.addativesView.addSubview(dairyHeading)
//        
//        //Style and place group button
//        self.milkBttn = UIButton.buttonWithType(UIButtonType.System) as UIButton
//        self.milkBttn.frame = CGRectMake(20, 180, self.addativesView.frame.width-40, 50)
//        self.milkBttn.titleLabel!.font = UIFont(name: "Raleway-Regular", size: 22)
//        self.milkBttn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
//        self.milkBttn.backgroundColor = UIColor(red: 32/255.0, green: 179/255.0, blue: 255/255.0, alpha: 1.0)
//        self.milkBttn.setTitle("Milk", forState: UIControlState.Normal)
//        self.milkBttn.addTarget(self, action: "setDairyType:", forControlEvents: UIControlEvents.TouchUpInside)
//        self.addativesView.addSubview(self.milkBttn)
//        
//        //Style and place group button
//        self.creamBttn = UIButton.buttonWithType(UIButtonType.System) as UIButton
//        self.creamBttn.frame = CGRectMake(20, 120, self.addativesView.frame.width-40, 50)
//        self.creamBttn.titleLabel!.font = UIFont(name: "Raleway-Regular", size: 22)
//        self.creamBttn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
//        self.creamBttn.backgroundColor = UIColor(red: 32/255.0, green: 179/255.0, blue: 255/255.0, alpha: 1.0)
//        self.creamBttn.setTitle("Cream", forState: UIControlState.Normal)
//        self.creamBttn.addTarget(self, action: "setDairyType:", forControlEvents: UIControlEvents.TouchUpInside)
//        self.addativesView.addSubview(self.creamBttn)
//        
//        //Style and place group button
//        self.nonDairyBttn = UIButton.buttonWithType(UIButtonType.System) as UIButton
//        self.nonDairyBttn.frame = CGRectMake(20, 240, self.addativesView.frame.width-40, 50)
//        self.nonDairyBttn.titleLabel!.font = UIFont(name: "Raleway-Regular", size: 22)
//        self.nonDairyBttn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
//        self.nonDairyBttn.backgroundColor = UIColor(red: 32/255.0, green: 179/255.0, blue: 255/255.0, alpha: 1.0)
//        self.nonDairyBttn.setTitle("Non Dairy", forState: UIControlState.Normal)
//        self.nonDairyBttn.addTarget(self, action: "setDairyType:", forControlEvents: UIControlEvents.TouchUpInside)
//        self.addativesView.addSubview(self.nonDairyBttn)
//        
//        //Style and place group button
//        self.noneBttn = UIButton.buttonWithType(UIButtonType.System) as UIButton
//        self.noneBttn.frame = CGRectMake(20, 300, self.addativesView.frame.width-40, 50)
//        self.noneBttn.titleLabel!.font = UIFont(name: "Raleway-Regular", size: 22)
//        self.noneBttn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
//        self.noneBttn.backgroundColor = UIColor(red: 32/255.0, green: 179/255.0, blue: 255/255.0, alpha: 1.0)
//        self.noneBttn.setTitle("None", forState: UIControlState.Normal)
//        self.noneBttn.addTarget(self, action: "setDairyType:", forControlEvents: UIControlEvents.TouchUpInside)
//        self.addativesView.addSubview(self.noneBttn)
//        
//        self.dairyStepper = UIStepper (frame:CGRectMake(self.addativesView.frame.width/2, 360, 0, 0))
//        self.dairyStepper.wraps = false
//        self.dairyStepper.autorepeat = true
//        self.dairyStepper.maximumValue = 5
//        self.dairyStepper.addTarget(self, action: "stepperValueChanged:", forControlEvents: .ValueChanged)
//        self.addativesView.addSubview(self.dairyStepper)
//        
//        
//        //Style and place group button
//        self.nextBttn = UIButton.buttonWithType(UIButtonType.System) as UIButton
//        self.nextBttn.frame = CGRectMake(self.addativesView.frame.width/2, self.addativesView.frame.height-50, self.addativesView.frame.width/2, 50)
//        self.nextBttn.titleLabel!.font = UIFont(name: "Raleway-Light", size: 24)
//        self.nextBttn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
//        self.nextBttn.backgroundColor = UIColor(red: 32/255.0, green: 179/255.0, blue: 255/255.0, alpha: 1.0)
//        self.nextBttn.setTitle("NEXT", forState: UIControlState.Normal)
//        self.nextBttn.addTarget(self, action: "setDairyType:", forControlEvents: UIControlEvents.TouchUpInside)
//        self.addativesView.addSubview(self.nextBttn)
//        
//        //Style and place group button
//        self.backToMenu = UIButton.buttonWithType(UIButtonType.System) as UIButton
//        self.backToMenu.frame = CGRectMake(0, self.addativesView.frame.height-50, self.addativesView.frame.width/2, 50)
//        self.backToMenu.titleLabel!.font = UIFont(name: "Raleway-Light", size: 24)
//        self.backToMenu.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
//        self.backToMenu.backgroundColor = UIColor(red: 32/255.0, green: 179/255.0, blue: 255/255.0, alpha: 1.0)
//        self.backToMenu.setTitle("BACK", forState: UIControlState.Normal)
//        self.backToMenu.addTarget(self, action: "setDairyType:", forControlEvents: UIControlEvents.TouchUpInside)
//        self.addativesView.addSubview(self.backToMenu)
//
//        self.view.addSubview(self.addativesView)
        
        performSegueWithIdentifier("moveToCreamer", sender: self)
    }
    
    func stepperValueChanged(sender: UIStepper){
        println(sender.value)
    }
    
    func setDairyType(sender: UIButton){

    }
}
