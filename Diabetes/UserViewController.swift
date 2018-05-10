//
//  UserViewController.swift
//  Diabetes
//
//  Created by Arrington, Darryn on 8/8/17.
//  Copyright © 2017 Malhotra, Neil. All rights reserved.
//

import Foundation
import UIKit

class UserViewController : UITableViewController {
    
    @IBOutlet weak var userTextDisplay: UITextView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefault = UserDefaults.standard
        if let decodedData = userDefault.object(forKey: "theUser") as? Data
        {
            if let x = NSKeyedUnarchiver.unarchiveObject(with: decodedData) as? UserProfile
            {
                let textString = "Name: \(x.name)\n" + "Email: \(x.email)\n" + "Height: \(x.heightFeet)\' \(x.heightInches)\"\n" + "Weight: \(x.weight)lbs\n"
                userTextDisplay.text = textString
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
