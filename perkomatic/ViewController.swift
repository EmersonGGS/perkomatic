//
//  ViewController.swift
//  perkomatic
//
//  Created by Emerson Stewart on 2015-02-16.
//  Copyright (c) 2015 Emerson Stewart. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var usernameTxt: UITextField!
    @IBOutlet var passwordTxt: UITextField!

    override func viewDidLoad() {
        
        //define background color of view
        self.view.backgroundColor = UIColor(red: 241/255.0, green: 241/255.0, blue: 241/255.0, alpha: 1.0)
        
        //style login button
        loginBtn.clipsToBounds = true
        loginBtn.layer.cornerRadius = 5.0
    }
    @IBAction func loginBtnAction(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(usernameTxt.text, password: passwordTxt.text) {
            (user: PFUser!, error: NSError!) -> Void in
            if user != nil {
                // Do stuff after successful login.
                self.performSegueWithIdentifier("loginSuccess", sender: nil)
                
            } else {
                // The login failed. Check error to see why.
                let alertController = UIAlertController(title: "Perkomatic", message:
                    "Check your credentials to make sure they're right. Or if you don't have an account, sign up!", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
        
        
        
    }


}

 