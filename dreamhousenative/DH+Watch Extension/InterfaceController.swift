//
//  InterfaceController.swift
//  DH+Watch Extension
//
//  Created by QUINTON WALL on 8/23/16.
//  Copyright © 2016 Quinton Wall. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController {

    @IBOutlet var propertiesButton: WKInterfaceButton!
    @IBOutlet var favoritesButton: WKInterfaceButton!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    
    @IBAction func propertiesButtonTapped() {
    }
    
    @IBAction func favoritesButtonTapped() {
    }
}

