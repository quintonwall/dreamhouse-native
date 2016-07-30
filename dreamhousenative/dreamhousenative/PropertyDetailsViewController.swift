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
import MapKit
import Spring



class PropertyDetailsViewController : UIViewController, ENSideMenuDelegate {
    
    var property: Property?
    let regionRadius: CLLocationDistance = 150
    var propertyLocation : CLLocation?
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var bathroomView: UIView!
    @IBOutlet weak var bedroomsView: UIView!
    @IBOutlet weak var askingpriceView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var buttonBarView: UIView!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var propertyImage: UIImageView!
    @IBOutlet weak var numBedroomsLabel: UILabel!
    @IBOutlet weak var numBathsLabel: UILabel!
    @IBOutlet weak var askingPriceLabel: UILabel!
    @IBOutlet weak var brokerNameLabel: UILabel!
    @IBOutlet weak var brokerTitleLabel: UILabel!
    @IBOutlet weak var brokerProfileImage: UIImageView!
    
    //button bar
    @IBOutlet weak var liveAgentButton: SpringButton!
    @IBOutlet weak var shareButton: SpringButton!
    @IBOutlet weak var favoriteButton: SpringButton!
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //fetch the image first to kick of the fetch thread
        self.propertyImage.sd_setImageWithURL(NSURL(string: property!.pictureImageURL!), placeholderImage: UIImage(named: "full-size-icon"))
        
        
        mapView.layer.cornerRadius = mapView.frame.size.height / 2
        mapView.layer.masksToBounds = true
        mapView.layer.borderColor = AppDefaults.dreamhouseGreen.CGColor
        mapView.layer.borderWidth = 2.0
        
        
        titleLabel.text = property?.title
        descriptionLabel.text = property?.description
        
        numBathsLabel.text = property?.numberOfBaths?.stringValue
        
         numBedroomsLabel.text = property?.numberOfBeds?.stringValue
        
        askingPriceLabel.text = property?.price
        
        brokerNameLabel.text = property?.brokerName
        brokerTitleLabel.text = property?.brokerTitle
        brokerProfileImage.sd_setImageWithURL(NSURL(string: property!.brokerImageURL!))
        brokerProfileImage.layer.cornerRadius = brokerProfileImage.frame.size.height / 2
        brokerProfileImage.layer.masksToBounds = true
        brokerProfileImage.layer.borderColor = AppDefaults.dreamhouseBlreen.CGColor
        brokerProfileImage.layer.borderWidth = 1.0
        
        
       self.backgroundImage.sd_setImageWithURL(NSURL(string: property!.pictureImageURL!) )
        backgroundImage.blurImageLightly()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sideMenuController()?.sideMenu?.delegate = self
        
        //set the map after load for nice zoom effect.
        propertyLocation = CLLocation(latitude: self.property!.latitude!, longitude: self.property!.longitude!)
        centerMapOnLocation(propertyLocation!)
        
    }
    
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius * 2.0, regionRadius * 2.0)
         let objectAnnotation = MKPointAnnotation()
        objectAnnotation.coordinate = location.coordinate
        objectAnnotation.title = property?.title
        self.mapView.addAnnotation(objectAnnotation)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    //MARK: - 
    //MARK: Button Actions
    @IBAction func liveAgentTapped(sender: AnyObject) {
        let btn: SpringButton = sender as! SpringButton
        btn.animation = "zoomOut"
        btn.animate()
        btn.animation = "zoomIn"
        btn.animate()
        
       // https://salesforcesos.com/ios/service-sdk/1.0.0/service_sdk_ios/ios_sos_quick_start.htm
        //https://help.salesforce.com/apex/HTViewHelpDoc?id=service_presence_add_presence_widget_to_console.htm&language=th
        

        SOSSessionManager.sharedInstance().startSessionWithOptions(AppDefaults.getSOSOptions())
        //SCSServiceCloud.sharedInstance().sos.startSessionWithOptions(options)
    }
    
    @IBAction func shareButtonTapped(sender: AnyObject) {
        let btn: SpringButton = sender as! SpringButton
        btn.animation = "zoomOut"
        btn.animate()
        btn.animation = "zoomIn"
        btn.animate()
    }
    
    @IBAction func favoriteButtonTapped(sender: AnyObject) {
        let btn: SpringButton = sender as! SpringButton
        btn.animation = "zoomOut"
        btn.animate()
        btn.animation = "zoomIn"
        btn.animate()
    }
    
    
    
}
