//
//  ViewController.swift
//  NutyriAPI
//
//  Created by Malhotra,Neil on 5/2/17.
//  Copyright © 2017 Wang,Rongrong. All rights reserved.
//

import UIKit
import LocalAuthentication

class NutritionSearchViewController: UIViewController,UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    var dataTask: URLSessionDataTask?
    var food = [FoodAndItsResults]()
   // let data: Data?
    //let json = try? JSONSerialization.jsonObject(with:data,options:[])
    
    //if let dictionary = jsonWithObjectRoot as? [String:Any]{
        
    //}
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    func updateSearchResults(_ data: Data?) {
       food.removeAll()
        do {
            if let dataInput: Data = data, let jsonParsed = try? JSONSerialization.jsonObject(with: dataInput, options:JSONSerialization.ReadingOptions(rawValue:0)) {
                print("😊json results from Nutritionix")
                print(jsonParsed)
                if let dictLevel1 = jsonParsed as? [String: Any] {
                    if let foodArr = dictLevel1["hits"] as? NSArray {
                        print("Num of results is 🐻")
                        print(foodArr.count)
                            for foodSet in foodArr {
                                if let foodMessyDict = foodSet as? [String : Any]{
                                if let foodDict = foodMessyDict["fields"] as? [String:Any]{
                                let name = foodDict["item_name"] as? String
                                let cal = foodDict["nf_calories"] as Any
                                    let calStr = cal as! Double
                                let fat = foodDict["nf_total_fat"] as Any
                                    let fatStr = fat as? Double ?? 0.0
                                    print("calories is")
                                    print(calStr)
                                    print("fat is ")
                                    print(fatStr as Any)
                                    print("name of the food is")
                                    print(name as Any)
                                    food.append(FoodAndItsResults(name:name!,fat:fatStr,cal:calStr))
                                print(food)
                                print("🍴")
                                }else {
                                    print("Error: search view controller, foodDict ")
                                }
                        }
                        }
                    }else {
                        print("Error: search view controller, dictLevel2")
                    }

                }else {
                    print("Error: search view controller, dictLevel1")
                }
                
            }else {
                print("Error: search view controller, dictLevel1")
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.setContentOffset(CGPoint.zero, animated: false)
        }
            }
    

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        if !searchBar.text!.isEmpty {
            if dataTask != nil {
                dataTask?.cancel()
            }
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let expectedCharSet = CharacterSet.urlQueryAllowed
        let searchText = searchBar.text!.addingPercentEncoding(withAllowedCharacters: expectedCharSet)!
        print("看看链接成什么样😪")
        print(String(searchText) as Any)
        let id = "ff35e5bb"
        let apiKey = "ca6076d34d452bfb106b7d179b31d420"
        let url = URL(string:"https://api.nutritionix.com/v1_1/search/\(searchText)?fields=item_name%2Citem_id%2Cbrand_name%2Cnf_calories%2Cnf_total_fat&appId=\(id)&appKey=\(apiKey)")
        dataTask = defaultSession.dataTask(with: url!, completionHandler: {
            data, response, error in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            if let error = error {
                print(error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    self.updateSearchResults(data)
                    print(httpResponse)
                    print(data as Any)
                }
            }
        })
        dataTask?.resume()
    }
    
    
    override func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
           }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return food.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodCell", for: indexPath) as! FoodCell
        let food2 = food[(indexPath as NSIndexPath).row]
        // Configure food name labels
        cell.foodLabel.text = food2.name
        cell.calLabel.text = String(food2.cal)+" cals"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FoodCell
        let foodname = cell.foodLabel.text
        let foodcal = cell.calLabel.text
        
        performSegue(withIdentifier: "addBreakfastSegue", sender: self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
