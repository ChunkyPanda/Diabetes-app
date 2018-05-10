//
//  FeelingsLogViewController.swift
//  Diabetes
//
//  Created by Arrington, Darryn on 8/17/17.
//  Copyright © 2017 Malhotra, Neil. All rights reserved.
//

import Foundation
import UIKit

class FeelingsLogViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let daySpentFeelings = ["Loved One", "Family", "Hobby", "Home", "Shopping", "Music", "Pets", "Coffee/Food", "Work", "Exercise", "Games", "Travel"]
    
    @IBOutlet weak var daySpentFeelingsDisplay: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    
    @IBOutlet weak var feelingsLogTextView: UITextView!
    
    var inputFeelingValue: Int = 0
    
    
    @IBAction func saveFeelingNote(_ sender: Any) {
        let feelingValue : String
        let dayActivity : String
        let note : String
        
        //If user leaves any field blank
        switch inputFeelingValue {
        case 0:
            feelingValue = "happy"
        case 1:
            feelingValue = "stressed"
        case 2:
            feelingValue = "sick"
        case 3:
            feelingValue = "sad"
        case 4:
            feelingValue = "angry"
        default:
            feelingValue = ""
            break
        }
        
        if daySpentFeelingsDisplay.text! == "" {
            dayActivity = "Not disclosed"
        }
        else {
            dayActivity = daySpentFeelingsDisplay.text!
        }
        
        if notesTextView.text! == "" {
            note = "n/a"
        }
        else {
            note = notesTextView.text!
        }
        
        let sample : FeelingReadings = FeelingReadings(fv: feelingValue, da: dayActivity, nt: note)
        feelingReadingsArray.append(sample)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return daySpentFeelings[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return daySpentFeelings.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        daySpentFeelingsDisplay.text = daySpentFeelings[row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if feelingsLogTextView != nil {
            for x in feelingReadingsArray
            {
                feelingsLogTextView.text.append("\(x.feelingValue) \n\(x.dayActivity) \n\(x.note)\n\n")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
