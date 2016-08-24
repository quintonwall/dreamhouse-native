//
//  WKInterfaceImage.swift
//  DHNative
//
//  Created by QUINTON WALL on 8/24/16.
//  Copyright © 2016 Quinton Wall. All rights reserved.
//

import WatchKit

public extension WKInterfaceImage {
    
    public func setImageWithUrl(url:String) -> WKInterfaceImage? {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let url:NSURL = NSURL(string:url)!
            let data:NSData = NSData(contentsOfURL: url)!
            let placeholder = UIImage(data: data)!
            
            dispatch_async(dispatch_get_main_queue()) {
                self.setImage(placeholder)
            }
        }
        
        return self
    }
    
}
