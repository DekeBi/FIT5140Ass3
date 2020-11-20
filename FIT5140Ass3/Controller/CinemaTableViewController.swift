//
//  CinemasTableViewController.swift
//  FirebaseDemo
//
//  Created by Tilain Lei on 2020/11/3.
//  Copyright © 2020 Monash University. All rights reserved.
//

import UIKit

class CinemaTableViewController: UITableViewController, DatabaseListener, UISearchResultsUpdating {
    
    let CELL_CINEMA = "cinemaCell"
    var allCinemas: [Cinema] = []
    var filteredCinemas: [Cinema] = []
    weak var cinemaDelegate: AddCinemaDelegate?
    
    weak var databaseController: DatabaseProtocol?

    var listenerType: ListenerType = .all
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = UIImageView(image: UIImage(named: "bg4"))
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "bg4"), for: .default)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        filteredCinemas = allCinemas
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Cinemas"
        navigationItem.searchController = searchController
        
        // This view controller decides how the search controller is presented
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else {
            return
        }
        
        if searchText.count > 0 {
            filteredCinemas = allCinemas.filter({ (cinema: Cinema) -> Bool in
                return cinema.name.lowercased().contains(searchText) ?? false
            })
        } else {
            filteredCinemas = allCinemas
        }
        
        tableView.reloadData()
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredCinemas.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_CINEMA, for: indexPath)

        // Configure the cell...
        let cinema = filteredCinemas[indexPath.row]
        cell.textLabel?.text = cinema.name
        cell.detailTextLabel?.text = cinema.address
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCinema = filteredCinemas[indexPath.row]
        performSegue(withIdentifier: "showCinemaDetail", sender: selectedCinema)
    }

    // MARK: - Segue Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCinemaDetail"{
            let destination = segue.destination as! CinemaDetailViewController
            destination.selectedCinema = sender as? Cinema
        }
    }

    func onCinemaListChange(change: DatabaseChange, cinemaList: [Cinema]) {
        
        allCinemas = cinemaList
        updateSearchResults(for: navigationItem.searchController!)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.databaseController?.deleteCinema(cinema: filteredCinemas[indexPath.row])
            tableView.reloadData()
        }
    }
    
    func onFilmChange(change: DatabaseChange, filmCinemas: [Cinema]) {
        // do nothing
    }
    
    func onFilmListChange(change: DatabaseChange, filmList: [Film]) {
        // do nothing
    }
    
    func onMovieListChange(change: DatabaseChange, movieList: [Movie]) {
        // do something
    }
    
}
