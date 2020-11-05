//
//  LatLongData.swift
//  FIT5140Ass3
//
//  Created by user174132 on 11/5/20.
//

import Foundation

class LatLongData:NSObject,Decodable{
    
    var lat:String?
    var long:String?
    
    private enum RootKeys:String,CodingKey{
        case lat
        case long = "lng"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        
        lat = try "\(container.decode(Double.self, forKey: .lat))"
        long = try "\(container.decode(Double.self, forKey: .long))"
    }

    
}
