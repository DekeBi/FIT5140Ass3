//
//  locationData.swift
//  FIT5140Ass3
//
//  Created by user174132 on 11/5/20.
//

import Foundation

class LocationData: NSObject,Decodable{
    
    var location:LatLongData?
    
    private enum CodingKeys:String,CodingKey{
        case location
    }

    
}
