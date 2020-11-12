//
//  VideoData.swift
//  FIT5140Ass3
//
//  Created by Tilain Lei on 2020/11/13.
//

import UIKit

class VideoData: NSObject, Decodable {
    
    var key: String?
    
    private enum RootKeys: String, CodingKey {

        case key
    }
    
    required init(from decoder: Decoder) throws {
        let filmContainer = try decoder.container(keyedBy: RootKeys.self)
        key = try? filmContainer.decode(String.self, forKey: .key)
        
    }
}
