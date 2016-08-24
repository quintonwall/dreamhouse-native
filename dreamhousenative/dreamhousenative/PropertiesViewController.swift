//
//  PropertiesTableViewController.swift
//  dreamhousenative
//
//  Created by QUINTON WALL on 7/26/16.
//  Copyright © 2016 Quinton Wall. All rights reserved.
//

import UIKit
import ENSwiftSideMenu
//import SalesforceRestAPI
import SwiftyJSON

class PropertiesViewController: UIViewController, ENSideMenuDelegate {
    
  
    @IBOutlet weak var tableView: UITableView!
  
    var responseJSON: JSON = JSON("")
    var recordCount: Int = 0
    var selectedProperty: Property?

    //adding our own refresh control because we are not in a UITableViewController
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(PropertiesViewController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    // MARK: -
    // MARK: Side Menu
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sideMenuController()?.sideMenu?.delegate = self
    }
    @IBAction func hamburgerTapped(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    // MARK: -
    
    override func loadView() {
        super.loadView()
        
        
       // tableView = UITableView(frame: view.bounds, style: .Plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        tableView.separatorColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 231/255.0, alpha: 1.0)
        tableView.backgroundColor = UIColor(red: 250/255.0, green: 250/255.0, blue: 251/255.0, alpha: 1.0)
        self.tableView.addSubview(self.refreshControl)
        view.addSubview(tableView)
        
        fetchProperties()
    }
    
    
   // deinit {
    //    tableView.dg_removePullToRefresh()
  //  }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        fetchProperties()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    // MARK: -
    // MARK: Salesforce Calls
    private func fetchProperties() {
        print("fetching properties")
        let sharedInstance = SFRestAPI.sharedInstance()
        
        //NOTE: Since we are using community users, make sure the profile in the org has Property__c included!
        //fetch everything we need here for the details view as well. This way we avoid a second round trip to the server.
        sharedInstance.performSOQLQuery(PropertiesHandler.soqlGetAllProperties, failBlock: { error in
            
            let alertController = UIAlertController(title: "Error", message: error!.description, preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                print("OK")
            }
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            
            
        }) { response in  //success
            
           self.responseJSON = JSON(response!)
            
            
            if let count = self.responseJSON["totalSize"].int {
                self.recordCount = count
            }
            
            if self.recordCount == 0 {
                let alertController = UIAlertController(title: "Bummer!", message: "There are currently no properties available.", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                    print("OK")
                }
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView?.reloadData()
           }
        
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PropertyDetails" {
            let detailsViewController = segue.destinationViewController as! PropertyDetailsViewController
            detailsViewController.property = self.selectedProperty
        }
    }
    
}

// MARK: -
// MARK: UITableView Data Source

extension PropertiesViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = responseJSON["totalSize"].int {
            recordCount = count
        }
        return recordCount
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PropertyCell", forIndexPath: indexPath) as! PropertiesTableViewCell
        
        
        cell.property = Property(jsonRecord: responseJSON["records"][indexPath.row])
        cell.isFavorite = cell.property!.isFavorite
    
        
        cell.propertyImageUrl = responseJSON["records"][indexPath.row]["Thumbnail__c"].string!
        
        cell.propertyId = responseJSON["records"][indexPath.row]["Id"].string
        cell.titleLabel.text = responseJSON["records"][indexPath.row]["Title__c"].string
        cell.cityStateLabel.text = responseJSON["records"][indexPath.row]["City__c"].string! + ", "+responseJSON["records"][indexPath.row]["State__c"].string!
        
        cell.priceLabel.text = responseJSON["records"][indexPath.row]["Price__c"].currency
        return cell
        

    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
       
        
         let cell = tableView.cellForRowAtIndexPath(indexPath) as! PropertiesTableViewCell
        
        if(!cell.property!.isFavorite) {
            let favAction = UITableViewRowAction(style: .Normal, title: "Favorite") { action, index in
                
                let d : NSDictionary = cell.getDictionaryToSaveFavorite()
                let request = SFRestAPI.sharedInstance().requestForCreateWithObjectType("Favorite__c", fields: d as? [String : AnyObject] )
                
                SFRestAPI.sharedInstance().sendRESTRequest(request, failBlock: { error in
                    dispatch_async(dispatch_get_main_queue()) {
                        tableView.setEditing(false, animated: true)
                    }
                    let alertController = UIAlertController(title: "Dreamhouse", message:   "Something went wrong: \(error)", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                }) {response in
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        tableView.setEditing(false, animated: true)
                    }
                    let alertController = UIAlertController(title: "Dreamhouse", message:   "Added to favorites.", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                }
            }
            favAction.backgroundColor = AppDefaults.dreamhouseDarkBlue
            return [favAction]
            
        } else {
            let unfavAction = UITableViewRowAction(style: .Normal, title: "Unfavorite") { action, index in
                
                let request = SFRestAPI.sharedInstance().requestForDeleteWithObjectType("Favorite__c", objectId: cell.property!.favoriteId!)
                
                SFRestAPI.sharedInstance().sendRESTRequest(request, failBlock: { error in
                    dispatch_async(dispatch_get_main_queue()) {
                        tableView.setEditing(false, animated: true)
                    }
                    let alertController = UIAlertController(title: "Dreamhouse", message:   "Something went wrong: \(error)", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                
                 }) {response in
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        tableView.setEditing(false, animated: true)
                    }
                    let alertController = UIAlertController(title: "Dreamhouse", message:   "Removed from favorites.", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
              }
            }
            unfavAction.backgroundColor = AppDefaults.dreamhouseLightBlue
            return [unfavAction]

        }
    }
}

// MARK: -
// MARK: UITableView Delegate

extension PropertiesViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! PropertiesTableViewCell
         selectedProperty = cell.property
        performSegueWithIdentifier("PropertyDetails", sender: self)
        
    }
    
}
