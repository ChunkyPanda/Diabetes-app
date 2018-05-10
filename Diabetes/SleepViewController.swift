//
//  SleepViewController.swift
//  Diabetes
//
//  Created by Malhotra, Neil on 7/25/17.
//  Copyright © 2017 Malhotra, Neil. All rights reserved.
//

import UIKit
import HealthKit


let healthKitStore = HKHealthStore()

let goaltime = TimeInterval()

class SleepViewController: UIViewController {

    


    override func viewDidLoad() {
        super.viewDidLoad()
        
      

        // Do any additional setup after loading the view.
    }

   
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    
    func retrieveSleepAnalysis() {
        guard let sleepType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis) else {
            return
        }
        
        // define date to search
        let startDate = Date(timeIntervalSinceNow: -60 * 60 * 24 * 7)
        let endDate = Date()
        
        
        
        
        // we create a predicate to filter our data
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
        
        // I had a sortDescriptor to get the recent data first
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        
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
                        let value = (sample.value == HKCategoryValueSleepAnalysis.inBed.rawValue) ? "InBed" : "Asleep"
                        
                        print("Healthkit sleep: ", sample.startDate, " ", sample.endDate, " source: ", sample.sourceRevision.source.name, "- value: ", value)
                        //self.sleepDisplay.text = "Healthkit sleep: \(sample.startDate), \(sample.endDate), source: \(sample.sourceRevision.source.name) - value: \(value)"
                        
                        //self.sleepDisplay.text = "\(self.stringFromTimeInterval(interval: sample.endDate.timeIntervalSince(sample.startDate)))"
                        
                       // self.sleepDisplay.setTitle("\(self.stringFromTimeInterval(interval: sample.endDate.timeIntervalSince(sample.startDate)))",for: .normal)
                        
                        
                        //sleepText = "\(self.stringFromTimeInterval(interval: sample.endDate.timeIntervalSince(sample.startDate))), \(value)"
                    }
                }
            }
        }
        
        // finally, we execute our query
        healthKitStore.execute(query)
        
    }
    
}



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


