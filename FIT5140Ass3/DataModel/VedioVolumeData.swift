//
//  VedioVolumeData.swift
//  FIT5140Ass3
//
//  Created by Tilain Lei on 2020/11/13.
//

import UIKit

class VedioVolumeData: NSObject, Decodable {
    
    var results: [VideoData]?
    
    private enum CodingKeys: String, CodingKey {
        
        case results
    }
}
