//
//  OnboardingViewController.swift
//  Diabetes
//
//  Created by Arrington, Darryn on 8/8/17.
//  Copyright © 2017 Malhotra, Neil. All rights reserved.
//

import Foundation
import UIKit

class UserProfile : NSObject, NSCoding {
    
    var name : String
    var email : String
    var weight : Int
    var heightFeet : Int
    var heightInches : Int
    
    var stepsGoal : Int
    var timeGoal : Double
    
    var caloriesGoal : Int
    var carbsGoal : Int
    var sugarGoal : Int
    var fatGoal : Int
    var sleepGoal : Double
    
    convenience required init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: "userName") as! String
        let email = aDecoder.decodeObject(forKey: "userEmail") as! String
        let weight = aDecoder.decodeInteger(forKey: "userWeight")
        let heightFeet = aDecoder.decodeInteger(forKey: "userHeightFeet")
        let heightInches = aDecoder.decodeInteger(forKey: "userHeightInches")
        
        let stepsGoal = aDecoder.decodeInteger(forKey: "userStepsGoal")
        let timeGoal = aDecoder.decodeDouble(forKey: "userTimeGoal")
        
        let caloriesGoal = aDecoder.decodeInteger(forKey: "userCaloriesGoal")
        let carbsGoal = aDecoder.decodeInteger(forKey: "userCarbsGoal")
        let sugarGoal = aDecoder.decodeInteger(forKey: "userSugarGoal")
        let fatGoal = aDecoder.decodeInteger(forKey: "userFatGoal")
        let sleepGoal = aDecoder.decodeDouble(forKey: "userSleepGoal")
        
        
        self.init(name: name, email: email, weight: weight, heightFeet: heightFeet, heightInches: heightInches, stepsGoal: stepsGoal, timeGoal: timeGoal, caloriesGoal: caloriesGoal, carbsGoal: carbsGoal, sugarGoal: sugarGoal, fatGoal: fatGoal, sleepGoal: sleepGoal)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "userName")
        aCoder.encode(email, forKey: "userEmail")
        aCoder.encode(weight, forKey: "userWeight")
        aCoder.encode(heightFeet, forKey: "userHeightFeet")
        aCoder.encode(heightInches, forKey: "userHeightInches")
        
        aCoder.encode(stepsGoal, forKey: "userStepsGoal")
        aCoder.encode(timeGoal, forKey: "userTimeGoal")
        
        aCoder.encode(caloriesGoal, forKey: "userCaloriesGoal")
        aCoder.encode(carbsGoal, forKey: "userCarbsGoal")
        aCoder.encode(sugarGoal, forKey: "userSugarGoal")
        aCoder.encode(fatGoal, forKey: "userFatGoal")
        aCoder.encode(sleepGoal, forKey: "userSleepGoal")
    }
    
    init(name: String, email: String, weight: Int, heightFeet: Int, heightInches: Int, stepsGoal: Int, timeGoal: Double, caloriesGoal: Int, carbsGoal: Int, sugarGoal: Int, fatGoal: Int, sleepGoal: Double) {
        
        self.name = name
        self.email = email
        self.weight = weight
        self.heightFeet = heightFeet
        self.heightInches = heightInches
        
        self.stepsGoal = stepsGoal
        self.timeGoal = timeGoal
        
        self.caloriesGoal = caloriesGoal
        self.carbsGoal = carbsGoal
        self.sugarGoal = sugarGoal
        self.fatGoal = fatGoal
        self.sleepGoal = sleepGoal
    }
    
    /* init() {
        self.name = "Your Name"
        self.email = "yourname@something.com"
        self.weight = 150
        self.heightFeet = 5
        self.heightInches = 8
        
        self.stepsGoal = 2000
        self.timeGoal = 60.0
        
        self.caloriesGoal = 1000
        self.carbsGoal = 100
        self.sugarGoal = 100
        self.fatGoal = 100
        self.sleepGoal = 8.0
    }
    */
}

var theUser = UserProfile(name: "Your Name", email: "yourname@something.com", weight: 150, heightFeet: 5, heightInches: 8, stepsGoal: 2000, timeGoal: 60.0, caloriesGoal: 1000, carbsGoal: 100, sugarGoal: 100, fatGoal: 100, sleepGoal: 8.0)

class OnboardingViewController : UIViewController {
    
    
    @IBOutlet weak var regNameField: UITextField!
    @IBOutlet weak var regEmailField: UITextField!
    @IBOutlet weak var regUsernameField: UITextField!
    @IBOutlet weak var regPasswordField: UITextField!
    
    @IBOutlet weak var regHeightFtField: UITextField!
    @IBOutlet weak var regHeightInField: UITextField!
    @IBOutlet weak var regWeightField: UITextField!
    
    @IBOutlet weak var regStepsField: UITextField!
    @IBOutlet weak var regTimeField: UITextField!
    
    @IBOutlet weak var regCalField: UITextField!
    @IBOutlet weak var regCarbsField: UITextField!
    @IBOutlet weak var regSugarField: UITextField!
    @IBOutlet weak var regFatField: UITextField!
    
    
    

    
    @IBAction func submitRegister(_ sender: Any) {
        theUser.name = regNameField.text!
        theUser.email = regEmailField.text!
    }
    
    @IBAction func submitStats(_ sender: Any) {
        theUser.heightFeet = Int(regHeightFtField.text!)!
        theUser.heightInches = Int(regHeightInField.text!)!
        theUser.weight = Int(regWeightField.text!)!
    }
    
    @IBAction func submitActivityReg(_ sender: Any) {
        theUser.stepsGoal = Int(regStepsField.text!)!
        theUser.timeGoal = Double(regTimeField.text!)!
    }
    
    @IBAction func finishRegistration(_ sender: Any) {
        theUser.caloriesGoal = Int(regCalField.text!)!
        theUser.carbsGoal = Int(regCarbsField.text!)!
        theUser.sugarGoal = Int(regSugarField.text!)!
        theUser.fatGoal = Int(regFatField.text!)!
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
