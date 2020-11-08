//
//  DatabaseProtocol.swift
//  FIT5140Ass3
//
//  Created by Tilain Lei on 2020/11/3.
//

import Foundation

enum DatabaseChange {
    case add
    case remove
    case update
}

enum ListenerType {
    case cinemas
    case films
    case all
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func onCinemaListChange(change: DatabaseChange, cinemaList: [Cinema])
    func onFilmListChange(change: DatabaseChange, filmList: [Film])
    func onFilmChange(change: DatabaseChange, filmCinemas: [Cinema])
}

protocol DatabaseProtocol: AnyObject {
    func addCinema(id: String, cinema_id: String, name: String, address: String, city: String, lat: String, lng: String) -> Cinema
    
    func addListener(listener: DatabaseListener)
    //func addFilm(filmName: String) -> Film
    func addCinemaToFilm(cinema: Cinema, film: Film) -> Bool
    func deleteCinema(cinema: Cinema)
    
    func removeListener(listener: DatabaseListener)
    
    func cleanup()
}

