//
//  sideBarNavController.swift
//  perkomatic
//
//  Created by Emerson Stewart on 2015-02-21.
//  Copyright (c) 2015 Emerson Stewart. All rights reserved.
//

import UIKit

class sideBarNavController: ENSideMenuNavigationController, ENSideMenuDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideMenu = ENSideMenu(sourceView: self.view, menuTableViewController: sideBarTableView(), menuPosition:.Left)
        //sideMenu?.delegate = self //optional
        //sideMenu?.menuWidth = 210.0 // optional, default is 160
        sideMenu?.bouncingEnabled = false
        
        // make navigation bar showing over side menu
        view.bringSubviewToFront(navigationBar)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - ENSideMenu Delegate
    func sideMenuWillOpen() {
        println("sideMenuWillOpen")
    }
    
    func sideMenuWillClose() {
        println("sideMenuWillClose")
    }
    
}
