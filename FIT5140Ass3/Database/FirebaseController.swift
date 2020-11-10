//
//  FirebaseController.swift
//  FirebaseDemo
//
//  Created by Tilain Lei on 2020/11/3.
//  Copyright © 2020 Monash University. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirebaseController: NSObject, DatabaseProtocol {
    
    var listeners = MulticastDelegate<DatabaseListener>()
    var authController: Auth
    var database: Firestore
    var cinemaRef: CollectionReference?
    var filmRef:CollectionReference?
    var cinemaList: [Cinema]
    var filmList: [Film]
    
    override init() {
        FirebaseApp.configure()
        authController = Auth.auth()
        database = Firestore.firestore()
        cinemaList = [Cinema]()
        filmList = [Film]()
        
        super.init()
        
        authController.signInAnonymously() {
            (authResult, error) in
            guard authResult != nil else {
                fatalError("Firebase authentication failed")
            }
            self.setUpCinemaListener()
        }
        
    }
    
    func setUpCinemaListener() {
        cinemaRef = database.collection("cinemas")
        cinemaRef?.addSnapshotListener {
            (querySnapshot, error) in guard let querySnapshot = querySnapshot else {
                print("Error fetching documents:\(error!)")
                return
            }
            self.parseCinemasSnapshot(snapshot: querySnapshot)
            self.setUpFilmListener()
        }
    }
    
    func setUpFilmListener() {
        filmRef = database.collection("films")
        filmRef?.addSnapshotListener {
            (querySnapshot, error) in guard let querySnapshot = querySnapshot
                //let filmSnapshot = querySnapshot.document
            else {
                print("Error fetching documents:\(error!)")
                return
            }
            self.parseFilmsSnapshot(snapshot: querySnapshot)
            
        }
    }
    
    // MARK:- Parse Functions for Firebase Firestore responses
    func parseCinemasSnapshot(snapshot: QuerySnapshot) {
        snapshot.documentChanges.forEach{(change) in let Id = change.document.documentID
            print(Id)
            
            var parsedCinema: Cinema?
            
            //get cinemas
            do {
                parsedCinema = try change.document.data(as: Cinema.self)
            } catch {
                print("Unable to decode cinema. Is the cinema malformed")
                return
            }
            
            guard let cinema = parsedCinema else {
                print("Document doesn't exist")
                return;
            }
            
            cinema.id = Id
            if change.type == .added{
                cinemaList.append(cinema)
            }
            else if change.type == .modified {
                if let index = getCinemaIndexByID(Id){
                cinemaList[index] = cinema
                }
            }
            else if change.type == .removed {
                if let index = getCinemaIndexByID(Id) {
                    cinemaList.remove(at: index)
                }
            }
            
        }
        listeners.invoke{ (listener) in
        if listener.listenerType == ListenerType.cinemas || listener.listenerType == ListenerType.all {
            listener.onCinemaListChange(change: .update, cinemaList: cinemaList)
        }
        }
    }
    
    func parseFilmsSnapshot(snapshot: QuerySnapshot) {
        snapshot.documentChanges.forEach{(change) in let Id = change.document.documentID
            print(Id)
            
            var parsedFilm: Film?
            
            //get cinemas
            do {
                parsedFilm = try change.document.data(as: Film.self)
            } catch {
                print("Unable to decode cinema. Is the film malformed")
                return
            }
            
            guard let film = parsedFilm else {
                print("Document doesn't exist")
                return;
            }
            
            film.id = Id
            if change.type == .added{
                filmList.append(film)
            }
            else if change.type == .modified {
                  let index = getFilmIndexByID(Id)!
                  filmList[index] = film
            }
            else if change.type == .removed {
                  if let index = getFilmIndexByID(Id) {
                      filmList.remove(at: index)
                  }
            }
            
        }
        listeners.invoke{ (listener) in
            if listener.listenerType == ListenerType.films || listener.listenerType == ListenerType.all  {
            listener.onFilmListChange(change: .update, filmList: filmList)
        }
        }
    }
    
    func getCinemaIndexByID(_ id: String) -> Int? {
        if let cinema = getCinemaByID(id) {
            return cinemaList.firstIndex(of: cinema)
        }
        return nil
    }
    
    func getCinemaByID(_ id: String) -> Cinema? {
        for cinema in cinemaList {
            if cinema.id == id {
                return cinema
            }
        }
        return nil
    }
    
    func getFilmIndexByID(_ id: String) -> Int? {
        if let film = getFilmByID(id) {
            return filmList.firstIndex(of: film)
        }
        return nil
    }
    
    func getFilmByID(_ id: String) -> Film? {
        for film in filmList {
            if film.id == id {
                return film
            }
        }
        return nil
    }
    
    func addCinema(id: String, cinema_id: String, name: String, address: String, city: String, lat: String, lng: String) -> Cinema {
        let cinema = Cinema()
        cinema.id = id
        cinema.cinema_id = cinema_id
        cinema.name = name
        cinema.address = address
        cinema.city = city
        cinema.lat = lat
        cinema.lng = lng

        do {
            if let cinemaRef = try cinemaRef?.addDocument(from: cinema) {
                cinema.id = cinemaRef.documentID
            }

        } catch {
            print("Failed to serialize cinema")
        }
        return cinema
    }
    
//    func addFilm(filmName: String) -> Film {
//        // do something
//        let film = Film()
//        film.imdb_id = imdb_id
//        film.film_name =
//
//    }
    
    func addCinemaToFilm(cinema: Cinema, film: Film) -> Bool {
        // do something
        return true
    }
    
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        
        if listener.listenerType == ListenerType.cinemas ||
        listener.listenerType == ListenerType.all {
            listener.onCinemaListChange(change: .update, cinemaList: cinemaList)
        }
        
        if listener.listenerType == ListenerType.films ||
        listener.listenerType == ListenerType.all {
            listener.onFilmListChange(change: .update, filmList: filmList)
        }
    }
    
    func deleteCinema(cinema: Cinema) {
        if let cinemaID = cinema.id {
            cinemaRef?.document(cinemaID).delete()
        }
    }
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
        
    }
    
    func cleanup() {
        
    }
}


