//
//  SalesforceObjectType.swift
//  DHNative
//
//  Created by QUINTON WALL on 8/24/16.
//  Copyright © 2016 Quinton Wall. All rights reserved.
//

import Foundation

class SalesforceObjectType: NSObject {
    
    class func getType(sfdcid: NSString) -> NSString {
        var type: NSString
        
        if  sfdcid.hasPrefix("006")  {
            type = "Opportunity"
        }
        else {
            type = "Unknown"
        }
        
        return type
    }
    
    class func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
}
