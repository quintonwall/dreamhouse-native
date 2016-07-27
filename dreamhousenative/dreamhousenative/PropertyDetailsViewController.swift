//
//  PropertyDetailsViewController.swift
//  DHNative
//
//  Created by QUINTON WALL on 7/27/16.
//  Copyright © 2016 Quinton Wall. All rights reserved.
//

import UIKit
import ENSwiftSideMenu
import SDWebImage

class PropertyDetailsViewController : UIViewController, ENSideMenuDelegate {
    
    var property: Property?
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var bathroomView: UIView!
    @IBOutlet weak var bedroomsView: UIView!
    @IBOutlet weak var askingpriceView: UIView!
    
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var propertyImage: UIImageView!
    @IBOutlet weak var numBedroomsLabel: UILabel!
    @IBOutlet weak var numBathsLabel: UILabel!
    @IBOutlet weak var askingPriceLabel: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.propertyImage.sd_setImageWithURL(NSURL(string: property!.pictureImageURL!))
        
       // titleView.layer.borderWidth = 1
        //titleView.layer.borderColor = AppDefaults.dreamhouseBlreen.CGColor
        titleLabel.text = property?.title
        descriptionLabel.text = property?.description
        
        //bathroomView.layer.borderWidth = 1
       // bathroomView.layer.borderColor = AppDefaults.dreamhouseBlreen.CGColor
        numBathsLabel.text = property?.numberOfBaths?.stringValue
        
       // bedroomsView.layer.borderWidth = 1
        //bedroomsView.layer.borderColor = AppDefaults.dreamhouseBlreen.CGColor
        numBedroomsLabel.text = property?.numberOfBeds?.stringValue
        
        //askingpriceView.layer.borderWidth = 1
        //askingpriceView.layer.borderColor = AppDefaults.dreamhouseBlreen.CGColor
        askingPriceLabel.text = property?.price
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sideMenuController()?.sideMenu?.delegate = self
    }
    
    
}
