//
//  NutritionViewController.swift
//  DiabetesApp
//
//  Created by Arrington, Darryn on 7/26/17.
//  Copyright © 2017 Arrington, Darryn. All rights reserved.
//

import UIKit
import Foundation
import HealthKit
import UICircularProgressRing
import FirebaseAnalytics

var list1 = ["Breakfast", "Lunch", "Dinner", "Snack(s)"]

//Arrays that will store the foods based on what category they are
var breakfastList = [Food]()
var lunchList = [Food]()
var dinnerList = [Food]()
var snacksList = [Food]()

//The total amount of each measurement displayed on the nutrition front page

var totalCal: Int = 0
var totalCarbs: Int = Int(carbsGlobal)
var totalSugar: Int = Int(sugarGlobal)
var totalFat: Int = Int(fatGlobal)

var foodCategorySegmentInit = 0

class Food : NSObject, NSCoding {
    var name: String
    var calories: Int
    var carbs: Int
    var sugar: Int
    var fat: Int
    
    convenience required init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: "foodName") as! String
        let calories = aDecoder.decodeInteger(forKey: "foodCalories")
        let carbs = aDecoder.decodeInteger(forKey: "foodCarbs")
        let sugar = aDecoder.decodeInteger(forKey: "foodSugar")
        let fat = aDecoder.decodeInteger(forKey: "foodFat")
        
        self.init(name: name, calories: calories, carbs: carbs, sugar: sugar, fat: fat)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "foodName")
        aCoder.encode(calories, forKey: "foodCalories")
        aCoder.encode(carbs, forKey: "foodCarbs")
        aCoder.encode(sugar, forKey: "foodSugar")
        aCoder.encode(fat, forKey: "foodFat")
    }
    
    init(name: String, calories: Int, carbs: Int, sugar: Int, fat: Int) {
        self.name = name
        self.calories = calories
        self.carbs = carbs
        self.sugar = sugar
        self.fat = fat
    }
    
    public func getFoodName() -> String {
        return self.name
    }
    
    public func getFoodInfo() -> String {
        let foodString = "\(self.calories) Cal, \(self.carbs)g Carbs, \(self.sugar)g Sugar, \(self.fat)g Fat"
        
        return foodString
    }
}

class NutritionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableview1: UITableView!
    
    @IBOutlet weak var caloriesDisplayProgressRing: UICircularProgressRingView!
    @IBOutlet weak var carbsDisplayProgressRing: UICircularProgressRingView!
    @IBOutlet weak var sugarDisplayProgressRing: UICircularProgressRingView!
    @IBOutlet weak var fatDisplayProgressRing: UICircularProgressRingView!
    
    @IBOutlet weak var remainingCalories: UILabel!
    @IBOutlet weak var remainingCarbs: UILabel!
    @IBOutlet weak var remainingSugar: UILabel!
    @IBOutlet weak var remainingFat: UILabel!
    
    
    
    //@IBAction func addButtonTapped(_ sender: Any) {
        /*let newFood = Food(name: "Bacon", calories: 20, carbs: 5, sugar: 4, fat: 30)
        
        list1.append(newFood.getFoodName())
        list2.append(newFood.getFoodInfo())
        
        self.tableview1.reloadData()
        self.tableview2.reloadData()
        */
        
    //}
    
    @IBOutlet weak var foodNameField: UITextField!
    @IBOutlet weak var carbsField: UITextField!
    @IBOutlet weak var caloriesField: UITextField!
    @IBOutlet weak var sugarField: UITextField!
    @IBOutlet weak var fatField: UITextField!
    
    @IBOutlet weak var foodCategorySegments: UISegmentedControl!
    
    
    
    @IBAction func addSubmitButtonTapped(_ sender: Any)
    {
        var foodName = ""
        var calories = 0
        var carbs = 0
        var sugar = 0
        var fat = 0
        
        if foodNameField.text != ""
        {
            foodName = foodNameField.text!
        }
        if caloriesField.text != ""
        {
            calories = Int(caloriesField.text!)!
        }
        if carbsField.text != ""
        {
            carbs = Int(carbsField.text!)!
        }
        if sugarField.text != ""
        {
            sugar = Int(sugarField.text!)!
        }
        if fatField.text != ""
        {
            fat = Int(fatField.text!)!
        }
        
        let newFood = Food(name: foodName, calories: calories, carbs: carbs, sugar: sugar, fat: fat)
        
        //Add food to category based on what switch is pressed
        var updatedListString = ""
        
        if foodCategorySegments.selectedSegmentIndex == 0
        {
            breakfastList.append(newFood)
            
            let userDefault = UserDefaults.standard
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: breakfastList)
            userDefault.set(encodedData, forKey: "breakfastList")
            userDefault.synchronize()
            
            var tempCalories: Int = 0
            var tempCarbs: Int = 0
            var tempSugar: Int = 0
            var tempFat: Int = 0
            
            
            for item in breakfastList {
                tempCalories += item.calories
                tempCarbs += item.carbs
                tempSugar += item.sugar
                tempFat += item.fat
            }
            
            
            updatedListString = "Breakfast - \(tempCalories) Cal, \(tempCarbs)g Carbs, \(tempSugar)g Sugar, \(tempFat)g Fat"
            UserDefaults.standard.set(updatedListString, forKey: "breakfastListDisplay")
            UserDefaults.standard.synchronize()
            
            if let x = UserDefaults.standard.object(forKey: "breakfastListDisplay") as? String
            {
                list1[0] = x
            }
        }
        if foodCategorySegments.selectedSegmentIndex == 1 {
            lunchList.append(newFood)
            
            let userDefault = UserDefaults.standard
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: lunchList)
            userDefault.set(encodedData, forKey: "lunchList")
            userDefault.synchronize()
            
            var tempCalories: Int = 0
            var tempCarbs: Int = 0
            var tempSugar: Int = 0
            var tempFat: Int = 0
            
            
            for item in lunchList {
                tempCalories += item.calories
                tempCarbs += item.carbs
                tempSugar += item.sugar
                tempFat += item.fat
            }
            
            updatedListString = "Lunch - \(tempCalories) Cal, \(tempCarbs)g Carbs, \(tempSugar)g Sugar, \(tempFat)g Fat"
            UserDefaults.standard.set(updatedListString, forKey: "lunchListDisplay")
            
            if let x = UserDefaults.standard.object(forKey: "lunchListDisplay") as? String
            {
                list1[1] = x
            }
        }
        if foodCategorySegments.selectedSegmentIndex == 2 {
            dinnerList.append(newFood)
            
            let userDefault = UserDefaults.standard
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: dinnerList)
            userDefault.set(encodedData, forKey: "dinnerList")
            userDefault.synchronize()
            
            var tempCalories: Int = 0
            var tempCarbs: Int = 0
            var tempSugar: Int = 0
            var tempFat: Int = 0
            
            
            for item in dinnerList {
                tempCalories += item.calories
                tempCarbs += item.carbs
                tempSugar += item.sugar
                tempFat += item.fat
            }
            
            updatedListString = "Dinner - \(tempCalories) Cal, \(tempCarbs)g Carbs, \(tempSugar)g Sugar, \(tempFat)g Fat"
            UserDefaults.standard.set(updatedListString, forKey: "dinnerListDisplay")
            
            if let x = UserDefaults.standard.object(forKey: "dinnerListDisplay") as? String
            {
                list1[2] = x
            }
        }
        if foodCategorySegments.selectedSegmentIndex == 3 {
            snacksList.append(newFood)
            
            let userDefault = UserDefaults.standard
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: snacksList)
            userDefault.set(encodedData, forKey: "snacksList")
            userDefault.synchronize()
            
            var tempCalories: Int = 0
            var tempCarbs: Int = 0
            var tempSugar: Int = 0
            var tempFat: Int = 0
            
            
            for item in snacksList {
                tempCalories += item.calories
                tempCarbs += item.carbs
                tempSugar += item.sugar
                tempFat += item.fat
            }
            
            updatedListString = "Snack(s) - \(tempCalories) Cal, \(tempCarbs)g Carbs, \(tempSugar)g Sugar, \(tempFat)g Fat"
            UserDefaults.standard.set(updatedListString, forKey: "snacksListDisplay")
            
            if let x = UserDefaults.standard.object(forKey: "snacksListDisplay") as? String
            {
                list1[3] = x
            }
        }
        //list1.append(newFood.getFoodName() + " " + newFood.getFoodInfo())
        
        if caloriesField.text == ""
        {
            totalCal += 0
        }
        else
        {
            totalCal += Int(caloriesField.text!)!
        }
        if carbsField.text == ""
        {
            totalCarbs += 0
        }
        else
        {
            totalCarbs += Int(carbsField.text!)!
        }
        if sugarField.text == ""
        {
            totalSugar += 0
        }
        else
        {
            totalSugar += Int(sugarField.text!)!
        }
        if fatField.text == ""
        {
            totalFat += 0
        }
        else
        {
            totalFat += Int(fatField.text!)!
        }
        
        
        UserDefaults.standard.set(totalCal, forKey: "nutritionTotalCal")
        UserDefaults.standard.set(totalCarbs, forKey: "nutritionTotalCarbs")
        UserDefaults.standard.set(totalSugar, forKey: "nutritionTotalSugar")
        UserDefaults.standard.set(totalFat, forKey: "nutritionTotalFat")
        
        Analytics.logEvent("nutrition_food_added", parameters: ["nutrition_food" : newFood.name])
        
        /*
        totalCal += Int(caloriesField.text!)!
        totalCarbs += Int(carbsField.text!)!
        totalSugar += Int(sugarField.text!)!
        totalFat += Int(fatField.text!)!
        */
        
        //self.tableview1.reloadData()
        //self.tableview2.reloadData()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count: Int?
        
        if tableView == self.tableview1 {
            count = list1.count
        }
        
        return count!
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        
        if(tableView == self.tableview1) {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
            cell!.textLabel!.font = UIFont(name:"Avenir", size:12)
            cell!.textLabel!.text = list1[indexPath.row]
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        switch row
        {
        case 0:
            performSegue(withIdentifier: "nutritionBreakfastSegue", sender: self)
            break
        case 1:
            performSegue(withIdentifier: "nutritionLunchSegue", sender: self)
            break
        case 2:
            performSegue(withIdentifier: "nutritionDinnerSegue", sender: self)
            break
        case 3:
            performSegue(withIdentifier: "nutritionSnacksSegue", sender: self)
            break
        default:
            break
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //******************* SUGAR, FAT AND CARBS COMPOUNDS WHEN VIEW IS RELOADED FROM DASHBOARD
        //totalSugar += Int(sugarGlobal)
        //totalFat += Int(fatGlobal)
        //totalCarbs += Int(carbsGlobal)
        //totalCal += Int(caloriesGlobal)
        
        //Push carbs to Dashboard
        Analytics.logEvent("nutrition_opened", parameters: nil)
        
        addToCarbs = Double(totalCarbs)
        UserDefaults.standard.set(addToCarbs, forKey: "addToCarbs")
        
        if let x = UserDefaults.standard.object(forKey: "nutritionTotalSugar") as? Int
        {
            totalSugar = (sugarGlobal != 0 ? Int(sugarGlobal) : x)
        }
        if let x = UserDefaults.standard.object(forKey: "nutritionTotalCal") as? Int
        {
            totalCal = (caloriesGlobal != 0 ? Int(caloriesGlobal) : x)
        }
        if let x = UserDefaults.standard.object(forKey: "nutritionTotalFat") as? Int
        {
            totalFat = (fatGlobal != 0 ? Int(fatGlobal) : x)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(tableview1 != nil) {
            self.tableview1.reloadData()
        }
        
        if let x = UserDefaults.standard.object(forKey: "breakfastListDisplay") as? String
        {
            list1[0] = x
        }
        
        if let x = UserDefaults.standard.object(forKey: "lunchListDisplay") as? String
        {
            list1[1] = x
        }
        
        if let x = UserDefaults.standard.object(forKey: "dinnerListDisplay") as? String
        {
            list1[2] = x
        }
        
        if let x = UserDefaults.standard.object(forKey: "snacksListDisplay") as? String
        {
            list1[3] = x
        }
        
        
        if caloriesDisplayProgressRing != nil
        {
            caloriesDisplayProgressRing.animationStyle = kCAMediaTimingFunctionLinear
            caloriesDisplayProgressRing.maxValue = CGFloat(theUser.caloriesGoal)
            caloriesDisplayProgressRing.innerRingColor = UIColor.orange
            if let x = UserDefaults.standard.object(forKey: "nutritionTotalCal") as? Int
            {
                caloriesDisplayProgressRing.setProgress(value: CGFloat(x), animationDuration: 2.0)
                {
                    print("Done animating!")
                }
            }
            
            remainingCalories.text = "Remaining: \(theUser.caloriesGoal - totalCal)g"
        }
        if carbsDisplayProgressRing != nil
        {
            carbsDisplayProgressRing.animationStyle = kCAMediaTimingFunctionLinear
            carbsDisplayProgressRing.maxValue = CGFloat(theUser.carbsGoal)
            carbsDisplayProgressRing.innerRingColor = UIColor.red
            if let x = UserDefaults.standard.object(forKey: "nutritionTotalCarbs") as? Int
            {
                carbsDisplayProgressRing.setProgress(value: CGFloat(x), animationDuration: 2.0)
                {
                    print("Done animating!")
                }
            }
            
            remainingCarbs.text = "Remaining: \(theUser.carbsGoal - totalCarbs)g"
        }
        if sugarDisplayProgressRing != nil
        {
            sugarDisplayProgressRing.animationStyle = kCAMediaTimingFunctionLinear
            sugarDisplayProgressRing.maxValue = CGFloat(theUser.sugarGoal)
            sugarDisplayProgressRing.innerRingColor = UIColor.blue
            if let x = UserDefaults.standard.object(forKey: "nutritionTotalSugar") as? Int
            {
                sugarDisplayProgressRing.setProgress(value: CGFloat(x), animationDuration: 2.0)
                {
                    print("Done animating!")
                }
            }
            
            remainingSugar.text = "Remaining: \(theUser.sugarGoal - totalSugar)g"
        }
        if fatDisplayProgressRing != nil
        {
            fatDisplayProgressRing.animationStyle = kCAMediaTimingFunctionLinear
            fatDisplayProgressRing.maxValue = CGFloat(theUser.fatGoal)
            fatDisplayProgressRing.innerRingColor = UIColor.orange
            if let x = UserDefaults.standard.object(forKey: "nutritionTotalFat") as? Int
            {
                fatDisplayProgressRing.setProgress(value: CGFloat(x), animationDuration: 2.0)
                {
                    print("Done animating!")
                }
            }
            
            remainingFat.text = "Remaining: \(theUser.fatGoal - totalFat)g"
        }
        
        if foodCategorySegments != nil
        {
            foodCategorySegments.selectedSegmentIndex = foodCategorySegmentInit
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "nutritionBreakfastSegue"
        {
            let nextScene = segue.destination as? NutritionDisplayViewController
            nextScene?.titleText = "Breakfast"
            let userDefault = UserDefaults.standard
            if let decodedData = userDefault.object(forKey: "breakfastList") as? Data
            {
                if let x = NSKeyedUnarchiver.unarchiveObject(with: decodedData) as? [Food]
                {
                    nextScene?.nutritionDisplayList = x
                }
            }
        }
        else if segue.identifier == "nutritionLunchSegue"
        {
            let nextScene = segue.destination as? NutritionDisplayViewController
            nextScene?.titleText = "Lunch"
            let userDefault = UserDefaults.standard
            if let decodedData = userDefault.object(forKey: "lunchList") as? Data
            {
                if let x = NSKeyedUnarchiver.unarchiveObject(with: decodedData) as? [Food]
                {
                    nextScene?.nutritionDisplayList = x
                }
            }
        }
        else if segue.identifier == "nutritionDinnerSegue"
        {
            let nextScene = segue.destination as? NutritionDisplayViewController
            nextScene?.titleText = "Dinner"
            let userDefault = UserDefaults.standard
            if let decodedData = userDefault.object(forKey: "dinnerList") as? Data
            {
                if let x = NSKeyedUnarchiver.unarchiveObject(with: decodedData) as? [Food]
                {
                    nextScene?.nutritionDisplayList = x
                }
            }
        }
        else if segue.identifier == "nutritionSnacksSegue"
        {
            let nextScene = segue.destination as? NutritionDisplayViewController
            nextScene?.titleText = "Snack(s)"
            let userDefault = UserDefaults.standard
            if let decodedData = userDefault.object(forKey: "snacksList") as? Data
            {
                if let x = NSKeyedUnarchiver.unarchiveObject(with: decodedData) as? [Food]
                {
                    nextScene?.nutritionDisplayList = x
                }
            }
        }
        
        
        if segue.identifier == "addBreakfastSegue"
        {
            foodCategorySegmentInit = 0
        }
        else if segue.identifier == "addLunchSegue"
        {
            foodCategorySegmentInit = 1
        }
        else if segue.identifier == "addDinnerSegue"
        {
            foodCategorySegmentInit = 2
        }
        else if segue.identifier == "addSnacksSegue"
        {
            foodCategorySegmentInit = 3
        }
    }
}







/*
 //  Backup
 
 //
 //  NutritionViewController.swift
 //  DiabetesApp
 //
 //  Created by Arrington, Darryn on 7/26/17.
 //  Copyright © 2017 Arrington, Darryn. All rights reserved.
 //
 
 import UIKit
 import Foundation
 import HealthKit
 
 var list1 = ["Breakfast", "Lunch", "Dinner", "Snack(s)"]
 var list2 = ["32g Carbs, 5g Sugar, 3g Protein", "23g Carbs, 3g Sugar, 5g Protein", "12g Carbs, 15g Sugar,13g Protein", "41g Carbs, 50g Sugar, 30g Protein"]
 
 //The total amount of each measurement displayed on the nutrition front page
 
 var totalCal: Int = 0
 var totalCarbs: Int = 0
 var totalSugar: Int = 0
 var totalFat: Int = 0
 
 
 class Food {
 var name: String
 var calories: Int
 var carbs: Int
 var sugar: Int
 var fat: Int
 
 init(name: String, calories: Int, carbs: Int, sugar: Int, fat: Int) {
 self.name = name
 self.calories = calories
 self.carbs = carbs
 self.sugar = sugar
 self.fat = fat
 }
 
 public func getFoodName() -> String {
 return self.name
 }
 
 public func getFoodInfo() -> String {
 let foodString = "\(self.calories)g Cal, \(self.carbs)g Carbs, \(self.sugar)g Sugar, \(self.fat)g Fat"
 
 return foodString
 }
 }
 
 class FoodCategory {
 
 }
 
 class NutritionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
 
 @IBOutlet weak var tableview1: UITableView!
 @IBOutlet weak var tableview2: UITableView!
 
 
 @IBOutlet weak var carbsDisplay: UILabel!
 @IBOutlet weak var caloriesDisplay: UILabel!
 @IBOutlet weak var sugarDisplay: UILabel!
 @IBOutlet weak var fatDisplay: UILabel!
 
 
 //@IBAction func addButtonTapped(_ sender: Any) {
 /*let newFood = Food(name: "Bacon", calories: 20, carbs: 5, sugar: 4, fat: 30)
 
 list1.append(newFood.getFoodName())
 list2.append(newFood.getFoodInfo())
 
 self.tableview1.reloadData()
 self.tableview2.reloadData()
 */
 
 //}
 
 @IBOutlet weak var foodNameField: UITextField!
 @IBOutlet weak var carbsField: UITextField!
 @IBOutlet weak var caloriesField: UITextField!
 @IBOutlet weak var sugarField: UITextField!
 @IBOutlet weak var fatField: UITextField!
 
 @IBOutlet weak var breakfastSwitch: UISwitch!
 @IBOutlet weak var lunchSwitch: UISwitch!
 @IBOutlet weak var dinnerSwitch: UISwitch!
 @IBOutlet weak var snacksSwitch: UISwitch!
 
 //Arrays that will store the foods based on what category they are
 var breakfast = [Food]()
 var lunch = [Food]()
 var dinner = [Food]()
 var snacks = [Food]()
 
 
 
 @IBAction func addSubmitButtonTapped(_ sender: Any) {
 let newFood = Food(name: foodNameField.text!, calories: Int(caloriesField.text!)!, carbs: Int(carbsField.text!)!, sugar: Int(sugarField.text!)!, fat: Int(fatField.text!)!)
 
 //Add food to category based on what switch is pressed
 if breakfastSwitch.isOn {
 
 }
 if lunchSwitch.isOn {
 
 }
 if dinnerSwitch.isOn {
 
 }
 if snacksSwitch.isOn {
 
 }
 list1.append(newFood.getFoodName())
 list2.append(newFood.getFoodInfo())
 
 totalCal += Int(caloriesField.text!)!
 totalCarbs += Int(carbsField.text!)!
 totalSugar += Int(sugarField.text!)!
 totalFat += Int(fatField.text!)!
 
 //self.tableview1.reloadData()
 //self.tableview2.reloadData()
 }
 
 public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 
 var count: Int?
 
 if tableView == self.tableview1 {
 count = list1.count
 }
 
 if tableView == self.tableview2 {
 count = list2.count
 }
 return count!
 }
 
 public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
 var cell: UITableViewCell?
 
 if(tableView == self.tableview1) {
 cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
 cell!.textLabel!.text = list1[indexPath.row]
 }
 
 if(tableView == self.tableview2) {
 cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)
 cell!.textLabel!.font = UIFont.systemFont(ofSize: 14)
 cell!.textLabel!.text = list2[indexPath.row]
 }
 
 return cell!
 }
 
 override func viewDidLoad() {
 super.viewDidLoad()
 }
 
 override func viewDidAppear(_ animated: Bool) {
 if(tableview1 != nil) {
 self.tableview1.reloadData()
 }
 if (tableview2 != nil) {
 self.tableview2.reloadData()
 }
 
 if(caloriesDisplay != nil) {
 caloriesDisplay.text = "\(totalCal)"
 }
 
 if(carbsDisplay != nil) {
 carbsDisplay.text = "\(totalCarbs)"
 }
 if(sugarDisplay != nil) {
 sugarDisplay.text = "\(totalSugar)"
 }
 if(fatDisplay != nil) {
 fatDisplay.text = "\(totalFat)"
 }
 }
 
 override func didReceiveMemoryWarning() {
 super.didReceiveMemoryWarning()
 }
 }

 */
