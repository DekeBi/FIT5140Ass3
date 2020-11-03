//
//  CinemaData.swift
//  FirebaseDemo
//
//  Created by Tilain Lei on 2020/11/2.
//  Copyright © 2020 Monash University. All rights reserved.
//

import Foundation

class CinemaData: NSObject, Decodable {
    
    var cinema_id: Int?
    var name: String?
    var address: String?
    var city: String?
    
    private enum RootKeys: String, CodingKey {
        case cinema_id
        case name = "cinema_name"
        case address
        case city
    }
    
    required init(from decoder: Decoder) throws {
        let cinemaContainer = try decoder.container(keyedBy: RootKeys.self)
        cinema_id = try? cinemaContainer.decode(Int.self, forKey: .cinema_id)
        name = try? cinemaContainer.decode(String.self, forKey: .name)
        address = try? cinemaContainer.decode(String.self, forKey: .address)
        city = try? cinemaContainer.decode(String.self, forKey: .city)
    }

}
