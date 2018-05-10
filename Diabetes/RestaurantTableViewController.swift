//
//  RestaurantTableViewController.swift
//  NearbyRestaurants
//
//  Created by Kenny Dang on 6/2/17.
//  Copyright © 2017 frooctus LLC. All rights reserved.
//

import UIKit
import CoreLocation

class RestaurantTableViewController: UITableViewController {
    
    var restaurants = [Restaurant]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        RestaurantController.shared.fetchNearbyRestaurants { (restaurants) in
            guard let restaurants = restaurants else {
                print("Uh oh no restaurants!")
                return
            }
            
            self.restaurants = restaurants
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell", for: indexPath)
        cell.textLabel?.text = restaurants[indexPath.row].name

        return cell
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "listToMapVC" {
            guard let indexPath = tableView.indexPathForSelectedRow else {
                return
            }
            
            let destinationVC = segue.destination as? MapDetailViewController
            destinationVC?.restaurant = restaurants[indexPath.row]
        }
    }
    
}
