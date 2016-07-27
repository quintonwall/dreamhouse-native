//
//  PropertiesTableViewController.swift
//  dreamhousenative
//
//  Created by QUINTON WALL on 7/26/16.
//  Copyright © 2016 Quinton Wall. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh
import ENSwiftSideMenu
import SalesforceRestAPI
import SwiftyJSON

class PropertiesViewController: UIViewController, ENSideMenuDelegate {
    
  
    @IBOutlet weak var tableView: UITableView!
  
    var responseJSON: JSON = JSON("")
    var recordCount: Int = 0

    
    
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
        view.addSubview(tableView)
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                self?.fetchProperties()
                self?.tableView.dg_stopLoading()
            })
            }, loadingView: loadingView)
        //tableView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshFillColor(AppDefaults.dreamhouseGreen)
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        
        fetchProperties()
    }
    
    deinit {
        tableView.dg_removePullToRefresh()
    }
    
    // MARK: -
    // MARK: Salesforce Calls
    private func fetchProperties() {
        print("fetching properties")
        let sharedInstance = SFRestAPI.sharedInstance()
        
        //NOTE: Since we are using community users, make sure the profile in the org has Property__c included!
        let query = String("select City__c, Id, Name, Picture_IMG__c, Price__c, State__c, Thumbnail__c, Thumbnail_IMG__c, Title__c, Zip__c from Property__c")
        
        
        sharedInstance.performSOQLQuery(query, failBlock: { error in
            
            let alertController = UIAlertController(title: "Error", message: error.description, preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                print("OK")
            }
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            
            
        }) { response in  //success
            
            
            self.responseJSON = JSON(response)
            
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! PropertiesTableViewCell
        cell.propertyImageUrl = responseJSON["records"][indexPath.row]["Thumbnail_IMG__c"].string!
        cell.propertyId = responseJSON["records"][indexPath.row]["Id"].string
        cell.titleLabel.text = responseJSON["records"][indexPath.row]["Title__c"].string
        cell.cityStateLabel.text = responseJSON["records"][indexPath.row]["City__c"].string! + ", "+responseJSON["records"][indexPath.row]["State__c"].string!
        cell.priceLabel.text = responseJSON["records"][indexPath.row]["Price"].currency
        return cell
        

    }
    
}

// MARK: -
// MARK: UITableView Delegate

extension PropertiesViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}
