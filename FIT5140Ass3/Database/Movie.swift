//
//  Movie.swift
//  FIT5140Ass3
//
//  Created by Tilain Lei on 2020/11/17.
//

import UIKit

class Movie: NSObject, Decodable, Encodable {
    
    var refId: String?
    var id: String
    var title: String
    var overview: String
    var release_date: String
    var poster_path: String
    var backdrop_path: String
    var vote_average: String
    
    override init() {
        refId = ""
        id = ""
        title = ""
        overview = ""
        release_date = ""
        poster_path = ""
        backdrop_path = ""
        vote_average = ""
    }

    init(refId: String, id: String, title: String, overview: String, release_date: String, poster_path: String, backdrop_path: String, vote_average: String) {
        self.id = id
        self.title = title
        self.overview = overview
        self.release_date = release_date
        self.poster_path = poster_path
        self.backdrop_path = backdrop_path
        self.vote_average = vote_average
    }
}
