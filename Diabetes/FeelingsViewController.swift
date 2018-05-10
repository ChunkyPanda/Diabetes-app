//
//  FeelingsViewController.swift
//  Diabetes
//
//  Created by Malhotra, Neil on 8/1/17.
//  Copyright © 2017 Malhotra, Neil. All rights reserved.
//

import UIKit
import Charts
import FirebaseAnalytics

class FeelingReadings {
    var feelingValue : String
    var dayActivity : String
    var note : String
    
    init() {
        feelingValue = "happy"
        dayActivity = "Home"
        note = "n/a"
    }
    
    init(fv : String, da : String, nt : String) {
        feelingValue = fv
        dayActivity = da
        note = nt
    }
}

var feelingReadingsArray = [FeelingReadings]()

class FeelingsViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {

    @IBOutlet weak var FeelingsPicker: UIPickerView!
    
    @IBOutlet weak var feelingsCarousel: iCarousel!
    var images = [UIImage(named: "happy"), UIImage(named: "stressed"), UIImage(named: "sick"), UIImage(named: "sad"), UIImage(named: "angry")]
    
    @IBOutlet weak var FeelingsBarChart: BarChartView!
    
    //weak var axisFormatDelegate: IAxisValueFormatter?
    
    var valueSelected = "happy"
    
    let feelings = ["happy","stressed","sick","sad","angry"]
    
    var feelingValues = [0.0, 0.0, 0.0, 0.0, 0.0]
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return feelings.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        //Create a UIView
        let tempView = UIView(frame: CGRect(x: 0,y: 0, width: 200, height: 200))
        
        //Create a UIImageView
        let frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        let imageView = UIImageView()
        imageView.frame = frame
        imageView.contentMode = .scaleAspectFit
        
        //Set the images to the imageView and add it to the tempView
        imageView.image = images[index]
        tempView.addSubview(imageView)
        
        return tempView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .spacing) {
            print(value)
            return value * 2.0
        }
        return value
    }
    
    @IBAction func addFeelingsButtonPressed(_ sender: Any) {
        switch feelingsCarousel.currentItemIndex {
            case 0:
                feelingValues[0] += 1.0
            case 1:
                feelingValues[1] += 1.0
            case 2:
                feelingValues[2] += 1.0
            case 3:
                feelingValues[3] += 1.0
            case 4:
                feelingValues[4] += 1.0
            default:
                break
        }
        
        feelingStatus = feelings[feelingsCarousel.currentItemIndex]
        
        setChart(dataPoints: feelings, values: feelingValues)
        UserDefaults.standard.set(feelingValues, forKey: "feelingValues")
        Analytics.logEvent("feeling_value_added", parameters: ["feeling_value" : feelings[feelingsCarousel.currentItemIndex]])
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feelingsCarousel.reloadData()
        feelingsCarousel.type = .rotary
        
        Analytics.logEvent("feeling_opened", parameters: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //axisFormatDelegate = self as! IAxisValueFormatter
        
        if let x = UserDefaults.standard.object(forKey: "feelingValues") as? [Double]
        {
            setChart(dataPoints: feelings, values: x)
            feelingValues = x
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FeelingsToAddFeelings" {
            let addFeelingsViewController = (segue.destination as? FeelingsLogViewController)
            addFeelingsViewController?.inputFeelingValue = feelingsCarousel.currentItemIndex
        }
    }
    
    
    
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
            UIColor(red: 203/255, green: 98/255, blue: 192/255, alpha: 1),
            UIColor(red: 78/255, green: 223/255, blue: 77/255, alpha: 1),
            UIColor(red: 40/255, green: 171/255, blue: 245/255, alpha: 1),
            UIColor(red: 242/255, green: 64/255, blue: 36/255, alpha: 1),
        ]
    }
    

}

/*

import UIKit
import Charts

class FeelingReadings {
    var feelingValue : String
    var dayActivity : String
    var note : String
    
    init() {
        feelingValue = "smiley"
        dayActivity = "Home"
        note = "n/a"
    }
    
    init(fv : String, da : String, nt : String) {
        feelingValue = fv
        dayActivity = da
        note = nt
    }
}

var feelingReadingsArray = [FeelingReadings]()

class FeelingsViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet weak var FeelingsPicker: UIPickerView!
    
    @IBOutlet weak var FeelingsBarChart: BarChartView!
    
    //weak var axisFormatDelegate: IAxisValueFormatter?
    
    var valueSelected = "smiley"
    
    let feelings = ["smiley","determined","sick","sad","angry"]
    
    var feelingValues = [0.0, 0.0, 0.0, 0.0, 0.0]
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return feelings[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return feelings.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let myView = UIView(frame: CGRect(x: 0, y: 0, width:pickerView.bounds.width - 30, height: 60))
        
        let myImageView = UIImageView(frame: CGRect(x: pickerView.bounds.width/2.0 - 50, y: 0, width: 50, height: 50))
        
        //var rowString = String()
        
        myImageView.image = UIImage(named: feelings[row])
        
        //let myLabel = UILabel(frame: CGRect(x: 60, y:0, width: pickerView.bounds.width - 90, height: 60 ))
        //myLabel.font = UIFont(name:some font, size: 18)
        //myLabel.text = rowString
        
        //myView.addSubview(myLabel)
        myView.addSubview(myImageView)
        
        return myView
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        valueSelected = feelings[row] as String
    }
    
    @IBAction func addFeelingsButtonPressed(_ sender: Any) {
        switch valueSelected {
        case "smiley":
            feelingValues[0] += 1.0
        case "determined":
            feelingValues[1] += 1.0
        case "sick":
            feelingValues[2] += 1.0
        case "sad":
            feelingValues[3] += 1.0
        case "angry":
            feelingValues[4] += 1.0
        default:
            break
        }
        
        setChart(dataPoints: feelings, values: feelingValues)
        UserDefaults.standard.set(feelingValues, forKey: "feelingValues")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //axisFormatDelegate = self as! IAxisValueFormatter
        
        if let x = UserDefaults.standard.object(forKey: "feelingValues") as? [Double]
        {
            setChart(dataPoints: feelings, values: x)
            feelingValues = x
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FeelingsToAddFeelings" {
            let addFeelingsViewController = (segue.destination as? FeelingsLogViewController)
            addFeelingsViewController?.inputFeelingValue = valueSelected
        }
    }
    
    
    
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
    
    
}

*/


