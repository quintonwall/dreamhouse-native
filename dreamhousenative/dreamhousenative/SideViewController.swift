//
//  ViewController.swift
//  dreamhousenative
//
//  Created by Quinton Wall on 7/20/16.
//  Copyright © 2016 Quinton Wall. All rights reserved.
//

import UIKit

class SideViewController: UIViewController {

   // @IBOutlet weak var tableView: UITableView!
    
    let kInset:CGFloat = 100.0
    var selectedMenuItem : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       // tableView.contentInset = UIEdgeInsetsMake(kInset, 0, 0, 0)
        //tableView.scrollsToTop = false
       // tableView.contentInset = UIEdgeInsetsMake(64.0, 0, 0, 0) //
       // tableView.separatorStyle = .None
       // tableView.backgroundColor = UIColor.clearColor()
      //  tableView.scrollsToTop = false
        
        // Preserve selection between presentations
       // tableView.clearsSelectionOnViewWillAppear = false
        
        //tableView.selectRowAtIndexPath(NSIndexPath(forRow: selectedMenuItem, inSection: 0), animated: false, scrollPosition: .Middle)
   
    }

}

