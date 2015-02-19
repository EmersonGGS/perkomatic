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

    override func viewDidLoad() {
        self.view.backgroundColor = UIColor(red: 241/255.0, green: 241/255.0, blue: 241/255.0, alpha: 1.0)
        
        loginBtn.clipsToBounds = true
        loginBtn.layer.cornerRadius = 10.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
        
        
        
    }


}

 