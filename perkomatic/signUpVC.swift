//
//  signUpVC.swift
//  perkomatic
//
//  Created by Emerson Stewart on 2015-02-19.
//  Copyright (c) 2015 Emerson Stewart. All rights reserved.
//

import Foundation
import UIKit

class signUpVC: UIViewController {
    @IBOutlet var usernameTxt: UITextField!
    @IBOutlet var emailTxt: UITextField!
    @IBOutlet var passwordTxt: UITextField!
    
    @IBAction func signUpSubmit(sender: AnyObject) {
        //init pfuser object, and assign values
        //init Freindslist
        var user = PFUser()
        user.username = usernameTxt.text
        user.password = passwordTxt.text
        user.email = emailTxt.text
        //user.addObject("", forKey: "Friends")
        
        //submit information to parse DB
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool!, error: NSError!) -> Void in
            //if there was no error
            if error == nil {
                self.performSegueWithIdentifier("showLoginVC", sender: nil)
            //if an error occured
            } else {
                let alertController = UIAlertController(title: "Perkomatic", message:
                    "You got an error, make sure to check your connection and make sure your information is correct.", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBOutlet var signupBtn: UIButton!
    override func viewDidLoad() {
        
        //define background color of view
        self.view.backgroundColor = UIColor(red: 241/255.0, green: 241/255.0, blue: 241/255.0, alpha: 1.0)
        
        //style signup button
        signupBtn.clipsToBounds = true
        signupBtn.layer.cornerRadius = 5.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
        
        
        
    }
    
    
}
