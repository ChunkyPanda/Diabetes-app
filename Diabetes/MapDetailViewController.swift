//
//  MapDetailViewController.swift
//  NearbyRestaurants
//
//  Created by Kenny Dang on 6/3/17.
//  Copyright © 2017 frooctus LLC. All rights reserved.
//

import UIKit
import MapKit

class MapDetailViewController: UIViewController {

    @IBOutlet weak var restaurantMapView: MKMapView!
    
    var restaurant:  Restaurant?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView()

    }
    
    func setupMapView() {
       guard let pm = restaurant?.placeMark else {
            print("no place mark")
            return
        }
        
        let region = MKCoordinateRegionMake(pm.coordinate, MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        
        let restaurantAnnotation = MKPointAnnotation()
        restaurantAnnotation.coordinate = pm.coordinate
        
        restaurantMapView.addAnnotation(restaurantAnnotation)
        restaurantMapView.setRegion(region, animated: true)
    }

}
