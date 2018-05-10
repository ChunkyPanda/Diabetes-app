//
//  NutritionDisplayViewController.swift
//  Diabetes
//
//  Created by Arrington, Darryn on 8/1/17.
//  Copyright © 2017 Malhotra, Neil. All rights reserved.
//

import Foundation
import UIKit

class NutritionDisplayViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var nutritionDisplayTitleLabel: UILabel!
    @IBOutlet weak var nutritionDisplayTable: UITableView!
    var nutritionDisplayList = [Food]()
    
    var titleText: String = "--"
    
    @IBAction func addFoodItem(_ sender: Any) {
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count: Int?
        
        if tableView == self.nutritionDisplayTable {
            count = nutritionDisplayList.count
        }
        
        return count!
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            nutritionDisplayList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        
        if(tableView == self.nutritionDisplayTable) {
            cell = tableView.dequeueReusableCell(withIdentifier: "nutritionCell", for: indexPath)
            cell!.textLabel!.font = UIFont(name:"Avenir", size:12)
            cell!.textLabel!.text = nutritionDisplayList[indexPath.row].getFoodName() + " - " + nutritionDisplayList[indexPath.row].getFoodInfo()
        }
        
        return cell!
    }
    
    override func viewDidLoad() {
        nutritionDisplayTitleLabel.text = titleText
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "nutritionListToAddItemSegue"
        {
            switch titleText {
                case "Breakfast":
                    foodCategorySegmentInit = 0
                    break
                case "Lunch":
                    foodCategorySegmentInit = 1
                    break
                case "Dinner":
                    foodCategorySegmentInit = 2
                    break
                case "Snack(s)":
                    foodCategorySegmentInit = 3
                    break
                default:
                    break
            }
        }
    }
    
}
