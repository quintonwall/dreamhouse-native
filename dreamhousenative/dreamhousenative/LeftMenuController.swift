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

}
