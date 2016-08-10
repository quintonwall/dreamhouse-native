//
//  WelcomeTourPageViewController.swift
//  
//
//  Created by QUINTON WALL on 6/27/16.
//  Copyright © 2016 QUINTON WALL. All rights reserved.
//
//import SalesforceSDKCore


class WelcomeTourPageViewController: UIPageViewController, UIPageViewControllerDataSource, SFAuthenticationManagerDelegate {
    
    var arrPageTitle: NSArray = NSArray()
    var arrPagePhoto: NSArray = NSArray()
    
    
    override func viewWillAppear(animated: Bool) {
        
        if SFAuthenticationManager.sharedManager().haveValidSession {
            
           
            self.dismissViewControllerAnimated(true, completion: {
                // self.performSegueWithIdentifier("backtolist", sender: self)
            })
        }
      
    }
        
    override func viewDidLoad() { 
        super.viewDidLoad()
        
      SFAuthenticationManager.sharedManager().addDelegate(self)
        
        arrPageTitle = ["Search for your next dream home with Dreamhouse.", "Tap favorite to save a property and stay up to date on price changes.", "And even go on a virtual tour with our unique dreamcam.", "To get started, simply sign up with your Twitter id."];
        arrPagePhoto = ["welcome1.png", "welcome2.png", "welcome3.png", "welcome4.png"];
        self.dataSource = self
       
        
        self.setViewControllers([getViewControllerAtIndex(0)] as [UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
    }
    
    //MARK: salesforce auth
    func authManagerDidFinish(manager: SFAuthenticationManager, info: SFOAuthInfo) {
        
        if SFAuthenticationManager.sharedManager().haveValidSession {
            
            self.dismissViewControllerAnimated(true, completion: {
                print("dismiss after tap")
            })
        }
    }

    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        let pageContent: WelcomeContentViewController = viewController as! WelcomeContentViewController
        var index = pageContent.pageIndex
        if ((index == 0) || (index == NSNotFound))
        {
            return nil
        }
        index -= 1;
        return getViewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        let pageContent: WelcomeContentViewController = viewController as! WelcomeContentViewController
        var index = pageContent.pageIndex
        if (index == NSNotFound)
        {
            return nil;
        }
        index += 1;
        if (index == arrPageTitle.count)
        {
            return nil;
        }
        return getViewControllerAtIndex(index)
    }
    
    func getViewControllerAtIndex(index: NSInteger) -> WelcomeContentViewController
    {
        // Create a new view controller and pass suitable data.
        let pageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("WelcomeContent") as! WelcomeContentViewController
        pageContentViewController.strTitle = "\(arrPageTitle[index])"
        pageContentViewController.strPhotoName = "\(arrPagePhoto[index])"
        pageContentViewController.pageIndex = index
        
        //if we are at the last page of the tour show the get started button.
        if(index == arrPageTitle.count-1) {
            pageContentViewController.hideGetStartedButton = false
        } else {
            pageContentViewController.hideGetStartedButton = true
        }
        return pageContentViewController
    }

}
