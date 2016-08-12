//
//  AppDelegate.swift
//  dreamhousenative
//
//  Created by Quinton Wall on 7/20/16.
//  Copyright © 2016 Quinton Wall. All rights reserved.
//

import UIKit
import ZAlertView
import SwiftyJSON

//import SalesforceSDKCore


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //salesforce auth
    let RemoteAccessConsumerKey = "3MVG9uudbyLbNPZORlx5pdNbXe.eo_dVK0WlmqUuSbXszEw7gEIKzXkMdZC2IRCPPAJZYZkdeB.Ed0JDG8YSv";
      let OAuthRedirectURI = "sfdc://success"
    let scopes = ["full"];
    
    //dreamhouse@demo2016.com
   
    
    var window: UIWindow?



    //MARK: Salesforce auth stuff
    override
    init()
    {
        super.init()
        
        SFLogger.sharedLogger().logLevel = SFLogLevel.Debug
        
        
       SalesforceSDKManager.sharedManager().connectedAppId = RemoteAccessConsumerKey
        SalesforceSDKManager.sharedManager().connectedAppCallbackUri = OAuthRedirectURI
        SalesforceSDKManager.sharedManager().authScopes = scopes
       
        SalesforceSDKManager.sharedManager().postLaunchAction = {
            [unowned self] (launchActionList: SFSDKLaunchAction) in
            let launchActionString = SalesforceSDKManager.launchActionsStringRepresentation(launchActionList)
            self.log(SFLogLevel.Info, msg:"Post-launch: launch actions taken: \(launchActionString)");
            print("ROOT IS "+(self.window?.rootViewController.debugDescription)!)
            
        }
        SalesforceSDKManager.sharedManager().launchErrorAction = {
            [unowned self] (error: NSError?, launchActionList: SFSDKLaunchAction) in
            if let actualError = error {
                self.log(SFLogLevel.Error, msg:"Error during SDK launch: \(actualError.localizedDescription)")
            } else {
                self.log(SFLogLevel.Error, msg:"Unknown error during SDK launch.")
            }
            
        }
        SalesforceSDKManager.sharedManager().postLogoutAction = {
            [unowned self] in
            self.handleSdkManagerLogout()
        }
        SalesforceSDKManager.sharedManager().switchUserAction = {
            [unowned self] (fromUser: SFUserAccount?, toUser: SFUserAccount?) -> () in
            self.handleUserSwitch(fromUser, toUser: toUser)
        }
        
    }
    
    
    func handleSdkManagerLogout()
    {
        //
    }
    
    func handleUserSwitch(fromUser: SFUserAccount?, toUser: SFUserAccount?)
    {
        //
    }

    
    
    //MARK: lifecycle events
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Failed to get device token for push notification: \(error.description)")
    }
    
    
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        SFPushNotificationManager.sharedInstance().didRegisterForRemoteNotificationsWithDeviceToken(deviceToken)
        print("Regisitering with Salesforce Push Notifications using token: \(AppDefaults.formatDeviceToken(deviceToken))")
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //register for salesforce push notifications
        //if(AppDefaults.isLoggedIn()) {
            registerForPushNotifications(application)
            SFPushNotificationManager.sharedInstance().registerForRemoteNotifications()
       // }
        return true
    }
    
    func registerForPushNotifications(application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Badge, .Sound, .Alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        //just in case the user didnt allow push notifications of any type
       // if notificationSettings.types != .None {
       //     registerForPushNotifications(application)
      //  }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
        let jsoninfo :JSON = JSON(userInfo)
        
        
        if ( application.applicationState == UIApplicationState.Inactive
            || application.applicationState == UIApplicationState.Background  ) {
            //no need to do anything extra here.
        } else {
            //but for times when we get a notification while the app is active, lets do something fun
            let dialog = ZAlertView(title: "Heads Up",
                                    message: jsoninfo["aps"]["alert"].string,
                                    closeButtonText: "Okay",
                                    closeButtonHandler: { alertView in
                                        alertView.dismiss()
                }
            )
            dialog.allowTouchOutsideToDismiss = false
            //let attrStr = NSMutableAttributedString(string: "Are you sure you want to quit?")
            //attrStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSMakeRange(10, 12))
            //dialog.messageAttributedString = attrStr
            dialog.show()

    
        }
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


