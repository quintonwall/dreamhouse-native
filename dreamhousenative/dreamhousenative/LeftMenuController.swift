//
//  LeftMenuController.swift
//  dreamhousenative
//
//  Created by QUINTON WALL on 7/26/16.
//  Copyright © 2016 Quinton Wall. All rights reserved.
//

import UIKit

class LeftMenuController: UITableViewController {

    let kInset:CGFloat = 64.0
    var selectedMenuItem : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.contentInset = UIEdgeInsetsMake(kInset, 0, 0, 0)
        //tableView.scrollsToTop = false
        // tableView.separatorStyle = .None
        // tableView.backgroundColor = UIColor.clearColor()
        //  tableView.scrollsToTop = false
        
        // Preserve selection between presentations
        // tableView.clearsSelectionOnViewWillAppear = false
        
        //tableView.selectRowAtIndexPath(NSIndexPath(forRow: selectedMenuItem, inSection: 0), animated: false, scrollPosition: .Middle)
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("did select row: \(indexPath.row)")
        
        if (indexPath.row == selectedMenuItem) {
            return
        }
        
        selectedMenuItem = indexPath.row
        
        //Present new view controller
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        var destViewController : UIViewController
        switch (indexPath.row) {
        case 0:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("WelcomeView")
            break
        case 1:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("PropertiesListView")
            break
        case 2:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ViewController3")
            break
        default:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ViewController4")
            break
        }
        sideMenuController()?.setContentViewController(destViewController)
    }


}
