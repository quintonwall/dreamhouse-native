//
//  Property.swift
//  DHNative
//
//  Created by QUINTON WALL on 7/27/16.
//  Copyright © 2016 Quinton Wall. All rights reserved.
//

import Foundation
import SwiftyJSON


class Property {
    
    //property info
    var propertyId: String?
    var address: String?
    var city: String?
    var state: String?
    var description: String?
    var pictureImageURL: String?
    var price:String?
    var thumbnailImageURL: String?
    var title: String?
    var zip: String?
    var numberOfBaths: Int?
    var numberOfBeds: Int?
    var longitude: Double?
    var latitude: Double?
    var isFavorite: Bool = false
    
    //broker info
    var brokerId: String?
    var brokerName: String?
    var brokerTitle: String?
    var brokerImageURL: String?
    
    //favorite
    var favoriteId: String?
    
    /*
    func getDictionaryToSaveFavorite() -> NSDictionary {
        let d : NSDictionary = [
            "Property__c" : propertyId!,
            "User__c" : AppDefaults.getUserId()
        ]
        
        return d

    }
 */
    
    init(jsonRecord: JSON) {
        //propertyInfo
        self.propertyId = jsonRecord["Id"].string
        self.address = jsonRecord["Address__c"].string
        self.city = jsonRecord["Id"].string
        self.state = jsonRecord["State__c"].string
        self.description = jsonRecord["Description__c"].string
        self.pictureImageURL = jsonRecord["Picture__c"].string
        self.price = jsonRecord["Price__c"].currency
        self.thumbnailImageURL = jsonRecord["Thumbnail__c"].string
        self.title = jsonRecord["Title__c"].string
        self.zip = jsonRecord["Zip__c"].string
        self.numberOfBaths = jsonRecord["Baths__c"].int
        self.numberOfBeds = jsonRecord["Beds__c"].int
        self.longitude = jsonRecord["Location__c"]["longitude"].double
        self.latitude = jsonRecord["Location__c"]["latitude"].double
        
        //broker info
        self.brokerId = jsonRecord["Broker__c"].string
        self.brokerName = jsonRecord["Broker__r"]["Name"].string
        self.brokerTitle = jsonRecord["Broker__r"]["Title__c"].string
        self.brokerImageURL  = jsonRecord["Broker__r"]["Picture__c"].string
        
        if( jsonRecord["Favorites__r"] != nil) {
            self.favoriteId =  jsonRecord["Favorites__r"]["records"][0]["Id"].string
            self.isFavorite = true
        }

    }
    
}