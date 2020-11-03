//
//  SearchCinemasTableViewController.swift
//  FirebaseDemo
//
//  Created by Tilain Lei on 2020/11/3.
//  Copyright © 2020 Monash University. All rights reserved.
//

import UIKit

class SearchCinemasTableViewController: UITableViewController, UISearchBarDelegate {
    
    let CELL_CINEMA = "cinemaCell"
    
    var indicator = UIActivityIndicatorView()
    var newCinemas = [CinemaData]()
    //var newCinemas2 = [Cinema]()
    weak var databaseController: DatabaseProtocol?
    
    let MAX_REQUESTS = 10
    var currentRequestPage: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for cinema"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true

        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.center = self.tableView.center
        self.view.addSubview(indicator)

        //db
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return newCinemas.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_CINEMA, for: indexPath)

        // Configure the cell...
        let cinema = newCinemas[indexPath.row]
        cell.textLabel?.text = cinema.name
        cell.detailTextLabel?.text = cinema.address

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cinemaData = newCinemas[indexPath.row]
                
        //convert cinemaData to cinema
        let id = ""
        let cinema_id = cinemaData.cinema_id!
        let name = cinemaData.name!
        let address = cinemaData.address!
        let city = cinemaData.city!
        
        let inStr = String(cinema_id)
        let _ = databaseController?.addCinema(id:id, cinema_id:inStr, name:name, address:address, city:city)
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Search Bar Delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // If there is no text end immediately
        guard let searchText = searchBar.text, searchText.count > 0 else {
            return; }
        indicator.startAnimating()
        indicator.backgroundColor = UIColor.clear
        newCinemas.removeAll()
        tableView.reloadData()

        
        URLSession.shared.invalidateAndCancel()

        currentRequestPage = 0
        requestCinemas(cinemaName: searchText)
        }

        // MARK: - Web Request
    func requestCinemas(cinemaName: String) {
             
        //URL构建器
        var searchURLComponentrs = URLComponents()
        searchURLComponentrs.scheme = "https"
        searchURLComponentrs.host = "api-gate2.movieglu.com"
        searchURLComponentrs.path = "/cinemasNearby/"
            
        let headers = ["client":"PERS_77","x-api-key":"tcGhu0dS0c7S7h5xaG7lAa5R2rgWuD7M27oqsRLy", "Authorization":"Basic UEVSU183NzppWmwyd0o3WGlrOVM=","territory":"AU","api-version":"v200","geolocation":"-37.882790;145.051080","device-datetime":"2020-11-03T08:45:24.353Z"]
            
        searchURLComponentrs.queryItems = [ URLQueryItem(name: "n", value: "2")]
            
        var request = URLRequest(url: (searchURLComponentrs.url)!)
            request.httpMethod = "GET"
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                // Regardless of response end the loading icon from the main thread
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
            }
            if let error = error { print(error)
                return
            }
            do {
                let decoder = JSONDecoder()
                let volumeData = try decoder.decode(VolumeData.self, from: data!)
                if let cinemas = volumeData.cinemas {

                    self.newCinemas.append(contentsOf: cinemas)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            } catch let err {
                print(err) }
            }
            task.resume()

    }
    
}

