//
//  DirectionVolumeData.swift
//  FIT5140Ass3
//
//  Created by user174132 on 11/10/20.
//

import Foundation

class DirectionVolumeData:NSObject,Decodable{
    var routes:[RouteData]?
    var status:String
    
    private enum CodingKeys:String,CodingKey{
        case routes
        case status
    }
}
