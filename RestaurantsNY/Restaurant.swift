//
//  Restaurant.swift
//  RestaurantsNY
//
//  Created by Harim Tejada on 6/15/16.
//  Copyright © 2016 Harim Tejada. All rights reserved.
//

import Foundation
import ObjectMapper
class Restaurant : Mappable {
    
    var id: Int!
    var name: String?
    var address: String?
    var city: String?
    var state: String?
    var area: String?
    var postal_code: String?
    var country: String?
    var phone: String?
    var longitude: Double?
    var latitude: Double?
    var price: Int?
    var mobile_reserve_url: String?
    var image_url: String?
    var reserve_url: String?
    required init?(_ map: Map) {
        
    }
    func mapping(map: Map){
        id <- map["id"]
        name <- map["name"]
        address <- map["address"]
        city <- map["city"]
        state <- map["state"]
        area <- map["area"]
        postal_code <- map["postal_code"]
        country <- map["country"]
        phone <- map["phone"]
        latitude <- map["lat"]
        longitude <- map["lng"]
        price <- map["price"]
        reserve_url <- map["reserve_url"]
        area <- map["area"]
        mobile_reserve_url <- map["mobile_reserve_url"]
        image_url <- map["image_url"]

    }
}