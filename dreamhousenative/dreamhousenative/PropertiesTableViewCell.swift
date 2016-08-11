//
//  PropertiesTableViewCell.swift
//  dreamhousenative
//
//  Created by QUINTON WALL on 7/26/16.
//  Copyright © 2016 Quinton Wall. All rights reserved.
//

import UIKit
import SDWebImage

class PropertiesTableViewCell: UITableViewCell {

    
    @IBOutlet weak var propertyImage: UIImageView!
    @IBOutlet weak var favoriteIndicatorImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cityStateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var property : Property?
    
    var propertyId : String!
    
    var isFavorite : Bool  = false {
        didSet {
            if (isFavorite) {
                favoriteIndicatorImage.hidden = false
            } else {
                 favoriteIndicatorImage.hidden = true
                
            }
        }
    }
    
    var propertyImageUrl = "" {
        didSet {
          //use SDWebImage for super fast async image loading and caching.
            //this looks awesome too for animated gif support: https://github.com/kaishin/Gifu
            self.propertyImage.sd_setImageWithURL(NSURL(string: propertyImageUrl), placeholderImage: UIImage(named: "full-size-icon"))
            
        }
    }
    
    override func awakeFromNib() {
        self.propertyImage.layer.cornerRadius = 3.0
        self.propertyImage.layer.masksToBounds = true
         self.propertyImage.layer.borderColor = AppDefaults.dreamhouseGreen.CGColor
        self.propertyImage.layer.borderWidth = 1.0
        
        self.selectedBackgroundView?.backgroundColor = AppDefaults.dreamhouseLightBlue

    }
    
    func getDictionaryToSaveFavorite() -> NSDictionary {
        let d : NSDictionary = [
            "Property__c" : propertyId!,
            "User__c" : AppDefaults.getUserId()
        ]
        
        return d
    
    }
    
}
