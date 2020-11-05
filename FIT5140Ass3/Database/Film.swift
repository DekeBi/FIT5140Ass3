//
//  Film.swift
//  FIT5140Ass3
//
//  Created by Tilain Lei on 2020/11/5.
//

import UIKit

class Film: NSObject, Decodable {
    
    var id : String
    var imdb_id : String
    var film_name : String
    var film_image : String
    var rate : String
    var release_date : String
    var film_desc : String
    var cinemas : [Cinema]
    
    override init(){
        id = ""
        imdb_id = ""
        film_name = ""
        film_image = ""
        rate = ""
        release_date = ""
        film_desc = ""
        cinemas = [Cinema]()
    }
    
    init(id: String, imdb_id: String, film_name: String, film_image: String, rate: String, release_date: String, film_desc: String, cinemas: [Cinema]){
        self.id = id
        self.imdb_id = imdb_id
        self.film_name = film_name
        self.film_image = film_image
        self.rate = rate
        self.release_date = release_date
        self.film_desc = film_desc
        self.cinemas = cinemas
    }
}
