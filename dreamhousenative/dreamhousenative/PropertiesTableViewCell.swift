//
//  PropertiesTableViewCell.swift
//  dreamhousenative
//
//  Created by QUINTON WALL on 7/26/16.
//  Copyright © 2016 Quinton Wall. All rights reserved.
//

import UIKit

class PropertiesTableViewCell: UITableViewCell {

    
    @IBOutlet weak var propertyImage: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cityStateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    
    var propertyId : String!
    
    var propertyImageUrl = "" {
        didSet {
            loadImage(propertyImageUrl)
            
        }
    }
    
    private func loadImage(url:String) {
        // load image
        let image_url:String = url
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            let url:NSURL = NSURL(string:image_url)!
            let data:NSData = NSData(contentsOfURL: url)!
            
            // update ui
            dispatch_async(dispatch_get_main_queue()) {
                let image = UIImage(data: data)!
                self.propertyImage = UIImageView(image: image)
            }
        }
        
    }
}
