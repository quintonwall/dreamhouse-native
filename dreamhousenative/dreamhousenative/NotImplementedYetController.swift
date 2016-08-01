//
//  NotImplementedYetController.swift
//  DHNative
//
//  Created by QUINTON WALL on 7/31/16.
//  Copyright © 2016 Quinton Wall. All rights reserved.
//

import UIKit
import ENSwiftSideMenu

class NotImplementedYetController: UIViewController, ENSideMenuDelegate {
    
    @IBOutlet weak var poopImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sideMenuController()?.sideMenu?.delegate = self
        
        
        poopImage.layer.cornerRadius = poopImage.frame.size.height / 2
        poopImage.layer.masksToBounds = true
        poopImage.layer.borderColor = UIColor.whiteColor().CGColor
        poopImage.layer.borderWidth = 2.0
    }
    @IBAction func hamburgerTapped(sender: AnyObject) {
        toggleSideMenuView()
    }


}
