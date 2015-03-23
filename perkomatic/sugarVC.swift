//
//  sugarVC.swift
//  perkomatic
//
//  Created by Emerson Stewart on 2015-03-23.
//  Copyright (c) 2015 Emerson Stewart. All rights reserved.
//

import Foundation
import UIKit

class sugarVC: UIViewController {
    var menuItem : String = ""
    var menuPrice : Double = 0
    var groupName = ""
    var dairyType = ""
    var dairyAmount = 0
    var sugarType = ""
    var sugarAmount = 0
    
    @IBOutlet weak var sugarIteration: UILabel!
    
    override func viewDidLoad() {
        
        //define background color of view
        self.view.backgroundColor = UIColor(red: 241/255.0, green: 241/255.0, blue: 241/255.0, alpha: 1.0)
        
        self.title = "Sugar"
        
        println(self.menuItem)
        println(self.menuPrice)
        println(self.groupName)
        println(self.dairyType)
        println(self.dairyAmount)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @IBAction func toggleNavMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    @IBAction func changeSugarValue(sender: UIStepper) {
        
        //cast Double into Int
        var toInt :Int = Int(sender.value)
        
        //set text for iteration
        self.sugarIteration.text = String(toInt)
        self.sugarAmount = toInt
        
    }
    
    @IBAction func selectSugarType(sender: UIButton) {
        self.sugarType = sender.titleLabel!.text!
    }
    
    
    @IBAction func submitOrder(sender: AnyObject) {
        println("Information Submitted: ")
        println(self.menuItem)
        println(self.menuPrice)
        println(self.groupName)
        println(self.dairyType)
        println(self.dairyAmount)
        println(self.sugarType)
        println(self.sugarAmount)
        
        //define current user
        var currentUser = PFUser.currentUser()
        
        //retrieves current freinds list, alters, then re-uploads
        
        var getGroups = PFQuery(className:"Groups")
        getGroups.whereKey("Members", equalTo:currentUser.username)
        getGroups.whereKey("Active", equalTo:"true")
        getGroups.whereKey("Name", equalTo:self.groupName )
        getGroups.findObjectsInBackgroundWithBlock{
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                //Utilize "Friends" information as table data
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        var createOrder = PFObject(className:"Orders")
                        createOrder["GroupName"] = self.groupName
                        createOrder["RunnerName"] = object["CurrentRunner"]
                        createOrder["Orderer"] = currentUser.username
                        createOrder["Item"] = self.menuItem
                        createOrder["Amount"] = self.menuPrice
                        createOrder["SugarType"] = self.sugarType
                        createOrder["SugarAmount"] = self.sugarAmount
                        createOrder["CreamType"] = self.dairyType
                        createOrder["CreamAmount"] = self.dairyAmount
                        createOrder.saveInBackgroundWithBlock {
                            (success: Bool, error: NSError!) -> Void in
                            if (success) {
                                // The object has been saved.
                            } else {
                                // There was a problem, check error.description
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
}
