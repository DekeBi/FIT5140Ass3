//
//  Cinema.swift
//  FirebaseDemo
//
//  Created by Tilain Lei on 2020/11/2.
//  Copyright © 2020 Monash University. All rights reserved.
//

import UIKit

enum CodingKeys: String, CodingKey {
    case id
    case cinema_id
    case name
    case address
    case city
    case lat
    case lng
}

class Cinema: NSObject, Decodable, Encodable {
    var id : String?
    var cinema_id : String?
    var name : String
    var address : String
    var city: String
    var lat: String
    var lng: String
    
    override init() {
        id = ""
        cinema_id = ""
        name = ""
        address = ""
        city = ""
        lat = ""
        lng = ""
    }
    
    init(id : String, cinema_id : String, name : String, address : String, city: String, lat: String, lng: String) {
        self.cinema_id = cinema_id
        self.name = name
        self.address = address
        self.city = city
        self.lat = lat
        self.lng = lng
    }
    
}
