//
//  creamerVC.swift
//  perkomatic
//
//  Created by Emerson Stewart on 2015-03-23.
//  Copyright (c) 2015 Emerson Stewart. All rights reserved.
//

import Foundation
import UIKit

class creamerVC: UIViewController {
    
    @IBOutlet weak var creamBtn: UIButton!
    @IBOutlet weak var milkBtn: UIButton!
    @IBOutlet weak var nondairyBtn: UIButton!
    @IBOutlet weak var creamerAmountLabel: UILabel!
    
    var menuItem : String = ""
    var menuPrice : Double = 0
    var groupName = ""
    var dairyType = ""
    var dairyAmount = 0
    
    override func viewDidLoad() {
        
        //define background color of view
        self.view.backgroundColor = UIColor(red: 241/255.0, green: 241/255.0, blue: 241/255.0, alpha: 1.0)
        
        self.title = "Cream"
        
        println(self.menuItem)
        println(self.menuPrice)
        println(self.groupName)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    @IBAction func creamerSelected(sender: UIButton) {
        self.dairyType = (sender.titleLabel!.text! as String)
    }
    
    @IBAction func interateCreamer(sender: UIStepper) {
        //cast Double into Int
        var toInt :Int = Int(sender.value)
        
        //set text for iteration
        creamerAmountLabel.text = String(toInt)
        self.dairyAmount = toInt
    }
    
    @IBAction func toggleNavMenu(sender: AnyObject) {
        toggleSideMenuView()
    }

    @IBAction func navigateToSugarVC(sender: AnyObject) {
        
        performSegueWithIdentifier("moveToSugar", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "moveToSugar") {
            var sugarView = segue.destinationViewController as sugarVC;
            
            sugarView.menuItem = self.menuItem
            sugarView.menuPrice = self.menuPrice
            sugarView.groupName = self.groupName
            sugarView.dairyType = self.dairyType
            sugarView.dairyAmount = self.dairyAmount
            
        }
    }

}
