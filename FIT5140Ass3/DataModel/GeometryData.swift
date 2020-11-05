//
//  Geometry.swift
//  FIT5140Ass3
//
//  Created by user174132 on 11/5/20.
//

import Foundation

class GeometryData:NSObject,Decodable{
    var geometry:LocationData
    
    private enum CodingKeys:String,CodingKey{
        case geometry
    }
}
