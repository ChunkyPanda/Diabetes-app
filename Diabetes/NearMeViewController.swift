//
//  NearMeViewController.swift
//  Diabetes
//
//  Created by Malhotra, Neil on 8/2/17.
//  Copyright © 2017 Malhotra, Neil. All rights reserved.
//

import UIKit
import MapKit
import FirebaseAnalytics

class NearMeViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        Analytics.logEvent("nearme_opened", parameters: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
  
    @IBOutlet weak var RestaurantPicker: UIPickerView!
    
    
    
        
       
        
        
        //weak var axisFormatDelegate: IAxisValueFormatter?
        
       var valueselected = ""
        
        var restaurants = ["Salad","Grilled Chicken","Steak","Burgers(without bread)","Black Coffee","Eggs,Bacon","Fajitas","Sashimi"]
       
        
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return restaurants[row]
        }
        
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return restaurants.count
        }
        
       
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            
            valueselected = restaurants[row] as String
        }
        
        
        
    @IBAction func GoButton(_ sender: Any) {
        
        switch valueselected{
            case "Salad":
                RestaurantType = "Salad"
            case "Grilled Chicken":
                RestaurantType = "Chicken"
            case "Steak":
                RestaurantType = "Steak"
            case "Burgers(without bread)":
                RestaurantType = "Burger"
            case "Black Coffee":
                RestaurantType = "Coffee Shop"
            case "Eggs,Bacon":
                RestaurantType = "Breakfast"
            case "Fajitas":
                RestaurantType = "Mexican Restaurant"
            case "Sashimi":
                RestaurantType = "Sushi"
            default:
                break
        }
        
        Analytics.logEvent("nearme_used", parameters: ["nearme_food_lookup" : RestaurantType])
        
    }
}






        
        
      

        
    


 
   

    

