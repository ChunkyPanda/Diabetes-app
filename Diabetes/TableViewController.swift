//
//  TableViewController.swift
//  Diabetes
//
//  Created by Shirsat, Amit on 8/23/17.
//  Copyright © 2017 Malhotra, Neil. All rights reserved.
//

import UIKit
import Parse
import ParseUI
class TableViewController: PFQueryTableViewController {
    // Initialise the PFQueryTable tableview
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        // Configure the PFQueryTableView
        self.parseClassName = "Medication"
        self.textKey = "MedicationName"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }
    
    
}
