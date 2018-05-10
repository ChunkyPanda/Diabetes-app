//
//  FirstViewController.swift
//  DiabetesApp
//
//  Created by Arrington, Darryn on 7/19/17.
//  Copyright © 2017 Arrington, Darryn. All rights reserved.
//

import UIKit
import Foundation
import HealthKit
import UICircularProgressRing
import FirebaseAnalytics

var sleepText = ""
var carbsGlobal = 0.0
var sugarGlobal = 0.0
var fatGlobal = 0.0
var caloriesGlobal = 1230.0
var caloriesBurnedGlobal = 0.0
var hrGlobal = 98
var totalSteps = 1000.0
var exerciseTime = 45.0
var sleepGlobal = 0.0
var glucoseGlobal = 0.0
var RestaurantType = "Salad"
var feelingStatus = "happy"
var savedDate = NSDate()

var addToCarbs = 0.0
var addToCaloriesBurned = 0.0

class FirstViewController: UIViewController {
    
 
    
    
    
    

    let healthKitStore = HKHealthStore()
   // @IBOutlet weak var stepsDisplay: UILabel!
    //@IBOutlet weak var sleepDisplay: UILabel!
    //@IBOutlet weak var nutritionDisplay: UILabel!
    @IBOutlet weak var dwmSegmentedControl: UISegmentedControl!
    var dwmValue : Int = 0
    
    
    @IBOutlet weak var glucoseDisplayProgressRing: UICircularProgressRingView!
    @IBOutlet weak var stepsDisplayProgressRing: UICircularProgressRingView!
    @IBOutlet weak var nutritionDisplayProgressRing: UICircularProgressRingView!
    @IBOutlet weak var sleepDisplayProgressRing: UICircularProgressRingView!
    
    //NOTE: MAY HAVE TO DELETE THIS
    @IBOutlet weak var sleepDisplay: UIButton!
    
    @IBOutlet weak var feelingStatusDisplay: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        /*
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        */
        
        feelingStatusDisplay.setImage(UIImage(named: feelingStatus), for: .normal)
        
        let userDefault = UserDefaults.standard
        if let decodedData = userDefault.object(forKey: "theUser") as? Data
        {
            if let x = NSKeyedUnarchiver.unarchiveObject(with: decodedData) as? UserProfile
            {
                theUser = x
            }
        }
        
        Analytics.logEvent("dashboard_opened", parameters: ["username" : theUser.name])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func resetdata(current_date: Date)
    
    {
    
        
        if (savedDate == nil)
        
        {savedDate=current_date as NSDate
        return}
        
        
        else if (savedDate as Date == current_date)
        {
            return
        }
    
        else
        {
             breakfastList.removeAll()
             lunchList.removeAll()
             dinnerList.removeAll()
             snacksList.removeAll()
             listActivity.removeAll()
             carbsGlobal = 0.0
             sugarGlobal = 0.0
             fatGlobal = 0.0
             caloriesGlobal = 0.0
         
            
        return}
    
    
    }
    
    
    
    
    
    
    
    
    @IBAction func changeDWM(_ sender: Any) {
        if dwmSegmentedControl.selectedSegmentIndex == 0 {
            dwmValue = 0
            Analytics.logEvent("dashboard_segment_changed", parameters: ["segment" : "Day"])
        }
        if dwmSegmentedControl.selectedSegmentIndex == 1 {
            dwmValue = 1
            Analytics.logEvent("dashboard_segment_changed", parameters: ["segment" : "Week"])
        }
        if dwmSegmentedControl.selectedSegmentIndex == 2 {
            dwmValue = 2
            Analytics.logEvent("dashboard_segment_changed", parameters: ["segment" : "Month"])
        }
        self.viewDidAppear(true)
    }
    
    
    func checkAuthorization() -> Bool {
        var isEnabled = true
        
        if HKHealthStore.isHealthDataAvailable()
        {
            //let healthKitTypesToRead : Set = [HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!]
            let healthKitTypesToRead : Set = [HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodGlucose)!, HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!, HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!, HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCarbohydrates)!, HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryFatTotal)!, HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!, HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryProtein)!, HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietarySugar)!, HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed)!,HKObjectType.quantityType(forIdentifier:HKQuantityTypeIdentifier.appleExerciseTime)!]
            
            let healthKitTypesToWrite: Set = [HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodGlucose)!, HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCarbohydrates)!, HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryFatTotal)!, HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryProtein)!, HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietarySugar)!, HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!, HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed)!]
            
            
           
            
            healthKitStore.requestAuthorization(toShare: nil, read: healthKitTypesToRead, completion: { (success, error) in
                isEnabled = success
            })
        }
        else
        {
            isEnabled = false
        }
        
        return isEnabled
    }
    
    
    
    
    
    @IBOutlet weak var progressRing: UICircularProgressRingView!
   
    
    override func viewDidAppear(_ animated: Bool) {
        
        //setUpLocalNotification(hour: 11, minute: 05)
        
        if(checkAuthorization()) {
            if(HKHealthStore.isHealthDataAvailable()) {
                
                
                // Getting exercise time
                
                
                getExerciseTime(){ time in
                    
                    exerciseTime = time
                }
 
                print("Excercise Time : \(exerciseTime)")
                
                
                //GETTING STEPS
                getSteps() { steps in
                    
                    //self.stepsDisplay. = "\(steps)"
                    totalSteps = steps
                    
                    
                    //self.stepsDisplay.setTitle("\(steps)",for: .normal)
                    if self.stepsDisplayProgressRing != nil
                    {
                        self.stepsDisplayProgressRing.animationStyle = kCAMediaTimingFunctionLinear
                        self.stepsDisplayProgressRing.maxValue = CGFloat(theUser.stepsGoal)
                        self.stepsDisplayProgressRing.innerRingColor = UIColor.red
                        self.stepsDisplayProgressRing.setProgress(value: CGFloat(steps), animationDuration: 2.0)
                        {
                            print("Done animating!")
                        }
                    }
                }
                
                //GETTING GLUCOSE
                if self.glucoseDisplayProgressRing != nil
                {
                    //glucoseGlobal = glucose
                    self.glucoseDisplayProgressRing.animationStyle = kCAMediaTimingFunctionLinear
                    self.glucoseDisplayProgressRing.maxValue = 120
                    self.glucoseDisplayProgressRing.innerRingColor = UIColor.yellow
                    self.glucoseDisplayProgressRing.setProgress(value: CGFloat(glucoseGlobal), animationDuration: 2.0)
                    {
                        print("Done animating!")
                    }
                }
                retrieveRecentGlucose() { glucose in
                    if self.glucoseDisplayProgressRing != nil
                    {
                        //glucoseGlobal = glucose
                        self.glucoseDisplayProgressRing.animationStyle = kCAMediaTimingFunctionLinear
                        self.glucoseDisplayProgressRing.maxValue = 120
                        self.glucoseDisplayProgressRing.innerRingColor = UIColor.yellow
                        self.glucoseDisplayProgressRing.setProgress(value: CGFloat(glucoseGlobal), animationDuration: 2.0)
                        {
                            print("Done animating!")
                        }
                    }
                }
                
                //GETTING SLEEP DATA
                retrieveSleepAnalysis()
                
                //GETTING THE CARBS
                retrieveRecentCarbs() { carbs in
                    if self.nutritionDisplayProgressRing != nil
                    {
                        if let x = UserDefaults.standard.object(forKey: "addToCarbs") as? Double
                        {
                            carbsGlobal = carbs + x
                        }
                        addToCarbs = 0.0
                        self.nutritionDisplayProgressRing.animationStyle = kCAMediaTimingFunctionLinear
                        self.nutritionDisplayProgressRing.maxValue = CGFloat(theUser.carbsGoal)
                        self.nutritionDisplayProgressRing.innerRingColor = UIColor.blue
                        self.nutritionDisplayProgressRing.setProgress(value: CGFloat(carbsGlobal), animationDuration: 2.0)
                        {
                            print("Done animating!")
                        }
                    }
                }
                
                //GETTING CALORIES
                retrieveRecentCalories() { calories in
                    caloriesGlobal = calories
                }
 
                //GETTING CALORIES FOR ACTIVITY
                retrieveRecentCaloriesBurned() { caloriesBurned in
                    caloriesBurnedGlobal = caloriesBurned
                }
                
                //GETTING SUGAR
                retrieveRecentSugar() { sugar in
                    sugarGlobal = sugar
                }
                
                //GETTING FAT
                retrieveRecentFat() { fat in
                    fatGlobal = fat
                }
                
                //GETTING HEART RATE
                retrieveRecentHeartRate() { hr in
                    hrGlobal = Int(hr)
                }
                
            }
        }
        
    }
    
  
    
     /*func setUpLocalNotification(hour: Int, minute: Int) {
        
        // have to use NSCalendar for the components
        let calendar = NSCalendar(identifier: .gregorian)!;
        
        var dateFire = Date()
        
        // if today's date is passed, use tomorrow
        var fireComponents = calendar.components( [NSCalendar.Unit.day, NSCalendar.Unit.month, NSCalendar.Unit.year, NSCalendar.Unit.hour, NSCalendar.Unit.minute], from:dateFire)
        
        if (fireComponents.hour! > hour
            || (fireComponents.hour == hour && fireComponents.minute! >= minute) ) {
            
            dateFire = dateFire.addingTimeInterval(86400)  // Use tomorrow's date
            fireComponents = calendar.components( [NSCalendar.Unit.day, NSCalendar.Unit.month, NSCalendar.Unit.year, NSCalendar.Unit.hour, NSCalendar.Unit.minute], from:dateFire);
        }
        
        // set up the time
        fireComponents.hour = hour
        fireComponents.minute = minute
        
        // schedule local notification
        dateFire = calendar.date(from: fireComponents)!
        
        let localNotification = UILocalNotification()
        localNotification.fireDate = dateFire
        localNotification.alertBody = "Have you checkd your blood sugar today?"
        localNotification.repeatInterval = NSCalendar.Unit.day
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        
        UIApplication.shared.scheduleLocalNotification(localNotification);
        
    }*/
    
    
    
    
    func retrieveRecentGlucose(completion: @escaping (Double) -> Void) {
        
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
                DispatchQueue.main.async() {
                    if let result = results {
                        
                        // do something with my data
                        for item in result {
                            if let sample = item as? HKQuantitySample {
                                completion(sample.quantity.doubleValue(for: HKUnit(from: "mg/dL")))
                                return
                            }
                        }
                    }
                }
            }
            
            // finally, we execute our query
            healthKitStore.execute(gluquery)
        }
    }
    
    func getSteps(completion: @escaping (Double) -> Void) {
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        /*
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        */
        
        var now : Date
        var startOfDay : Date
        var predicate : NSPredicate
        
        switch dwmValue {
        case 0:
            now = Date()
            startOfDay = Calendar.current.startOfDay(for: now)
            predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
            break
        case 1:
            now = Date()
            startOfDay = Calendar.current.startOfDay(for: Date(timeIntervalSinceNow: -60 * 60 * 24 * 7))
            predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
            break
        case 2:
            now = Date()
            let wx = -60 * 60 * 24 * 2
            startOfDay = Calendar.current.startOfDay(for: Date(timeIntervalSinceNow: TimeInterval((-60 * 60 * 24 * 7 * 4) + wx)))
            predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
            break
        default:
            now = Date()
            startOfDay = Calendar.current.startOfDay(for: now)
            predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
            break
        }
        
        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
            var resultCount = 0.0
            
            guard let result = result else {
                //log.error("Failed to fetch steps = \(error?.localizedDescription ?? "N/A")")
                completion(resultCount)
                return
            }
            
            if let sum = result.sumQuantity() {
                resultCount = sum.doubleValue(for: HKUnit.count())
            }
            
            DispatchQueue.main.async {
                completion(resultCount)
            }
        }
        
        healthKitStore.execute(query)
    }
    
    //Get Most Recent  Glucose Reading for the Day
    
    func retrieveRecentCarbs(completion: @escaping (Double) -> Void) {
        // first, we define the object type we want
        if let carbs = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCarbohydrates)
        {
            /*
            let now = Date()
            let startOfDay = Calendar.current.startOfDay(for: now)
            
            // Use a sortDescriptor to get the recent data first
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            let allreadings = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
            */
            
            var cumulative : Double = 0.0
            
            var now : Date
            var startOfDay : Date
            var sortDescriptor : NSSortDescriptor
            var allreadings : NSPredicate
            
            switch dwmValue {
            case 0:
                now = Date()
                startOfDay = Calendar.current.startOfDay(for: now)
                
                // Use a sortDescriptor to get the recent data first
                sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
                allreadings = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
                break
            case 1:
                now = Date()
                startOfDay = Calendar.current.startOfDay(for: Date(timeIntervalSinceNow: -60 * 60 * 24 * 7))
                
                // Use a sortDescriptor to get the recent data first
                sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
                allreadings = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
                break
            case 2:
                now = Date()
                let wx = -60 * 60 * 24 * 2
                startOfDay = Calendar.current.startOfDay(for: Date(timeIntervalSinceNow: TimeInterval((-60 * 60 * 24 * 7 * 4) + wx)))
                
                // Use a sortDescriptor to get the recent data first
                sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
                allreadings = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
                break
            default:
                now = Date()
                startOfDay = Calendar.current.startOfDay(for: now)
                
                // Use a sortDescriptor to get the recent data first
                sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
                allreadings = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
                break
            }
            
            // we create our query with a block completion to execute
            let carbsQuery = HKSampleQuery(sampleType: carbs, predicate: allreadings, limit: 30, sortDescriptors: [sortDescriptor]) { (carbsQuery, results, error) -> Void in
                
                if error != nil {
                    // something happened
                    return
                }
                
                if let result = results {
                    // do something with my data
                    for item in result {
                        if let sample = item as? HKQuantitySample {
                            cumulative += sample.quantity.doubleValue(for: HKUnit.gram())
                        }
                    }
                }
                completion(cumulative)
            }
            
            // finally, we execute our query
            healthKitStore.execute(carbsQuery)
        }
    }
    
    func retrieveRecentSugar(completion: @escaping (Double) -> Void) {
        // first, we define the object type we want
        if let sugar = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietarySugar)
        {
            let now = Date()
            let startOfDay = Calendar.current.startOfDay(for: now)
            
            // Use a sortDescriptor to get the recent data first
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            let allreadings = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
            
            // we create our query with a block completion to execute
            let sugarQuery = HKSampleQuery(sampleType: sugar, predicate: allreadings, limit: 1, sortDescriptors: [sortDescriptor]) { (sugarQuery, results, error) -> Void in
                
                if error != nil {
                    // something happened
                    return
                }
                
                if let result = results {
                    // do something with my data
                    for item in result {
                        if let sample = item as? HKQuantitySample {
                            completion(sample.quantity.doubleValue(for: HKUnit.gram()))
                            return
                        }
                    }
                }
            }
            
            // finally, we execute our query
            healthKitStore.execute(sugarQuery)
        }
    }
    
    func retrieveRecentFat(completion: @escaping (Double) -> Void) {
        // first, we define the object type we want
        if let fat = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryFatTotal)
        {
            let now = Date()
            let startOfDay = Calendar.current.startOfDay(for: now)
            
            // Use a sortDescriptor to get the recent data first
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            let allreadings = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
            
            // we create our query with a block completion to execute
            let fatQuery = HKSampleQuery(sampleType: fat, predicate: allreadings, limit: 1, sortDescriptors: [sortDescriptor]) { (fatQuery, results, error) -> Void in
                
                if error != nil {
                    // something happened
                    return
                }
                
                if let result = results {
                    // do something with my data
                    for item in result {
                        if let sample = item as? HKQuantitySample {
                            completion(sample.quantity.doubleValue(for: HKUnit.gram()))
                            return
                        }
                    }
                }
            }
            
            // finally, we execute our query
            healthKitStore.execute(fatQuery)
        }
    }
    
    func retrieveRecentCalories(completion: @escaping (Double) -> Void) {
        let caloriesQuantityType = HKQuantityType.quantityType(forIdentifier: .dietaryEnergyConsumed)!
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: caloriesQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (query, result, error) in
            var resultCount = 0.0
            
            guard let result = result else {
                //log.error("Failed to fetch steps = \(error?.localizedDescription ?? "N/A")")
                completion(resultCount)
                return
            }
            
            if let sum = result.sumQuantity() {
                resultCount = sum.doubleValue(for: HKUnit.joule())
            }
            
            DispatchQueue.main.async {
                completion(resultCount)
            }
        }
        
        healthKitStore.execute(query)
    }
    
    func retrieveRecentCaloriesBurned(completion: @escaping (Double) -> Void) {
        let caloriesQuantityType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: caloriesQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (query, result, error) in
            var resultCount = 0.0
            
            guard let result = result else {
                //log.error("Failed to fetch steps = \(error?.localizedDescription ?? "N/A")")
                completion(resultCount)
                return
            }
            
            if let sum = result.sumQuantity() {
                resultCount = sum.doubleValue(for: HKUnit.kilocalorie())
            }
            
            DispatchQueue.main.async {
                completion(resultCount)
            }
        }
        
        healthKitStore.execute(query)
    }
    
    func retrieveRecentHeartRate(completion: @escaping (Double) -> Void) {
        // first, we define the object type we want
        if let heartRate = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)
        {
            let now = Date()
            let startOfDay = Calendar.current.startOfDay(for: now)
            
            // Use a sortDescriptor to get the recent data first
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            let allreadings = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
            
            // we create our query with a block completion to execute
            let hrQuery = HKSampleQuery(sampleType: heartRate, predicate: allreadings, limit: 1, sortDescriptors: [sortDescriptor]) { (hrQuery, results, error) -> Void in
                
                if error != nil {
                    // something happened
                    return
                }
                
                if let result = results {
                    // do something with my data
                    for item in result {
                        if let sample = item as? HKQuantitySample {
                            completion(sample.quantity.doubleValue(for: HKUnit(from: "count/min")))
                            return
                        }
                    }
                }
            }
            
            // finally, we execute our query
            healthKitStore.execute(hrQuery)
        }
    }
    
    // Execute Query to Get Most Recent Glucose Levels
    
    func recentCarbs(sampleType: HKSampleType , completion: ((HKSample?, NSError?) -> Void)!)
    {
        // 1. Build the Predicate
        let past = NSDate.distantPast as NSDate
        let now   = NSDate()
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: past as Date, end:now as Date, options: [])
        
        // 2. Build the sort descriptor to return the samples in descending order
        let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: false)
        // 3. we want to limit the number of samples returned by the query to just 1 (the most recent)
        let limit = 1
        
        // 4. Build samples query
        let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: mostRecentPredicate, limit: limit, sortDescriptors: [sortDescriptor])
        { (sampleQuery, results, error ) -> Void in
            
            if error != nil {
                completion(nil,error as NSError?)
                return;
            }
            
            // Get the first sample
            let mostRecentSample = results?.first as? HKQuantitySample
            
            // Execute the completion closure
            if completion != nil {
                completion(mostRecentSample,nil)
            }
        }
        // 5. Execute the Query
        self.healthKitStore.execute(sampleQuery)
    }
    
    
    func stringFromTimeInterval(interval: TimeInterval) -> NSString {
        
        let ti = NSInteger(interval)
        
        //let ms = Int((interval.truncatingRemainder(dividingBy: 1)) * 1000)
        
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        
        return NSString(format: "%0.2dh %0.2dm %0.2ds",hours,minutes,seconds)
    }
    
    
    func getExerciseTime(completion: @escaping (Double) -> Void) {
        let exerciseQuantityType = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime)!
        
        /*
         let now = Date()
         let startOfDay = Calendar.current.startOfDay(for: now)
         let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
         */
        
        var now : Date
        var startOfDay : Date
        var predicate : NSPredicate
        
        switch dwmValue {
        case 0:
            now = Date()
            startOfDay = Calendar.current.startOfDay(for: now)
            predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
            break
        case 1:
            now = Date()
            startOfDay = Calendar.current.startOfDay(for: Date(timeIntervalSinceNow: -60 * 60 * 24 * 7))
            predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
            break
        case 2:
            now = Date()
            let wx = -60 * 60 * 24 * 2
            startOfDay = Calendar.current.startOfDay(for: Date(timeIntervalSinceNow: TimeInterval((-60 * 60 * 24 * 7 * 4) + wx)))
            predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
            break
        default:
            now = Date()
            startOfDay = Calendar.current.startOfDay(for: now)
            predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
            break
        }
        
        let query = HKStatisticsQuery(quantityType: exerciseQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum ) { (_, result, error) in
            var resultCount = 0.0
            
            
            
            guard let result = result else {
                //log.error("Failed to fetch steps = \(error?.localizedDescription ?? "N/A")")
                completion(resultCount)
                
                return
            }
            
            if let sum = result.sumQuantity() {
                resultCount = sum.doubleValue(for: HKUnit.count())
                
                
            }
            
            DispatchQueue.main.async {
                completion(resultCount)
                print("Exercise time : \(resultCount)")
                
            }
        }
        
        healthKitStore.execute(query)
        
        
    }
    
    
    
    
    
    
    
    
    
    func floatFromTimeInterval(interval: TimeInterval) -> Float
    {  let tf = Float(interval)
        
        let hours = tf/3600
        
        return hours
    }
    
    func retrieveSleepAnalysis() {
        guard let sleepType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis) else {
            return
        }
        
        // define date to search
        var startDate : Date
        var endDate : Date
        
        // we create a predicate to filter our data
        var predicate : NSPredicate
        
        // I had a sortDescriptor to get the recent data first
        var sortDescriptor : NSSortDescriptor
        
        switch dwmValue {
        case 0:
            startDate = Calendar.current.startOfDay(for: Date())
            endDate = Date()
            predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
            sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            break
        case 1:
            startDate = Date(timeIntervalSinceNow: -60 * 60 * 24 * 7)
            endDate = Date()
            predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
            sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            break
        case 2:
            let wx = -60 * 60 * 24 * 2
            startDate = Date(timeIntervalSinceNow: (TimeInterval((-60 * 60 * 24 * 7 * 4) + wx)))
            endDate = Date()
            predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
            sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            break
        default:
            startDate = Date(timeIntervalSinceNow: -60 * 60 * 24 * 7)
            endDate = Date()
            predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
            sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            break
        }
        
        // we create our query with a block completion to execute
        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: 30, sortDescriptors: [sortDescriptor]) { (query, tmpResult, error) -> Void in
            
            if error != nil {
                // something happened
                return
                
            }
            
            if let result = tmpResult {
                
                if result.count == 0 {
                    print("No data to read")
                }
                
                // do something with my data
                for item in result {
                    if let sample = item as? HKCategorySample {
                        
                        //Tells whether queried data is inBed or asleep
                        //let value = (sample.value == HKCategoryValueSleepAnalysis.inBed.rawValue) ? "InBed" : "Asleep"
                        
                        //print("Healthkit sleep: ", sample.startDate, " ", sample.endDate, " source: ", sample.sourceRevision.source.name, "- value: ", value)
                        //self.sleepDisplay.text = "Healthkit sleep: \(sample.startDate), \(sample.endDate), source: \(sample.sourceRevision.source.name) - value: \(value)"
                        
                        //self.sleepDisplay.text = "\(self.stringFromTimeInterval(interval: sample.endDate.timeIntervalSince(sample.startDate)))"
                        
                        //let sleepSample = self.stringFromTimeInterval(interval: sample.endDate.timeIntervalSince(sample.startDate))
                        
                        sleepGlobal = Double(self.floatFromTimeInterval(interval: sample.endDate.timeIntervalSince(sample.startDate)))
                        
                        self.sleepDisplay.setTitle("\(self.stringFromTimeInterval(interval: sample.endDate.timeIntervalSince(sample.startDate)))",for: .normal)
                        
                         if self.sleepDisplayProgressRing != nil
                         {
                         self.sleepDisplayProgressRing.animationStyle = kCAMediaTimingFunctionLinear
                         self.sleepDisplayProgressRing.maxValue = CGFloat(theUser.sleepGoal)
                         self.sleepDisplayProgressRing.innerRingColor = UIColor.red
                         self.sleepDisplayProgressRing.setProgress(value: CGFloat(sleepGlobal), animationDuration: 2.0)
                         {
                         print("Done animating!")
                         }
                         }
                        
                        //actualsleep = self.floatFromTimeInterval(interval: sample.endDate.timeIntervalSince(sample.startDate))
                        
                        sleepstring = self.stringFromTimeInterval(interval: sample.endDate.timeIntervalSince(sample.startDate))
                        
                        
                        
                        //sleepText = "\(self.stringFromTimeInterval(interval: sample.endDate.timeIntervalSince(sample.startDate))), \(value)"
                    }
                }
            }
        }
        
        // finally, we execute our query
        healthKitStore.execute(query)
        
    }
    
}


