//
//  GlucoseViewController.swift
//  Diabetes
//
//  Created by Malhotra, Neil on 7/21/17.
//  Copyright © 2017 Malhotra, Neil. All rights reserved.
//

import UIKit
import HealthKit
import Parse
import UICircularProgressRing
import FirebaseAnalytics

class GlucoseReading {
    var medication : String
    var quantity : Int
    var bloodGlucose : Int
    
    init() {
        medication = "Not disclosed"
        quantity = 0
        bloodGlucose = 0
    }
    
    init(med : String, amount : Int, bloodGlu : Int) {
        medication = med
        quantity = amount
        bloodGlucose = bloodGlu
    }
}

var glucoseReadingsArray = [GlucoseReading]()
var readingsNum : Int = 0

var avgGlucose = Int(glucoseGlobal)
var lowGlucose = Int(glucoseGlobal)
var highGlucose = Int(glucoseGlobal)

//var unitsGlucose = "--"
//var doseGlucose = "--"


class GlucoseViewController: UIViewController {
//UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate
    
    
    let healthKitStore = HKHealthStore()
    var firstLoad = true
    @IBOutlet weak var glucoseRecentToday: UIButton!
    @IBOutlet weak var numofReadingsToday: UILabel!
    @IBOutlet weak var lowestGlucoseReading: UILabel!
    @IBOutlet weak var avgGlucoseReading: UILabel!
    @IBOutlet weak var highestGlucoseReading: UILabel!
    @IBOutlet weak var GlucosePageProgressRing: UICircularProgressRingView!
    
    @IBOutlet weak var medLookUp: UITextField!
    
    @IBOutlet weak var numOfUnits: UILabel!
    @IBOutlet weak var numOfDoses: UILabel!
    
    @IBOutlet weak var medicationLog: UITextView!
    
    @IBOutlet weak var dosesLabel: UILabel!
    @IBOutlet weak var unitsLabel: UILabel!
    
    
    
    @IBAction func textFieldEditingDidChange(_ sender: Any) {
    
        retrieveDoseCounts()
        retrieveUnitSum()

    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        /*
        if firstLoad {
            glucoseReadingsArray.append(GlucoseReading(med: "n/a", amount: 1, bloodGlu: 104))
            firstLoad = false
        }
        */
        
        //addToGlucose = Double(glucoseGlobal)
        Analytics.logEvent("glucose_opened", parameters: nil)
    }
    
    

    // Do any additional setup after loading the view.
      
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        /*
        if let text = self.medLookUp.text, !text.isEmpty
           {
         retrieveDoseCounts()
         retrieveUnitSum()
            }
 */
        
        if avgGlucoseReading != nil {
            if let x = UserDefaults.standard.object(forKey: "glucoseAvgReading") as? Int
            {
                let l = UserDefaults.standard.object(forKey: "glucoseLowReading") as? Int
                let h = UserDefaults.standard.object(forKey: "glucoseHighReading") as? Int
                lowestGlucoseReading.text = "\(l ?? 0) mg/dL"
                avgGlucoseReading.text = "\(x) mg/dL"
                highestGlucoseReading.text = "\(h ?? 0) mg/dL"
            }
        }
        
        
        DispatchQueue.main.async()
            {
                /*
                 let query = PFQuery(className:"Medications")
                 query.order(byDescending: "createdAt")
                 if PFUser.current() != nil {
                 query.whereKey("user", equalTo: PFUser.current()!)
                 query.getFirstObjectInBackground { (object: PFObject?, error: Error?) -> Void in
                 if error != nil || object == nil {
                 
                 print("The getFirstObject request failed.")
                 self.medLookUp.text = "";
                 
                 }
                 else { // The find succeeded.
                 print("Successfully retrieved the object.")
                 
                 self.medLookUp.text = object?["MedicationName"] as? String
                 
                 
                 } }
                 }
                 // code
                 */
                //self.glucoseRecentToday.setTitle("\(Int(glucoseGlobal)) mg/dL", for: .normal)
                if self.numofReadingsToday != nil
                {
                    if let x = UserDefaults.standard.object(forKey: "glucoseReadingNumber") as? Int
                    {
                        self.numofReadingsToday.text = "\(x) Readings"
                    }
                }
                
                if self.medicationLog != nil {
                    for x in glucoseReadingsArray {
                        self.medicationLog.text.append("Medication name: \(x.medication) \nqty: \(x.quantity) unit(s) \nBlood Glucose Reading: \(x.bloodGlucose) mg/dL\n\n")
                    }
                }
                
                
                if self.GlucosePageProgressRing != nil
                {
                    self.GlucosePageProgressRing.animationStyle = kCAMediaTimingFunctionLinear
                    self.GlucosePageProgressRing.maxValue = 120
                    self.GlucosePageProgressRing.innerRingColor = UIColor.yellow
                    if let x = UserDefaults.standard.object(forKey: "glucoseGlobal") as? Double
                    {
                        self.GlucosePageProgressRing.setProgress(value: CGFloat(x), animationDuration: 2.0)
                        {
                            print("Done animating!")
                        }
                    }
                }
                
                
        }
        
    }
    
    // Get Count/Doses of Medication Name given:
    
    func retrieveDoseCounts()
    {
        
        if let text = self.medLookUp.text, !text.isEmpty
         {
         //do something if it's not empty
            let query = PFQuery(className:"Medications")
            let now = Date()
            let startOfDay = Calendar.current.startOfDay(for: now)
            query.whereKey("user", equalTo: PFUser.current()!)
            query.whereKey("MedicationName", equalTo: text)
            query.whereKey("createdAt", greaterThanOrEqualTo: startOfDay)
            query.countObjectsInBackground
                { (count, error) in
                if error == nil
                    {
                    
                    
                    self.numOfDoses.text = "\(count)"

                    }
                }
        
         }
    }
    ///End Count of Medication
    
    
    // Get Sum of Units for Medication Name given:
    func retrieveUnitSum()
    {
        
        if let text = self.medLookUp.text, !text.isEmpty
        {
            
        
        
            let sumquery = PFQuery(className: "Medications")
            let now = Date()
            let startOfDay = Calendar.current.startOfDay(for: now)
            sumquery.whereKey("MedicationName", equalTo: text)
            sumquery.whereKey("createdAt", greaterThanOrEqualTo: startOfDay)
            sumquery.whereKey("user", equalTo: PFUser.current()!)
            sumquery.findObjectsInBackground{
                
                (objects, error) -> Void in
                if error == nil {
                    
                    var sum = 0
                    
                    for me in objects! {
                        sum += me.object(forKey: "Quantity") as! Int
                        let finalsum = sum
                        self.numOfUnits.text = "\(finalsum)"
                    }
                    
                }else {
                    
                    print("Could not Retrieve Unit Sum")
                }
            }
            
        }

        
        
    }

    ///End Sum of Units for Medication Name given:
    
    
    


    
    
    
    //Get Most Recent  Glucose Reading for the Day
    func retrieveRecentGlucose() {
        
        // first, we define the object type we want
        if let glucose = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodGlucose)
        {
            
            
            let now = Date()
            let startOfDay = Calendar.current.startOfDay(for: now)
            
            // Use a sortDescriptor to get the recent data first
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            let allreadings = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
            
            // we create our query with a block completion to execute
            let gluquery = HKSampleQuery(sampleType: glucose, predicate: allreadings, limit: 1, sortDescriptors: [sortDescriptor]) { (gluquery, results, error) -> Void in
                
                if error != nil {
                    
                    // something happened
                    return
                    
                }
                
                if let result = results {
                    
                    // do something with my data
                    for item in result {
                        if let sample = item as? HKQuantitySample {
                            //self.glucoseRecentToday.setTitle("\(sample.quantity)", for: .normal)
                        }
                    }
                }
            }
            
            // finally, we execute our query
            healthKitStore.execute(gluquery)
        }
    }
    // Execute Query to Get Most Recent Glucose Levels
    
    
    
    //Get Count of Glucose Readings
    func retrieveNumberofReadings() {
        
        // first, we define the object type we want
        if let glucose = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodGlucose)
        {
            
            
            let now = Date()
            let startOfDay = Calendar.current.startOfDay(for: now)
        
            
            // Use a sortDescriptor to get the recent data first
            let allreadings = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
            // let HKObjectQueryNoLimit: Int?
            // we create our query with a block completion to execute
            
            
            let countquery = HKSampleQuery(sampleType: glucose, predicate: allreadings, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (countquery, results, error) -> Void in
                
                if error != nil {
                    
                    // something happened
                    return
                    
                }
                
                if let result = results {
                    
                    // do something with my data
                    for item in result {
                        if let sample = item as? HKQuantitySample {

                            self.numofReadingsToday.text = "\(sample.accessibilityElementCount()) Readings"
                        }
                    }
                }
            }
            
            // finally, we execute our query
            healthKitStore.execute(countquery)
        }
    }
    // Execute Query to Get Glucose Reading Counts
    
    
    
    //Get Highest  Glucose Reading for the Day
    func retrieveMinMaxGlucoseReadings() {
        
        // first, we define the object type we want
        if let glucose = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodGlucose)
        {
            
            
            let now = Date()
            let startOfDay = Calendar.current.startOfDay(for: now)
            
            // Use a sortDescriptor to get the recent data first
            let allreadings = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
            
            let statsOptions: HKStatisticsOptions = [HKStatisticsOptions.discreteMin, HKStatisticsOptions.discreteMax,HKStatisticsOptions.discreteAverage]
            

            

            // we create our query with a block completion to execute
            let query = HKStatisticsQuery(quantityType: glucose, quantitySamplePredicate: allreadings, options: statsOptions, completionHandler: { (query, result, error) in
                    if let e = error {
                        print("Error: \(e.localizedDescription)")
                        return
                    }
                    DispatchQueue.main.async {
                        guard let r = result else {
                            return
                        }
                        let min = r.minimumQuantity()
                        let max = r.maximumQuantity()
                        let avg = r.averageQuantity()
                        if min != nil && max != nil && avg != nil {
                            self.highestGlucoseReading.text = "\(max!)"
                            self.lowestGlucoseReading.text = "\(min!)"
                            self.avgGlucoseReading.text = "\(avg!)"
                        }
                    }
                })
            
            // finally, we execute our query
            healthKitStore.execute(query)
        }
    }
    // Execute Query to Get Highest Glucose Level for the day
    
}

    
    




