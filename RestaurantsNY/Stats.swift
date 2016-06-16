//
//  Stats.swift
//  RestaurantsNY
//
//  Created by Harim Tejada on 6/15/16.
//  Copyright © 2016 Harim Tejada. All rights reserved.
//

import Foundation
import ObjectMapper


class Stats : Mappable {
    
    var cities: Int?
    var countries: Int?
    var restaurants: Int?
    required init?(_ map: Map) {
        
    }
    func mapping(map: Map){
        cities <- map["cities"]
    }
}