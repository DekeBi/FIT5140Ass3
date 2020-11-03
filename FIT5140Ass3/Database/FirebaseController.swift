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
    var cinemaList: [Cinema]
    
    override init() {
        FirebaseApp.configure()
        authController = Auth.auth()
        database = Firestore.firestore()
        cinemaList = [Cinema]()
        
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
            
        }
    }
    
    // MARK:- Parse Functions for Firebase Firestore responses
    func parseCinemasSnapshot(snapshot: QuerySnapshot) {
        snapshot.documentChanges.forEach{(change) in let cinemaId = change.document.documentID
            print(cinemaId)
            
            var parsedCinema: Cinema?
            
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
            
            cinema.id = cinemaId
            if change.type == .added{
                cinemaList.append(cinema)
            }
            else if change.type == .modified {
                let index = getCinemaIndexByID(cinemaId)!
                cinemaList[index] = cinema
            }
            else if change.type == .removed {
                if let index = getCinemaIndexByID(cinemaId) {
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
    
    func addCinema(id: String, name: String, address: String) -> Cinema {
        let cinema = Cinema()
        cinema.id = id
        cinema.name = name
        cinema.address = address

        do {
            if let cinemaRef = try cinemaRef?.addDocument(from: cinema) {
                cinema.id = cinemaRef.documentID
            }

        } catch {
            print("Failed to serialize cinema")
        }
        return cinema
    }
    
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        
        if listener.listenerType == ListenerType.cinemas ||
        listener.listenerType == ListenerType.all {
            listener.onCinemaListChange(change: .update, cinemaList: cinemaList)
        }
    }
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    func cleanup() {
        
    }
    

}

