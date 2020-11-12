//
//  FilmData.swift
//  FIT5140Ass3
//
//  Created by Tilain Lei on 2020/11/11.
//

import UIKit

class FilmData: NSObject, Decodable {
//    var Title: String?
//    var Year: Int?
//    var Released: String?
//    var Genre: String?
//    var Plot: String?
//    var Actors: String?
//    var Country: String?
//    var Language: String?
//    var Poster: String?
//    var imdbRating: Int?
//    var imdbID: String?
    var id: Int?
    var title: String?
    var overview: String?
    var release_date: String?
    
    private enum RootKeys: String, CodingKey {
//        case Title
//        case Year
//        case Released
//        case Genre
//        case Plot
//        case Actors
//        case Country
//        case Language
//        case Poster
//        case imdbRating
//        case imdbID
        case id
        case title
        case overview
        case release_date
    }
    
    required init(from decoder: Decoder) throws {
        let filmContainer = try decoder.container(keyedBy: RootKeys.self)
        id = try? filmContainer.decode(Int.self, forKey: .id)
        title = try? filmContainer.decode(String.self, forKey: .title)
        overview = try? filmContainer.decode(String.self, forKey: .overview)
        release_date = try? filmContainer.decode(String.self, forKey: .release_date)
//        Title = try? filmContainer.decode(String.self, forKey: .Title)
//        Year = try? filmContainer.decode(Int.self, forKey: .Year)
//        Released = try? filmContainer.decode(String.self, forKey: .Released)
//        Genre = try? filmContainer.decode(String.self, forKey: .Genre)
//        Plot = try? filmContainer.decode(String.self, forKey: .Plot)
//        Actors = try? filmContainer.decode(String.self, forKey: .Actors)
//        Country = try? filmContainer.decode(String.self, forKey: .Country)
//        Language = try? filmContainer.decode(String.self, forKey: .Language)
//        Poster = try? filmContainer.decode(String.self, forKey: .Poster)
//        imdbRating = try? filmContainer.decode(Int.self, forKey: .imdbRating)
//        imdbID = try? filmContainer.decode(String.self, forKey: .imdbID)
    }
}
