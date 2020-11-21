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
    var movieRef:CollectionReference?
    var cinemaList: [Cinema]
    var movieList: [Movie]
    
    override init() {
        FirebaseApp.configure()
        authController = Auth.auth()
        database = Firestore.firestore()
        cinemaList = [Cinema]()
        movieList = [Movie]()
        
        super.init()
        
        authController.signInAnonymously() {
            (authResult, error) in
            guard authResult != nil else {
                fatalError("Firebase authentication failed")
            }
            self.setUpCinemaListener()
            self.setUpMovieListener()
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
            
        }
    }
    
    func setUpMovieListener() {
        movieRef = database.collection("favoriteMovies")
        movieRef?.addSnapshotListener {
            (querySnapshot, error) in guard let querySnapshot = querySnapshot else {
                print("Error fetching documents:\(error!)")
                return
            }
            self.parseMoviesSnapshot(snapshot: querySnapshot)
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
    
    // MARK:- Parse Functions for Firebase Firestore responses
    func parseMoviesSnapshot(snapshot: QuerySnapshot) {
        snapshot.documentChanges.forEach{(change) in let Id = change.document.documentID
            print(Id)
            
            var parsedMovie: Movie?
            
            //get cinemas
            do {
                parsedMovie = try change.document.data(as: Movie.self)
            } catch {
                print("Unable to decode cinema. Is the movie malformed")
                return
            }
            
            guard let movie = parsedMovie else {
                print("Document doesn't exist")
                return;
            }
            
            movie.refId = Id
            if change.type == .added{
                movieList.append(movie)
            }
            else if change.type == .modified {
                if let index = getMovieIndexByID(Id){
                movieList[index] = movie
                }
            }
            else if change.type == .removed {
                if let index = getMovieIndexByID(Id) {
                    movieList.remove(at: index)
                }
            }
            
        }
        listeners.invoke{ (listener) in
        if listener.listenerType == ListenerType.movies || listener.listenerType == ListenerType.all {
            listener.onMovieListChange(change: .update, movieList: movieList)
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
    
    func getMovieIndexByID(_ id: String) -> Int? {
        if let movie = getMovieByID(id) {
            return movieList.firstIndex(of: movie)
        }
        return nil
    }
    
    func getMovieByID(_ id: String) -> Movie? {
        for movie in movieList {
            if movie.refId == id {
                return movie
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
    
    func addMovie(id: String, title: String, overview: String, release_data: String, poster_path: String, backdrop_path: String, vote_average: String, imdb_id: String, runtime: String) -> Movie{
        let movie = Movie()
        movie.id = id
        movie.title = title
        movie.overview = overview
        movie.release_date = release_data
        movie.poster_path = poster_path
        movie.backdrop_path = backdrop_path
        movie.vote_average = vote_average
        movie.imdb_id = imdb_id
        movie.runtime = runtime

        do {
            if let movieRef = try movieRef?.addDocument(from: movie) {
                movie.refId = movieRef.documentID
            }

        } catch {
            print("Failed to serialize movie")
        }
        return movie
    }

    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        
        if listener.listenerType == ListenerType.cinemas ||
        listener.listenerType == ListenerType.all {
            listener.onCinemaListChange(change: .update, cinemaList: cinemaList)
        }
        
        if listener.listenerType == ListenerType.movies ||
        listener.listenerType == ListenerType.all {
            listener.onMovieListChange(change: .update, movieList: movieList)
        }
    }
    
    func deleteCinema(cinema: Cinema) {
        if let cinemaID = cinema.id {
            cinemaRef?.document(cinemaID).delete()
        }
    }
    
    func deleteMyFavouriteMovie(movie: Movie) {
        if let movieID = movie.refId{
            movieRef?.document(movieID).delete()
        }
    }
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
        
    }
    
    func cleanup() {
        
    }
}


