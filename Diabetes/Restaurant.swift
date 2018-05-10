//
//  Restaurant.swift
//  NearbyRestaurants
//
//  Created by Kenny Dang on 6/2/17.
//  Copyright © 2017 frooctus LLC. All rights reserved.
//

import MapKit

class Restaurant {
    // The name of our restaurant
    var name: String
    
    // A placemark will give us the restaurant's coordinates
    var placeMark: MKPlacemark
    
    init(name: String, placeMark: MKPlacemark) {
        self.name = name
        self.placeMark = placeMark
    }
}
