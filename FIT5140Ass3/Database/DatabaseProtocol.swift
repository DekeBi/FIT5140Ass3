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
    case all
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func onCinemaListChange(change: DatabaseChange, cinemaList: [Cinema])
}

protocol DatabaseProtocol: AnyObject {
    func addCinema(id: String, cinema_id: String, name: String, address: String, city: String) -> Cinema
    
    func addListener(listener: DatabaseListener)
    
    func removeListener(listener: DatabaseListener)
    
    func cleanup()
}

