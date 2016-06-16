//
//  City.swift
//  RestaurantsNY
//
//  Created by Harim Tejada on 6/15/16.
//  Copyright © 2016 Harim Tejada. All rights reserved.
//

import Foundation
import ObjectMapper


class Cities : Mappable {
    
    var cities: [String]?
    
    required init?(_ map: Map) {
        
    }
    func mapping(map: Map){
        cities <- map["cities"]
    }
}