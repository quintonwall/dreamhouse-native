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



class PropertiesHandler {
    
    static let soqlGetAllProperties = String("select Address__c, Baths__c, Beds__c, Broker__c, Broker__r.Title__c, Broker__r.Name, Broker__r.Picture__c, City__c, Description__c, Id, Location__c, Name, OwnerId, Picture__c, Price__c, State__c, Thumbnail__c, Title__c, Zip__c, (select id, Property__c from Favorites__r) from Property__c")
    
    static func getAllProperties() -> [Property] {
        
        var responseJSON :JSON = JSON("")
        var allProps = [Property]()
        
         let sharedInstance = SFRestAPI.sharedInstance()
        
          sharedInstance.performSOQLQuery(self.soqlGetAllProperties, failBlock: { error in
            //todo: more error handling
            print(error)
            
        }) { response in
               responseJSON = JSON(response!["records"]!)
            for (_,subJSON):(String,JSON) in responseJSON {
                   allProps.append(prepProperty(subJSON))
                }
                print("Fetched \(allProps.count) properties")
            
        }
        return allProps
    }
    
    static func getPropertyById(propertyId: String) -> Property {
        return Property()
    }
    
    static func prepProperty(jsonRecord: JSON) -> Property {
        let p : Property = Property()
        //propertyInfo
        p.propertyId = jsonRecord["Id"].string
        p.address = jsonRecord["Address__c"].string
        p.city = jsonRecord["Id"].string
        p.state = jsonRecord["State__c"].string
        p.description = jsonRecord["Description__c"].string
        p.pictureImageURL = jsonRecord["Picture__c"].string
        p.price = jsonRecord["Price__c"].currency
        p.thumbnailImageURL = jsonRecord["Thumbnail__c"].string
        p.title = jsonRecord["Title__c"].string
        p.zip = jsonRecord["Zip__c"].string
        p.numberOfBaths = jsonRecord["Baths__c"].int
        p.numberOfBeds = jsonRecord["Beds__c"].int
        p.longitude = jsonRecord["Location__c"]["longitude"].double
        p.latitude = jsonRecord["Location__c"]["latitude"].double
        
        //broker info
        p.brokerId = jsonRecord["Broker__c"].string
        p.brokerName = jsonRecord["Broker__r"]["Name"].string
        p.brokerTitle = jsonRecord["Broker__r"]["Title__c"].string
        p.brokerImageURL  = jsonRecord["Broker__r"]["Picture__c"].string
        
        if( jsonRecord["Favorites__r"] != nil) {
            p.favoriteId =  jsonRecord["Favorites__r"]["records"][0]["Id"].string
            p.isFavorite = true
        }
        
        return p
        
    }
}