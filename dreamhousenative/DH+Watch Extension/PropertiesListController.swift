//
//  PropertiesListController.swift
//  DHNative
//
//  Created by QUINTON WALL on 8/23/16.
//  Copyright © 2016 Quinton Wall. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

internal class PropertiesListController : WKInterfaceController {
    
    @IBOutlet var propertiesTable: WKInterfaceTable!
    var session: WCSession? {
        didSet {
            if let session = session {
                session.delegate = self
                session.activateSession()
            }
        }
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }
    
    override func didAppear() {
        if ( WCSession.isSupported() ) {
            session = WCSession.defaultSession()
            //passing nil will fetch all properties.
            session!.sendMessage(["get-property": "all"], replyHandler: { (response) -> Void in
                
                //todo: handle response
                print(response)
                self.loadTableData(response["property"] as! [Property])
                
                }, errorHandler: { (error) -> Void in
                    print(error)
                    
            })
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

  
    private func loadTableData(properties : [Property]) {
    
        propertiesTable.setNumberOfRows(properties.count, withRowType: "PropertyRows")
        
    }
}

extension PropertiesListController : WCSessionDelegate {
}