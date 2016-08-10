//
//  BrokerSelectionViewController.swift
//  DHNative
//
//  Created by QUINTON WALL on 7/31/16.
//  Copyright © 2016 Quinton Wall. All rights reserved.
//

import UIKit
//import SalesforceSDKCore
//import SalesforceRestAPI
import SwiftyJSON
import ENSwiftSideMenu



class BrokerSelectionViewController: JFCardSelectionViewController, ENSideMenuDelegate {
    
    var recordCount: Int = 0
    var responseJSON: JSON = JSON("")
    //if set, we got the request from another screen and need to show that brokers card.
    var brokerId : String?
    
    var cards: [Broker]? {
        didSet {
            // Call `reloadData()` once you are ready to display your `CardPresentable` data or when there have been changes to that data that need to be represented in the UI.
           // dispatch_async(dispatch_get_main_queue()) {
           //     self.reloadData()
           // }
        }
    }
    
    override func viewDidLoad() {
        
        // You can set a permanent background by setting a UIImage on the `backgroundImage` property. 
        //If not set, the `backgroundImage` will be set using the currently selected Card's `imageURLString`.  NOTE: its buggy. every 2nd image doesnt get set
        backgroundImage = UIImage(named: "grass")

        
        // Set the datasource so that `JFCardSelectionViewController` can get the CardPresentable data you want to dispaly
        dataSource = self
        
        // Set the delegate so that `JFCardSelectionViewController` can notify the `delegate` of events that take place on the focused CardPresentable.
        delegate = self
        
        // Set the desired `JFCardSelectionViewSelectionAnimationStyle` to either `.Slide` or `.Fade`. Defaults to `.Fade`.
        selectionAnimationStyle = .Slide
        
        // Call up to super after configuring your subclass of `JFCardSelectionViewController`. Calling super before configuring will cause undesirable side effects.
        super.viewDidLoad()
        self.sideMenuController()?.sideMenu?.delegate = self
        
    }
    

    @IBAction func hamburgerTapped(sender: AnyObject) {
        toggleSideMenuView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        /*
         NOTE: If you are displaying an instance of `JFCardSelectionViewController` within a `UINavigationController`, you can use the code below to hide the navigation bar. This isn't required to use `JFCardSelectionViewController`, but `JFCardSelectionViewController` was designed to be used without a UINavigationBar.
         let image = UIImage()
         let navBar = navigationController?.navigationBar
         navBar?.setBackgroundImage(image, forBarMetrics: .Default)
         navBar?.shadowImage = image
         */
        fetchBrokers()
    }
    
    private func fetchBrokers() {
        print("fetching brokers")
        let sharedInstance = SFRestAPI.sharedInstance()
        
        let query = String("select Email__c, Id, Mobile_Phone__c, Name,  Phone__c, Picture__c, Title__c from Broker__c where IsDeleted = false Order By Name")
        
        
        sharedInstance.performSOQLQuery(query, failBlock: { error in
            
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
                let alertController = UIAlertController(title: "Bummer!", message: "There are currently no brokers available.", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                    print("OK")
                }
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                
            }
            
            
            var tmpCards : [Broker]? = []
            
            for (_,subJson):(String, JSON) in self.responseJSON["records"] {
                
                let b : Broker = Broker(id: subJson["Id"].string!, name: subJson["Name"].string!, photoURL: subJson["Picture__c"].string!, jobTitle: subJson["Title__c"].string!, phoneOffice: subJson["Phone__c"].string!, phoneCell: subJson["Mobile_Phone__c"].string!, email: subJson["Email__c"].string!)
                if(self.brokerId != nil && b.id == self.brokerId) {
                    tmpCards?.insert(b, atIndex: 0) //set the selectedbroker first
                } else {
                    tmpCards?.append(b)
                }
            }
            self.cards = tmpCards
            
            dispatch_async(dispatch_get_main_queue()) {
                self.reloadData()
            }
        }
    }

}

extension BrokerSelectionViewController: JFCardSelectionViewControllerDataSource {
    
    func numberOfCardsForCardSelectionViewController(cardSelectionViewController: JFCardSelectionViewController) -> Int {
        return cards?.count ?? 0
    }
    
    func cardSelectionViewController(cardSelectionViewController: JFCardSelectionViewController, cardForItemAtIndexPath indexPath: NSIndexPath) -> CardPresentable {
        return cards?[indexPath.row] ?? Broker(id: "0000", name: "blank card", photoURL: "", jobTitle: "", phoneOffice: "", phoneCell: "", email: "")
    }
    
}


extension BrokerSelectionViewController: JFCardSelectionViewControllerDelegate {
    
   
    
    func cardSelectionViewController(cardSelectionViewController: JFCardSelectionViewController, didSelectCardAction cardAction: CardAction, forCardAtIndexPath indexPath: NSIndexPath) {
        let card = cards![indexPath.row]
        if let action = card.actionOne where action.title == cardAction.title {
            print("----------- \nCard action fired! \nAction Title: \(cardAction.title) \nIndex Path: \(indexPath)")
        }
        if let action = card.actionTwo where action.title == cardAction.title {
            print("----------- \nCard action fired! \nAction Title: \(cardAction.title) \nIndex Path: \(indexPath)")
        }
    }
    
    func cardSelectionViewController(cardSelectionViewController: JFCardSelectionViewController, didSelectDetailActionForCardAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("ShowUserDetailVC", sender: indexPath)
    }
}
