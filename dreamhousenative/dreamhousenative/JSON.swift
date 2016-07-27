//
//  JSON.swift
//  SwiftyJSON extension to support Saleforce field types
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
            if let str = self.int {
                let formatter = NSNumberFormatter()
                formatter.numberStyle = .CurrencyStyle
                formatter.maximumFractionDigits = 0
                // formatter.locale = NSLocale.currentLocale() // This is the default
                let ccy : String = formatter.stringFromNumber(str)!
                
                return ccy

            }
            return nil
        }
    }

}