//
//  PropertyListRow.swift
//  DHNative
//
//  Created by QUINTON WALL on 8/23/16.
//  Copyright © 2016 Quinton Wall. All rights reserved.
//

import Foundation
import WatchKit

class PropertyListRow : NSObject {
    
    var recordId: String!
    var propertyUrl: String!
    
    @IBOutlet var propertyDescription: WKInterfaceLabel!
    @IBOutlet var propertyPrice: WKInterfaceLabel!
    @IBOutlet var group: WKInterfaceGroup!
    
}
