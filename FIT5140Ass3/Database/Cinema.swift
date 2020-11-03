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
    case name
    case address
}

class Cinema: NSObject, Decodable, Encodable {
    
    var id : String?
    var name : String
    var address : String
    
    override init() {
        id = ""
        name = ""
        address = ""
    }
    
    init(id : String, name : String, address : String) {
        self.id = id
        self.name = name
        self.address = address
    }
    
}
