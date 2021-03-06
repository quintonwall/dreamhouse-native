//
//  AppDefaults.swift
//  dreamhousenative
//
//  Created by Quinton Wall on 7/21/16.
//  Copyright © 2016 Quinton Wall. All rights reserved.
//

import Foundation
import UIKit
//import SalesforceSDKCore


class AppDefaults {
    
          //color palette
        static let dreamhouseGreen: UIColor = UIColor(netHex: 0x84BF41)
        static let dreamhouseLightBlue: UIColor = UIColor(netHex: 0x00A3DA)
        static let dreamhouseDarkBlue: UIColor = UIColor(netHex: 0x005385)
        static let dreamhouseBlreen: UIColor = UIColor(netHex: 0x00778E)
    
    static func isLoggedIn() -> Bool {
        return SFAuthenticationManager.sharedManager().haveValidSession
    }
    
    static func getUserId() -> String {
        return SFUserAccountManager.sharedInstance().currentUser!.accountIdentity.userId
    }
    
    
  
    static func getSOSOptions() -> SOSOptions {
        let options = SOSOptions(liveAgentPod: "d.la4-c1-was.salesforceliveagent.com",
                                 orgId: "00D36000000kFKB",
                                 deploymentId: "0NW36000000Gmxc")
        
        options.featureClientFrontCameraEnabled = true
        options.featureClientBackCameraEnabled = true
        //options.initialCameraType = SOSCameraType.FrontFacing
        options.featureClientScreenSharingEnabled = true
        
        return options
    }
    
    static func formatDeviceToken(deviceToken: NSData) -> String {
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
       return tokenString
    }
    
    static func getPushNotificationMessageFromAPS(userInfo: NSDictionary) -> String {
        var alertMsg = ""
        if let aps = userInfo["aps"] as? NSDictionary {
            if let alert = aps["alert"] as? NSDictionary {
                if let message = alert["message"] as? NSString {
                    alertMsg = message as String
                }
            }
        }
        return alertMsg
    }

}