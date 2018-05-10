//
//  EditProfileViewController.swift
//  Diabetes
//
//  Created by Arrington, Darryn on 12/14/17.
//  Copyright © 2017 Malhotra, Neil. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAnalytics

class EditProfileViewController: UIViewController
{
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var feetField: UITextField!
    
    @IBOutlet weak var inchesField: UITextField!
    
    @IBOutlet weak var weightField: UITextField!
    
    @IBOutlet weak var timeField: UITextField!
    
    @IBOutlet weak var stepsField: UITextField!
    
    @IBOutlet weak var caloriesField: UITextField!
    
    @IBOutlet weak var carbsField: UITextField!
    
    @IBOutlet weak var sugarField: UITextField!
    
    @IBOutlet weak var fatField: UITextField!
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        if nameField.text != ""
        {
            theUser.name = nameField.text!
            Analytics.setUserProperty(theUser.name, forName: "Name")
        }
        if emailField.text != ""
        {
            theUser.email = emailField.text!
            Analytics.setUserProperty(theUser.email, forName: "Email")
        }
        if feetField.text != ""
        {
            theUser.heightFeet = Int(feetField.text!)!
        }
        if inchesField.text != ""
        {
            theUser.heightInches = Int(inchesField.text!)!
        }
        if weightField.text != ""
        {
            theUser.weight = Int(weightField.text!)!
        }
        
        if timeField.text != ""
        {
            theUser.timeGoal = Double(timeField.text!)!
        }
        if stepsField.text != ""
        {
            theUser.stepsGoal = Int(stepsField.text!)!
        }
        
        if caloriesField.text != ""
        {
            theUser.caloriesGoal = Int(caloriesField.text!)!
        }
        if carbsField.text != ""
        {
            theUser.carbsGoal = Int(carbsField.text!)!
        }
        if sugarField.text != ""
        {
            theUser.sugarGoal = Int(sugarField.text!)!
        }
        if fatField.text != ""
        {
            theUser.fatGoal = Int(fatField.text!)!
        }
        
        //Move to userdefaults
        let userDefault = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: theUser)
        userDefault.set(encodedData, forKey: "theUser")
        userDefault.synchronize()
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Analytics.logEvent("profile_edit_opened", parameters: nil)
        
        let userDefault = UserDefaults.standard
        if let decodedData = userDefault.object(forKey: "theUser") as? Data
        {
            if let x = NSKeyedUnarchiver.unarchiveObject(with: decodedData) as? UserProfile
            {
                nameField.placeholder = "\(x.name)"
                emailField.placeholder = "\(x.email)"
                feetField.placeholder = "\(x.heightFeet)"
                inchesField.placeholder = "\(x.heightInches)"
                weightField.placeholder = "\(x.weight)"
                
                timeField.placeholder = "\(x.timeGoal)"
                stepsField.placeholder = "\(x.stepsGoal)"
                
                caloriesField.placeholder = "\(x.caloriesGoal)"
                carbsField.placeholder = "\(x.carbsGoal)"
                sugarField.placeholder = "\(x.sugarGoal)"
                fatField.placeholder = "\(x.fatGoal)"
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
