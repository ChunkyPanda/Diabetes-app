//
//  FoodModel.swift
//  NutyriAPI
//
//  Created by Malhotra,Neil on 5/2/17.
//  Copyright © 2017 Wang,Rongrong. All rights reserved.
//

import Foundation

class FoodAndItsResults{
    //let popular: Int
    //let id: String
    var name: String
    var fat: Double//String
    var cal: Double//String
    
init(name: String, fat: Double, cal: Double) {
    self.name = name
    self.fat = fat
    self.cal = cal
}
}
/*extension FoodAndItsResults{
    init?(json: [String:Any]) throws{
        guard let popular = json["total_hits"] as? Int else{
            throw SerializationError.missing("total_hits")
        }
        guard let listsofResults = json["hits"] as? [Any],
        
    }
}*/
