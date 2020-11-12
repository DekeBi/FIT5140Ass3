//
//  FilmData.swift
//  FIT5140Ass3
//
//  Created by Tilain Lei on 2020/11/11.
//

import UIKit

class FilmData: NSObject, Decodable {

    var id: Int?
    var title: String?
    var overview: String?
    var release_date: String?
    var poster_path: String?
    var backdrop_path: String?
    var vote_average: Double?
    
    private enum RootKeys: String, CodingKey {

        case id
        case title
        case overview
        case release_date
        case poster_path
        case backdrop_path
        case vote_average
    }
    
    required init(from decoder: Decoder) throws {
        let filmContainer = try decoder.container(keyedBy: RootKeys.self)
        id = try? filmContainer.decode(Int.self, forKey: .id)
        title = try? filmContainer.decode(String.self, forKey: .title)
        overview = try? filmContainer.decode(String.self, forKey: .overview)
        release_date = try? filmContainer.decode(String.self, forKey: .release_date)
        poster_path = try? filmContainer.decode(String.self, forKey: .poster_path)
        backdrop_path = try? filmContainer.decode(String.self, forKey: .backdrop_path)
        vote_average = try? filmContainer.decode(Double.self, forKey: .vote_average)
    }
}
