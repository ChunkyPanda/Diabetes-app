//
//  AlertsViewController.swift
//  Diabetes
//
//  Created by Arrington, Darryn on 8/11/17.
//  Copyright © 2017 Malhotra, Neil. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAnalytics

var listAlerts = ["Run 3.0 miles", "Don't forget to log glucose levels"]

class AlertsViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var alertTableView: UITableView!
    
    @IBOutlet weak var alertAddTextField: UITextView!
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count: Int?
        
        if tableView == self.alertTableView {
            count = listAlerts.count
        }
        
        return count!
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        
        if(tableView == self.alertTableView) {
            cell = tableView.dequeueReusableCell(withIdentifier: "cellAlert", for: indexPath)
            cell!.textLabel!.text = listAlerts[indexPath.row]
        }
        
        return cell!
    }
    
    @IBAction func addAlert(_ sender: Any) {
        if alertAddTextField.text != "" {
            listAlerts.append(alertAddTextField.text)
        }
        
        UserDefaults.standard.set(listAlerts, forKey: "alertsList")
        Analytics.logEvent("alert_added", parameters: ["alert_desc" : alertAddTextField.text])
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let x = UserDefaults.standard.object(forKey: "alertsList") as? [String] {
            listAlerts = x
        }
        
        Analytics.logEvent("alerts_opened", parameters: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
