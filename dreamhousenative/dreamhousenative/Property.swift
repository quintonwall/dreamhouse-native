//
//  Property.swift
//  DHNative
//
//  Created by QUINTON WALL on 7/27/16.
//  Copyright © 2016 Quinton Wall. All rights reserved.
//

import Foundation


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
}