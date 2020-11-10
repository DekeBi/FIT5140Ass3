//
//  RouteData.swift
//  FIT5140Ass3
//
//  Created by user174132 on 11/10/20.
//

import Foundation

class RouteData:NSObject,Decodable{
    
    var point:String?
    
    private enum RootKeys:String,CodingKey{
        case line = "overview_polyline"
    }
    
    private struct Lines:Decodable{
        var points:String?
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        
        let lines = try container.decode(Lines.self, forKey: .line)
      
        point = lines.points
    }

    
}
