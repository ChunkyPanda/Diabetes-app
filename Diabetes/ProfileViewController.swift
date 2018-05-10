//
//  ProfileViewController.swift
//  Diabetes
//
//  Created by Arrington, Darryn on 11/28/17.
//  Copyright © 2017 Malhotra, Neil. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAnalytics

class ProfileViewController: UITableViewController
{
    @IBOutlet weak var userTextDisplay: UITextView!
    
    @IBAction func createCSV(_ sender: Any) {
        let fileName = "DoctorsNote.csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        let csvLineOne = "Date,Time,Name,Email,Height,Weight,Glucose Reading,Steps,Calories Consumed,Carbs Consumed,Fat Consumed,Sugar Consumed,Sleep\n"
        
        let date = Date()
        let hour = Calendar.current.component(.hour, from: date)
        let minutes = Calendar.current.component(.minute, from: date)
        
        let csvLineTwo = "\(date),\(hour):\(minutes),\(theUser.name),\(theUser.email),\(theUser.heightFeet)ft \(theUser.heightInches)in,\(theUser.weight),\(glucoseGlobal),\(totalSteps),\(totalCal),\(totalCarbs),\(totalFat),\(totalSugar),\(sleepGlobal)\n"
        
        let csvText = csvLineOne + csvLineTwo
        
        do {
            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
        }
        catch {
            print("Failed to create file")
            print("\(error)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let textString = "Name: Your Name\n" + "Email: yourname@something.com\n" + "Height: 5\' 8\"\n" + "Weight: 150lbs\n\n"
        let textString2 = "Steps Goal: 2000 steps\n" + "Time Goal: 60.0 minutes\n\n" + "Calories Goal: 1000g\n" + "Carbs Goal: 100g\n" + "Sugar Goal: 100g\n" + "Fat Goal: 100g\n\n" + "Sleep Goal: 8.0 hours\n"
        userTextDisplay.text = textString + textString2
        
        Analytics.logEvent("profile_opened", parameters: nil)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        let userDefault = UserDefaults.standard
        if let decodedData = userDefault.object(forKey: "theUser") as? Data
        {
            if let x = NSKeyedUnarchiver.unarchiveObject(with: decodedData) as? UserProfile
            {
                let textString = "Name: \(x.name)\n" + "Email: \(x.email)\n" + "Height: \(x.heightFeet)\' \(x.heightInches)\"\n" + "Weight: \(x.weight)lbs\n\n"
                let textString2 = "Steps Goal: \(x.stepsGoal) steps\n" + "Time Goal: \(x.timeGoal) minutes\n\n" + "Calories Goal: \(x.caloriesGoal)g\n" + "Carbs Goal: \(x.carbsGoal)g\n" + "Sugar Goal: \(x.sugarGoal)g\n" + "Fat Goal: \(x.fatGoal)g\n\n" + "Sleep Goal: \(x.sleepGoal) hours\n"
                userTextDisplay.text = textString + textString2
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
