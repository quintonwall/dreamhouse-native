//
//  WelcomeTourViewController.swift
//  dreamhousenative
//
//  Created by Quinton Wall on 7/21/16.
//  Copyright © 2016 Quinton Wall. All rights reserved.
//

import UIKit

class WelcomeTourViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}
