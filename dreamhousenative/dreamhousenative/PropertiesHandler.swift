//
//  PropertiesHandler.swift
//  DHNative
//
// encapsulate the calls to fetch property data. This allows us to use the same logic for both the phone and watch calls.
//
//  Created by QUINTON WALL on 8/23/16.
//  Copyright © 2016 Quinton Wall. All rights reserved.
//


import SwiftyJSON
import WatchConnectivity



class PropertiesHandler: NSObject, WCSessionDelegate {
    
    static let soqlGetAllProperties = String("select Address__c, Baths__c, Beds__c, Broker__c, Broker__r.Title__c, Broker__r.Name, Broker__r.Picture__c, City__c, Description__c, Id, Location__c, Name, OwnerId, Picture__c, Price__c, State__c, Thumbnail__c, Title__c, Zip__c, (select id, Property__c from Favorites__r) from Property__c")
    
    static let soqlGetMyFavorites = String("select Property__r.Address__c, Property__r.Baths__c, Property__r.Beds__c, Property__r.Broker__c, Property__r.Broker__r.Title__c, Property__r.Broker__r.Name, Property__r.Broker__r.Picture__c, Property__r.City__c, Property__r.Description__c, Property__r.Id, Property__r.Location__c, Property__r.Name, Property__r.OwnerId, Property__r.Picture__c, Property__r.Price__c, Property__r.State__c, Property__r.Thumbnail__c, Property__r.Title__c, Property__r.Zip__c from Favorite__c where User__c = '\(AppDefaults.getUserId())'")
    
     var session: WCSession!
    
    
    func register() {
        print("PropertiesHandler registering for WatchKit sessions")
        
        if (WCSession.isSupported()) {
            session = WCSession.defaultSession()
            session.delegate = self;
            session.activateSession()
        }
    }
    
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        print("heard a request from the watch")

         let reqType = message["request-type"] as! String
         let sharedInstance = SFRestAPI.sharedInstance()
        
        if(reqType == "all-properties") {
          sharedInstance.performSOQLQuery(PropertiesHandler.soqlGetAllProperties, failBlock: { error in
            //todo: more error handling
            print(error)
            replyHandler(["error" : error!.description])
            
            }) { response in
                
                replyHandler(["success" : JSON(response!).rawString()!])
            }
        }
        else if(reqType == "my-favorites") {
            
            sharedInstance.performSOQLQuery(PropertiesHandler.soqlGetMyFavorites, failBlock: { error in
            //todo: more error handling
            print(error)
            replyHandler(["error" : error!.description])
            
        }) { response in
            
            replyHandler(["success" : JSON(response!).rawString()!])
            }

        }
    }
    
}