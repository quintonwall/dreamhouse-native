//
//  WelcomeTourViewController.swift
//  dreamhousenative
//
//  Created by Quinton Wall on 7/21/16.
//  Copyright © 2016 Quinton Wall. All rights reserved.
//

import UIKit
import SalesforceSDKCore

class WelcomeTourViewController: UIViewController, SFAuthenticationManagerDelegate  {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWelcomeTour()
        setupMainPage()
       
    }
    
    private func setupWelcomeTour() {
        let item1 = RMParallaxItem(image: UIImage(named: "welcome1")!, text: "A HOUSE IS MORE THAN BRICKS & MORTAR")
        let item2 = RMParallaxItem(image: UIImage(named: "welcome2")!, text: "IT REPRESENTS YOU, AND YOUR PERSONAL STYLE")
        let item3 = RMParallaxItem(image: UIImage(named: "welcome3")!, text: "A PLACE TO CREATE MEMORIES. TO CALL HOME")
        let item4 = RMParallaxItem(image: UIImage(named: "welcome4")!, text: "ARE YOU READY TO FIND YOUR DREAMHOUSE?")
        
        
        let rmParallaxViewController = RMParallax(items: [item1, item2, item3, item4], motion: false)
        rmParallaxViewController.completionHandler = {
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                rmParallaxViewController.view.alpha = 0.0
            })
        }
        
        // Adding parallax view controller.
        self.addChildViewController(rmParallaxViewController)
        self.view.addSubview(rmParallaxViewController.view)
        rmParallaxViewController.didMoveToParentViewController(self)
    }
    
    private func setupMainPage() {
        
        self.loginButton.layer.borderWidth = 1.0
        self.loginButton.layer.borderColor = UIColor.whiteColor().CGColor
        let cornerRadius : CGFloat = 3.0
        self.loginButton.layer.cornerRadius = cornerRadius

        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func signupTapped(sender: AnyObject) {
        //we use twitter for signup https://developer.salesforce.com/page/Login_with_Twitter
        
    }
    
    @IBAction func loginTapped(sender: AnyObject) {
        SalesforceSDKManager.sharedManager().launch()
    }
    
    func authManagerDidFinish(manager: SFAuthenticationManager!, info: SFOAuthInfo!) {
        
    print("I authed")
    }
}
