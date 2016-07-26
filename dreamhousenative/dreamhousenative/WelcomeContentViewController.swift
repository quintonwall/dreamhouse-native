//
//  WelcomeContentViewController.swift
//  opt
//
//  Created by QUINTON WALL on 6/27/16.
//  Copyright © 2016 QUINTON WALL. All rights reserved.
//

import Foundation
import SalesforceSDKCore

class WelcomeContentViewController: UIViewController {
    
    @IBOutlet weak var tourImage: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var titleMessage: UILabel!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var getStartedButton: UIButton!
    @IBOutlet weak var pageIndicatorControl: UIPageControl!
    
    var pageIndex: Int = 0
   
    var strTitle: String!
    var strPhotoName: String!
    var hideGetStartedButton : Bool!
    
    override func viewDidLoad()
    {
       	super.viewDidLoad()
        
        

        
        
        
        tourImage.image = UIImage(named: strPhotoName)
        tourImage.layer.cornerRadius = tourImage.frame.size.height / 2
        tourImage.layer.masksToBounds = true
        tourImage.layer.borderColor = AppDefaults.dreamhouseBlreen.CGColor
        tourImage.layer.borderWidth = 3.0
        
        backgroundImage.image = UIImage(named: strPhotoName)
        backgroundImage.blurImage()
        
        titleMessage.text = strTitle
        
        let borderAlpha : CGFloat = 1.0
        let cornerRadius : CGFloat = 5.0
        getStartedButton.frame = CGRectMake(100, 100, 200, 50)
        getStartedButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        getStartedButton.backgroundColor = UIColor.clearColor()
        getStartedButton.layer.borderWidth = 2.0
        getStartedButton.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).CGColor
        getStartedButton.layer.cornerRadius = cornerRadius
        
        getStartedButton.hidden = hideGetStartedButton
        
        pageIndicatorControl.currentPage = pageIndex
        
        
        
    
    }
    
    @IBAction func getStartedTapped(sender: AnyObject) {
        showLogMeInScreen()
    }
        
    @IBAction func skipTapped(sender: AnyObject) {
        showLogMeInScreen()
    }
    
    private func showLogMeInScreen() {
        SalesforceSDKManager.sharedManager().launch()
        
    }
    
    
}