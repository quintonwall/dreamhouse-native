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
import SwiftyJSON

internal class PropertiesListController : WKInterfaceController {
    
    @IBOutlet var propertiesTable: WKInterfaceTable!
    
    var allProps : [Property] = []
    
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
            session!.sendMessage(["request-type": "all-properties"], replyHandler: { (response) -> Void in
                
                //todo: handle response
                //print("Full response \(response)")
                if(response["success"] != nil) {
                    let x:String = response["success"] as! String
                    let res =  SalesforceObjectType.convertStringToDictionary(x)
                   // let r = JSON.parse(x)
                    //let responseJSON = JSON(response["success"]!)
                    self.loadTableData(res!["records"] as! NSArray)
                }
                
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

  
    private func loadTableData(results : NSArray) {
  
         propertiesTable.setNumberOfRows(results.count, withRowType: "PropertyRows")
        for (index, record) in results.enumerate() {
            let row = propertiesTable.rowControllerAtIndex(index) as! PropertyListRow
            
            let s: NSDictionary = record as! NSDictionary
            row.recordId = s["Id"] as? String
            row.price = s["Price__c"] as! NSNumber
            row.propertyDescription.setText(s["Title__c"] as? String)
            row.group.setBackgrounImageWithUrl(s["Picture__c"] as! String)
            
        }
        
        /*
        print("Total properties returned: \(response["totalSize"])")
         for (_,subJSON):(String,JSON) in response["records"] {
            allProps.append(Property(jsonRecord: subJSON))
         }
         print("Fetched \(allProps.count) properties")
 
        propertiesTable.setNumberOfRows(allProps.count, withRowType: "PropertyRows")
        */
    }
}

extension PropertiesListController : WCSessionDelegate {
}