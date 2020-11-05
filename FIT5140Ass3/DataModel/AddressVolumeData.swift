//
//  AddressVolumeData.swift
//  FIT5140Ass3
//
//  Created by user174132 on 11/5/20.
//

import Foundation

class AddressVolumnData:NSObject,Decodable{
    var result:[GeometryData]?
    var status:String
    
    private enum CodingKeys:String,CodingKey{
        case result = "results"
        case status
    }
    
}
