//
//  SideMenuViewController.swift
//  dreamhousenative
//
//  Created by QUINTON WALL on 7/26/16.
//  Copyright © 2016 Quinton Wall. All rights reserved.
//

import UIKit
import ENSwiftSideMenu
import SalesforceSDKCore
import Spring


class SideMenuViewController: UIViewController, ENSideMenuDelegate {
    
    
    @IBOutlet weak var homeImage: UIImageView!
    @IBOutlet weak var bgImage: UIImageView!

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
       bgImage.blurImageLightly()
        
        //homeImage.layer.cornerRadius = homeImage.frame.size.height / 2
        //homeImage.layer.masksToBounds = true
       //homeImage.layer.borderColor = UIColor.whiteColor().CGColor
        //homeImage.layer.borderWidth = 3.0
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sideMenuController()?.sideMenu?.delegate = self
        
        if !SFAuthenticationManager.sharedManager().haveValidSession {
            dispatch_async(dispatch_get_main_queue()) {
                [unowned self] in
                self.performSegueWithIdentifier("welcometour", sender: self)
            }
        } else {
            //do nothing special.
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func toggleSideMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    // MARK: - ENSideMenu Delegate
    func sideMenuWillOpen() {
       // print("sideMenuWillOpen")
    }
    
    func sideMenuWillClose() {
        //print("sideMenuWillClose")
    }
    
    func sideMenuShouldOpenSideMenu() -> Bool {
        //print("sideMenuShouldOpenSideMenu")
        return true
    }
    
    func sideMenuDidClose() {
       // print("sideMenuDidClose")
    }
    
    func sideMenuDidOpen() {
       // print("sideMenuDidOpen")
    }
}

