//
//  VolumeData.swift
//  FirebaseDemo
//
//  Created by Tilain Lei on 2020/11/3.
//  Copyright © 2020 Monash University. All rights reserved.
//

import Foundation

class VolumeData: NSObject, Decodable {
    
    var cinemas: [CinemaData]?
    
    private enum CodingKeys: String, CodingKey {
        case cinemas
    }

}
