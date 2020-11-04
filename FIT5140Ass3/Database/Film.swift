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
    var cinemas : [Cinema]
    
    override init(){
        id = ""
        imdb_id = ""
        film_name = ""
        film_image = ""
        cinemas = [Cinema]()
    }
    
    init(id: String, imdb_id: String, film_name: String, film_image: String, cinemas: [Cinema]){
        self.id = id
        self.imdb_id = imdb_id
        self.film_name = film_name
        self.film_image = film_image
        self.cinemas = cinemas
    }
    
}
