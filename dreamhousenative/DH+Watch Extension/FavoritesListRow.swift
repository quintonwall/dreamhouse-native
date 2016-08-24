//
//  FavoritesListRow.swift
//  DHNative
//
//  Created by QUINTON WALL on 8/24/16.
//  Copyright © 2016 Quinton Wall. All rights reserved.
//

import Foundation
import WatchKit

class FavoritesListRow : NSObject {
    
    var recordId: String!
    var propertyUrl: String!
    var price : NSNumber = 0.0 {
        didSet {
            let formatter = NSNumberFormatter()
            formatter.numberStyle = .CurrencyStyle
            formatter.maximumFractionDigits = 0
            // formatter.locale = NSLocale.currentLocale() // This is the default
            propertyPrice.setText(formatter.stringFromNumber(price))
        }
    }
    
    @IBOutlet var propertyDescription: WKInterfaceLabel!
    @IBOutlet var propertyPrice: WKInterfaceLabel!
    @IBOutlet var group: WKInterfaceGroup!
    
}
