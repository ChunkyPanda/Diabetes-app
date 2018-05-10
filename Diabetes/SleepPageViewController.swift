//
//  SleepPageViewController.swift
//  Diabetes
//
//  Created by Malhotra, Neil on 7/26/17.
//  Copyright © 2017 Malhotra, Neil. All rights reserved.
//

import UIKit
import Foundation
import UICircularProgressRing
import Charts
import FirebaseAnalytics
import HealthKit
class SleepPageViewController: UIViewController {
    let healthKitStore = HKHealthStore()
    var sleeps = [HKCategorySample]()
    var days: [String]!
    var hoursSlept : [Double]!
    var sleepArray = [Double] ()
    
    
    @IBOutlet weak var SleepGoalLabel: UILabel!
    
    @IBOutlet weak var SleepRefLabel: UILabel!
    
    @IBOutlet weak var SleepLabel: UILabel!
    
    
    @IBOutlet weak var WeeklyBarChart: BarChartView!
    
    override func viewDidLoad() {
        
        
        
        super.viewDidLoad()
        
        retrieveWeekSleep()
        
        
        
        
        
        days = ["", "", "" ,"" ,"" ,"" ,""]
        
        
        
        
        
        
        // Do any additional setup after loading the view.
        if(sleepText != "") {
            SleepRefLabel.text = sleepText
        }
        
        Analytics.logEvent("sleep_opened", parameters: nil)
    }
    
    @IBOutlet weak var progressRing: UICircularProgressRingView!
    
    override func viewDidAppear(_ animated: Bool) {progressRing.animationStyle = kCAMediaTimingFunctionLinear
        
        var n=0
        while (sleepArray.count != 7){
            
            self.sleepArray.insert(0, at: n)
            n += 1
            
        }
        
        
        
        hoursSlept = sleepArray
        print("SLEEP 2 \(sleepArray)")
        setChart(dataPoints: days, values: hoursSlept)
        if let x = UserDefaults.standard.object(forKey: "sleepGoal") as? Double
        {
            // Change any of the properties you'd like
            progressRing.maxValue = CGFloat(x)
            progressRing.innerRingColor = UIColor.blue
            
            let sleepPercentage = Int((sleepGlobal/x) * 100)
            self.SleepLabel.text = "\(sleepPercentage)%"
            
            self.SleepGoalLabel.text = "Goal: \(x) hrs"
        }
        else
        {
            // Change any of the properties you'd like
            progressRing.maxValue = CGFloat(theUser.sleepGoal)
            progressRing.innerRingColor = UIColor.blue
            
            let sleepPercentage = Int((sleepGlobal/theUser.sleepGoal) * 100)
            self.SleepLabel.text = "\(sleepPercentage)%"
        }
        
        
        
        progressRing.setProgress(value: CGFloat(sleepGlobal), animationDuration: 2.0) {
            print("Done animating!")    }
        if sleepGlobal == 1.0 {
            SleepRefLabel.text = "\(sleepGlobal) hour"
        }
        else {
            SleepRefLabel.text = "\(sleepGlobal) hours"
        }
        
    }
    
    
    
    func retrieveWeekSleep()
        
    {
        
        
        let endDate = Date()
        
        let  startDate = Date(timeIntervalSinceNow: -60 * 60 * 24 * 7)
        
        
        
        if let sleepType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis) {
            
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: 30, sortDescriptors: [sortDescriptor]) { (query, tmpResult, error) -> Void in
                if let result = tmpResult {
                    for item in result {
                        if let sample = item as? HKCategorySample {
                            let value = (sample.value == HKCategoryValueSleepAnalysis.inBed.rawValue) ? "InBed" : "Asleep"
                            print("sleep: \(sample.startDate) \(sample.endDate) - source: \(sample.source.name) - value: \(value)")
                            
                            
                            
                            
                            let seconds = sample.endDate.timeIntervalSince(sample.startDate)
                            let minutes = seconds/60
                            let hours = minutes/60
                            
                            self.sleepArray.append(Double(hours))
                            
                            print( "SLEEP \(self.sleepArray)")
                        }
                    }
                }
            }
            
            healthKitStore.execute(query)
            
        }
        
        
        
    }
    
    
    
    
    
    
    func setChart(dataPoints: [String], values: [Double]) {
        WeeklyBarChart.noDataText = "You need to provide data for the chart."
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet( values: dataEntries, label: "Hours Slept")
        let chartData = BarChartData(dataSet: chartDataSet)
        
        WeeklyBarChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: days)
        WeeklyBarChart.xAxis.granularity = 1
        
        WeeklyBarChart.data = chartData
        WeeklyBarChart.animate(xAxisDuration: 4, yAxisDuration: 1)
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     func setChart(dataPoints: [String], values: [Double]) {
     FeelingsBarChart.noDataText = "You need to provide data for the chart."
     
     var dataEntries: [BarChartDataEntry] = []
     
     for i in 0..<dataPoints.count {
     let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
     dataEntries.append(dataEntry)
     }
     
     let chartDataSet = BarChartDataSet( values: dataEntries, label: "Emotion")
     let chartData = BarChartData(dataSet: chartDataSet)
     
     FeelingsBarChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:feelings)
     FeelingsBarChart.xAxis.granularity = 1
     
     FeelingsBarChart.data = chartData
     FeelingsBarChart.animate(xAxisDuration: 2, yAxisDuration: 1)
     chartDataSet.colors = [
     UIColor(red: 242/255, green: 233/255, blue: 68/255, alpha: 1),
     UIColor(red: 255/255, green: 206/255, blue: 74/255, alpha: 1),
     UIColor(red: 78/255, green: 223/255, blue: 77/255, alpha: 1),
     UIColor(red: 40/255, green: 171/255, blue: 245/255, alpha: 1),
     UIColor(red: 242/255, green: 64/255, blue: 36/255, alpha: 1),
     ]
     }
     */
    
}






