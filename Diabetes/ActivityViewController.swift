//
//  ActivityViewController.swift
//  Diabetes
//
//  Created by Arrington, Darryn on 7/28/17.
//  Copyright © 2017 Malhotra, Neil. All rights reserved.
//

import Foundation
import UIKit
import UICircularProgressRing
import FirebaseAnalytics

var listActivity = [Activity]()
//var listActivity = ["Running 20mins, 2.5 Miles, 350 Cal", "Walk 1121 Steps, 0.3 Miles, 126 Cal"]

class Activity : NSObject, NSCoding {
    
    var activityName: String = "N/A"
    var distance: Double = 0.0
    var time: Double = 0
    var calories: Int = 0
    
    convenience required init?(coder aDecoder: NSCoder) {
        let activityName = aDecoder.decodeObject(forKey: "activityName") as! String
        let distance = aDecoder.decodeDouble(forKey: "activityDistance")
        let time = aDecoder.decodeDouble(forKey: "activityTime")
        let calories = aDecoder.decodeInteger(forKey: "activityCalories")
        
        self.init(activityName: activityName, distance: distance, time: time, calories: calories)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(activityName, forKey: "activityName")
        aCoder.encode(distance, forKey: "activityDistance")
        aCoder.encode(time, forKey: "activityTime")
        aCoder.encode(calories, forKey: "activityCalories")
    }
    
    
    init(activityName: String, distance: Double, time: Double, calories: Int) {
        self.distance = distance
        self.time = time
        self.calories = calories
        self.activityName = activityName
    }
    
    func getActivityName() -> String {
        return self.activityName
    }
    
    func getActivityInfo() -> String {
        let activityString = "\(self.distance) Miles, \(self.time) Mins, \(self.calories) kCal"
        return activityString
    }
}

class ActivityViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var totalDistance: Double = 0.0
    var totalCalories: Int = 0
    var totalTime: Double = exerciseTime
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var activityNameField: UITextField!
    @IBOutlet weak var timeField: UITextField!
    @IBOutlet weak var distanceField: UITextField!
    @IBOutlet weak var caloriesField: UITextField!
    
    @IBOutlet weak var totalDistanceDisplay: UILabel!
    @IBOutlet weak var totalCaloriesDisplay: UILabel!
    
    @IBOutlet weak var stepsGoalDisplay: UILabel!
    @IBOutlet weak var timeGoalDisplay: UILabel!
    
    @IBOutlet weak var stepsProgressRing: UICircularProgressRingView!
    @IBOutlet weak var totalTimeProgressRing: UICircularProgressRingView!
    
    
    
    
    var initialActivityName: String = "N/A"
    
    @IBAction func addActivitySubmitTapped(_ sender: Any) {
        
        var activityName = ""
        var distance = 0.0
        var time = 0.0
        var calories = 0
        
        if activityNameField.text != ""
        {
            activityName = activityNameField.text!
        }
        if distanceField.text != ""
        {
            distance = Double(distanceField.text!)!
        }
        if timeField.text != ""
        {
            time = Double(timeField.text!)!
        }
        if caloriesField.text != ""
        {
            calories = Int(caloriesField.text!)!
        }
        
        let newActivity = Activity(activityName: activityName, distance: distance, time: time, calories: calories)
        
        listActivity.append(newActivity)
        Analytics.logEvent("activity_added", parameters: ["activity_value" : newActivity.activityName])
        
        let userDefault = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: listActivity)
        userDefault.set(encodedData, forKey: "activityList")
        userDefault.synchronize()

    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count: Int?
        
        if tableView == self.tableview {
            count = listActivity.count
        }

        return count!
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        
        if(tableView == self.tableview) {
            cell = tableView.dequeueReusableCell(withIdentifier: "cellActivity", for: indexPath)
            cell!.textLabel!.text = listActivity[indexPath.row].getActivityName() + " " + listActivity[indexPath.row].getActivityInfo()
        }
        
        return cell!
    }
    
    override func viewDidLoad() {
        let userDefault = UserDefaults.standard
        Analytics.logEvent("activity_opened", parameters: nil)
        if let decodedData = userDefault.object(forKey: "activityList") as? Data {
            if let x = NSKeyedUnarchiver.unarchiveObject(with: decodedData) as? [Activity]
            {
                listActivity = x
            }
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if(tableview != nil) {
            self.tableview.reloadData()
        }
        if(stepsGoalDisplay != nil) {
            stepsGoalDisplay.text = "Goal: " + String(theUser.stepsGoal)
        }
        if(timeGoalDisplay != nil) {
            timeGoalDisplay.text = "Goal: " + String(theUser.timeGoal)
        }
        if activityNameField != nil {
            activityNameField.text = initialActivityName
        }
        
        let userDefault = UserDefaults.standard
        if let decodedData = userDefault.object(forKey: "activityList") as? Data
        {
            if let x = NSKeyedUnarchiver.unarchiveObject(with: decodedData) as? [Activity]
            {
                for items in x
                {
                    totalCalories += items.calories
                    totalDistance += items.distance
                    totalTime += items.time
                }
                addToCaloriesBurned = Double(totalCalories)
                UserDefaults.standard.set(addToCaloriesBurned, forKey: "addToCaloriesBurned")
                UserDefaults.standard.set(totalCalories, forKey: "activityCaloriesBurned")
            }
        }
        /*
        UserDefaults.standard.set(totalCalories, forKey: "activityCalories")
        UserDefaults.standard.set(totalDistance, forKey: "activityDistance")
        UserDefaults.standard.set(totalSteps, forKey: "activitySteps")
        UserDefaults.standard.set(totalTime, forKey: "activityTime")
        */
        
        if totalCaloriesDisplay != nil {
            //if let x = UserDefaults.standard.object(forKey: "activityCalories") as? Int
            //{
            if let x = UserDefaults.standard.object(forKey: "activityCaloriesBurned") as? Double
            {
                totalCaloriesDisplay.text = String(Int(caloriesBurnedGlobal) != 0 ? Int(Double(caloriesBurnedGlobal) + addToCaloriesBurned) : Int(x))
                addToCaloriesBurned = 0.0
            }
            else
            {
                totalCaloriesDisplay.text = String(caloriesBurnedGlobal)
            }
            //}
        }
        if totalDistanceDisplay != nil {
            //if let x = UserDefaults.standard.object(forKey: "activityDistance") as? Double
            //{
                totalDistanceDisplay.text = String(totalDistance)
            //}
        }
        
        if stepsProgressRing != nil
        {
            stepsProgressRing.animationStyle = kCAMediaTimingFunctionLinear
            stepsProgressRing.maxValue = CGFloat(theUser.stepsGoal)
            stepsProgressRing.innerRingColor = UIColor.orange
            //if let x = UserDefaults.standard.object(forKey: "activitySteps") as? Int
            //{
                stepsProgressRing.setProgress(value: CGFloat(totalSteps), animationDuration: 2.0)
                {
                    print("Done animating!")
                }
            //}
        }
        
        if totalTimeProgressRing != nil
        {
            totalTimeProgressRing.animationStyle = kCAMediaTimingFunctionLinear
            totalTimeProgressRing.maxValue = CGFloat(theUser.timeGoal)
            totalTimeProgressRing.innerRingColor = UIColor.orange
            //if let x = UserDefaults.standard.object(forKey: "activityTime") as? Int
            //{
                totalTimeProgressRing.setProgress(value: CGFloat(totalTime), animationDuration: 2.0)
                {
                    print("Done animating!")
                }
            //}
        }
        
        
    }

}
