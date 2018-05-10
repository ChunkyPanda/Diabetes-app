//
//  RestaurantController.swift
//  NearbyRestaurants
//
//  Created by Kenny Dang on 6/2/17.
//  Copyright © 2017 frooctus LLC. All rights reserved.
//

import MapKit

class RestaurantController {
    // Our cool singleton property.
    static let shared = RestaurantController()
    
    // Our fetch function will have a closure parameter called completion
    // which will return an optional array of Restaurants
    func fetchNearbyRestaurants(completion: @escaping ([Restaurant]?) -> Void) {
        // Our search request object that will search for "Restaurants"
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = RestaurantType
        
        // Intiaites a one time map based search
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            
            // Automatically calls completion(nil) whenever we exit scope early
            defer {
                completion(nil)
            }
            
            guard error == nil else {
                print("Uh oh, a wild error has appeared: \(error?.localizedDescription)")
                return
            }
            
            guard let response = response else {
                print("Uh oh, this is a bad response :(")
                return
            }
            
            var restaurants = [Restaurant]()
            
            // We loop through each item to check if it has a
            // name. At the end of the loop, we return
            // a list of Restaurants
            restaurants = response.mapItems.flatMap {
                guard let name = $0.name else {
                    print("No name")
                    return nil
                }
                
                return Restaurant(name: name, placeMark: $0.placemark)
            }
            
            completion(restaurants)
        }
    }
}
