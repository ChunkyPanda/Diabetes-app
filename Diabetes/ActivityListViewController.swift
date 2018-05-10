//
//  ActivityListViewController.swift
//  Diabetes
//
//  Created by Arrington, Darryn on 8/15/17.
//  Copyright © 2017 Malhotra, Neil. All rights reserved.
//

import Foundation
import UIKit

class ActivityListViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var activityListLabel: UILabel!
    @IBOutlet weak var activityListPicker: UIPickerView!
    
    
    let listActivityList = ["Aerobics", "Basketball", "Cycling", "Dancing", "Fencing", "Hiking", "Jogging", "Martial Arts", "Walking", "Yoga", "Other"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return listActivityList[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listActivityList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        activityListLabel.text = listActivityList[row]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "activityToData"
        {
            let nextScene = segue.destination as? ActivityViewController
            if activityListLabel.text != "Other"
            {
                nextScene?.initialActivityName = activityListLabel.text!
            }
            else
            {
                nextScene?.initialActivityName = ""
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityListLabel.text = listActivityList[0]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
