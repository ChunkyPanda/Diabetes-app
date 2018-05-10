//
//  SideMenuViewController.swift
//  Diabetes
//
//  Created by Malhotra, Neil on 10/2/17.
//  Copyright © 2017 Malhotra, Neil. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class SideMenuViewController: UITableViewController{
    
    let list = ["Home", "Profile", "Community", "Knowledge place", "Reset Data"]
    
    
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return(list.count)
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = list[indexPath.row]
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row==2)
        {
            performSegue(withIdentifier: "CommunitySegue", sender :self)
            
        }
        
        if(indexPath.row==3)
        {
            performSegue(withIdentifier: "MarketplaceSegue", sender: self)
        }
        if(indexPath.row==0)
        {
            performSegue(withIdentifier: "HomeSegue2", sender: self)
        }
        if(indexPath.row==4)
        {
            performSegue(withIdentifier: "HomeSegue2", sender: self)
            
            let userDefault = UserDefaults.standard
            
            breakfastList.removeAll()
            lunchList.removeAll()
            dinnerList.removeAll()
            snacksList.removeAll()
            
            var encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: breakfastList)
            userDefault.set(encodedData, forKey: "breakfastList")
            userDefault.synchronize()
            
            encodedData = NSKeyedArchiver.archivedData(withRootObject: breakfastList)
            userDefault.set(encodedData, forKey: "lunchList")
            userDefault.synchronize()
            
            encodedData = NSKeyedArchiver.archivedData(withRootObject: breakfastList)
            userDefault.set(encodedData, forKey: "dinnerList")
            userDefault.synchronize()
            
            encodedData = NSKeyedArchiver.archivedData(withRootObject: breakfastList)
            userDefault.set(encodedData, forKey: "snacksList")
            userDefault.synchronize()
            
            
            listActivity.removeAll()
            encodedData = NSKeyedArchiver.archivedData(withRootObject: listActivity)
            userDefault.set(encodedData, forKey: "activityList")
            userDefault.synchronize()
            
            addToCaloriesBurned = 0.0
            UserDefaults.standard.set(addToCaloriesBurned, forKey: "addToCaloriesBurned")
            
            carbsGlobal = 0.0
            addToCarbs = 0.0
            sugarGlobal = 0.0
            fatGlobal = 0.0
            caloriesGlobal = 0.0
            
            UserDefaults.standard.set(highGlucose, forKey: "addToCarbs")
            
            totalCarbs = 0
            totalFat = 0
            totalSugar = 0
            totalCal = 0
            
            readingsNum = 0
            glucoseGlobal = 0.0
            avgGlucose = 0
            highGlucose = 0
            lowGlucose = 0
            
            UserDefaults.standard.set(readingsNum, forKey: "glucoseReadingNumber")
            UserDefaults.standard.set(lowGlucose, forKey: "glucoseLowReading")
            UserDefaults.standard.set(avgGlucose, forKey: "glucoseAvgReading")
            UserDefaults.standard.set(highGlucose, forKey: "glucoseHighReading")
            UserDefaults.standard.set(glucoseGlobal, forKey: "glucoseGlobal")
            
            
            list1.removeAll()
            list1 = ["Breakfast", "Lunch", "Dinner", "Snack(s)"]
            UserDefaults.standard.set("Breakfast", forKey: "breakfastListDisplay")
            UserDefaults.standard.set("Lunch", forKey: "lunchListDisplay")
            UserDefaults.standard.set("Dinner", forKey: "dinnerListDisplay")
            UserDefaults.standard.set("Snack(s)", forKey: "snacksListDisplay")
            
            UserDefaults.standard.set(totalCal, forKey: "nutritionTotalCal")
            UserDefaults.standard.set(totalCarbs, forKey: "nutritionTotalCarbs")
            UserDefaults.standard.set(totalSugar, forKey: "nutritionTotalSugar")
            UserDefaults.standard.set(totalFat, forKey: "nutritionTotalFat")
            
            Analytics.logEvent("data_manual_reset", parameters: nil)
        }
        
        if(indexPath.row==1)
        {
            performSegue(withIdentifier: "ProfileSegue", sender: self)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
