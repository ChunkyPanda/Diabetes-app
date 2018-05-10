//
//  EnterGlucoseViewController.swift
//  Diabetes
//
//  Created by Shirsat, Amit on 8/17/17.
//  Copyright © 2017 Malhotra, Neil. All rights reserved.
//

import UIKit
import HealthKit
import Parse
import FirebaseAnalytics


class EnterGlucoseViewController: UIViewController {
    
    
    @IBOutlet weak var timePicked: UIDatePicker!
    @IBOutlet weak var datePicked: UIDatePicker!
    @IBOutlet weak var readingTimePeriod: UISegmentedControl!
    
    @IBOutlet weak var pillMg: UISegmentedControl!
    
    @IBOutlet weak var bloodGlucoseReading: UITextField!
    @IBOutlet weak var medicationName: UITextField!
    @IBOutlet weak var medicationQuantity: UITextField!

    
    
    
    @IBAction func unitsChanged(_ sender: Any) {
    /*
        switch pillMg.selectedSegmentIndex
        {
        case 0:
            medicationUnits = "Pill";
        case 1:
            medicationUnits = "mg";
        default:
            break
        }
*/
    }
    
    @IBOutlet weak var reading: UISegmentedControl!
    @IBAction func readingTimeChanged(_ sender: Any) {
        /*
        switch reading.selectedSegmentIndex
        {
        case 0:
            readingTimes = "Breakfast";
        case 1:
            readingTimes = "Lunch";
        case 2:
            readingTimes = "Dinner";
        case 3:
            readingTimes = "Snacks";
        default:
            break
        }

        */
        
    }
    
    @IBAction func saveGlucoseSampleToHealthKit(_ sender: UIButton) {
        /*
        guard let glucoseValueText = bloodGlucoseReading.text else {
            return
        }
        
        guard let glucoseDoubleValue = Double(glucoseValueText) else {
            return
        }

         let timeP = timePicked.date
         let dateP = datePicked.date
         let combinedDateValue = combineDateAndTime(date: dateP, time: timeP)
        
        saveGlucoseSample(glucosevalue: glucoseDoubleValue, date: combinedDateValue)
       
        //Saving Medication and Quantity - Coming SOON
        
        
        if let text = medicationQuantity.text, !text.isEmpty
        {
            //do something if it's not empty
            let medication = PFObject(className:"Medications")
            let user = PFUser.current()
            medication["UnitsofMeasurement"] = "\(medicationUnits)"
            medication["ReadingTime"] = "\(readingTimes)"
            medication["MedicationName"] = "\(medicationName.text!)"
            guard let medicationQuantityText = medicationQuantity.text else {
                return
            }
            
            guard let medicationDoubleValue = Double(medicationQuantityText) else {
                return
            }
            
            medication["Quantity"] = medicationDoubleValue
            medication["Date"] = combinedDateValue
            medication["user"] = user
            medication.saveInBackground {
                (success: Bool, error: Error?) -> Void in
                if (success) {
                    // The object has been saved.
                } else {
                    // There was a problem, check error.description
                }
            }
            
        }
        else
        {
            print("Cannot Save Empty Medication Entry")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    var medicationUnits:String = "Pill"
    var readingTimes:String = "Breakfast"

    
    
    let healthKitStore = HKHealthStore()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
 */
        
        //DARRYN'S UPDATES ARE HERE*************************************************
        //**************************************************************************************************
        //**************************************************************************************************
        let medInput : String
        let quantityInput : Int
        let bloodInput : Int
        
        //If user leaves any field blank
        if medicationName.text! == "" {
            medInput = "Not disclosed"
        }
        else {
            medInput = medicationName.text!
        }
        
        if medicationQuantity.text! == "" {
            quantityInput = 0
        }
        else {
            quantityInput = Int(medicationQuantity.text!)!
        }
        
        if bloodGlucoseReading.text! == "" {
            bloodInput = 0
        }
        else {
            bloodInput = Int(bloodGlucoseReading.text!)!
        }
        
        let sample : GlucoseReading = GlucoseReading(med: medInput, amount: quantityInput, bloodGlu: bloodInput)
        glucoseReadingsArray.append(sample)
        readingsNum += 1
        glucoseGlobal = Double(sample.bloodGlucose)
        
        if !glucoseReadingsArray.isEmpty {
            var gluCounter = [Int]()
            var avgCalculator : Int = 0
            
            
            for sample in glucoseReadingsArray
            {
                gluCounter.append(sample.bloodGlucose)
                avgCalculator += sample.bloodGlucose
            }
            
            lowGlucose = gluCounter.min() ?? 0
            avgGlucose = Int(avgCalculator/glucoseReadingsArray.count)
            highGlucose = gluCounter.max() ?? 0
        }
        
        Analytics.logEvent("glucose_reading_added", parameters: ["glucose_reading" : sample.bloodGlucose])
        
        UserDefaults.standard.set(readingsNum, forKey: "glucoseReadingNumber")
        UserDefaults.standard.set(lowGlucose, forKey: "glucoseLowReading")
        UserDefaults.standard.set(avgGlucose, forKey: "glucoseAvgReading")
        UserDefaults.standard.set(highGlucose, forKey: "glucoseHighReading")
        UserDefaults.standard.set(glucoseGlobal, forKey: "glucoseGlobal")
        //UserDefaults.standard.set(unitsGlucose, forKey: "glucoseUnits")
        //UserDefaults.standard.set(doseGlucose, forKey: "glucoseDose")
    }
    
    
    
    ///Combine Time and Date Picked on UI
    func combineDateAndTime(date: Date, time: Date) -> Date {
        
        let calendar = NSCalendar.current
        
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
        
        var components = DateComponents()
        components.year = dateComponents.year
        components.month = dateComponents.month
        components.day = dateComponents.day
        components.hour = timeComponents.hour
        components.minute = timeComponents.minute
        components.second = timeComponents.second
        
        return calendar.date(from: components)!
    }

    
    
    
    
    /// WRITING INTO HEALTHKIT  = Saving Samples
/*
    func saveGlucoseSample(glucosevalue:Double, date:Date ) {

        // 1. Create a Glucose Sample
        let bloodGlucoseType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodGlucose)
        let glucoseQuantity = HKQuantity(unit: HKUnit(from: "mg/dL"), doubleValue: glucosevalue)
        let glucoseSample = HKQuantitySample(type: bloodGlucoseType!, quantity: glucoseQuantity, start: date , end: date)
        
        
        // 2. Save the sample in the store
        healthKitStore.save(glucoseSample, withCompletion: { (success, error) ->
            Void in
            if( error != nil ) {
                print("Error saving Glucose sample")
            } else {
                print("Glucose sample saved successfully!")
            }
        })
    }
 */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
