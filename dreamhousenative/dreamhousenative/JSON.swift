//
//  JSON.swift
//  dreamhousenative
//
//  Created by QUINTON WALL on 7/26/16.
//  Copyright © 2016 Quinton Wall. All rights reserved.
//


import SwiftyJSON

extension JSON {
    public var date: NSDate? {
        get {
            if let str = self.string {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                dateFormatter.timeZone = NSTimeZone(name: "UTC")
                let date = dateFormatter.dateFromString(str)
                return date
                
            }
            return nil
        }
    }
    
    public var systemdate: NSDate? {
        get {
            if let str = self.string {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.AAZZZZZ"
                dateFormatter.timeZone = NSTimeZone(name: "UTC")
                let date = dateFormatter.dateFromString(str)
                
                return date
                
            }
            return nil
        }
    }
    
    public var currency: String? {
        get {
            if let str = self.string {
                let formatter = NSNumberFormatter()
                formatter.numberStyle = .CurrencyStyle
                // formatter.locale = NSLocale.currentLocale() // This is the default
                let ccy = formatter.numberFromString(str)
                
                return ccy?.stringValue

            }
            return nil
        }
    }

}