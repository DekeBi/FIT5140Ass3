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
    let GEOLOCATION = "-33.872889;151.206244"
    
    var indicator = UIActivityIndicatorView()
    var newCinemas = [CinemaData]()
    
    weak var databaseController: DatabaseProtocol?
    
    let MAX_REQUESTS = 10
    var currentRequestPage: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundView = UIImageView(image: UIImage(named: "bg4"))
        
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
        let lat = cinemaData.lat!
        let lng = cinemaData.lng!
        
        let inStr = String(cinema_id)
        let _ = databaseController?.addCinema(id:id, cinema_id:inStr, name:name, address:address, city:city, lat: lat, lng: lng)
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
        searchURLComponentrs.path = "/cinemaLiveSearch/"
            
        // alternate new api
        let headers2 = ["client":"    STUD_154","x-api-key":"010t1k7dg58xPGY98RwunS659q9n7C03SBIXKXwd", "Authorization":"Basic U1RVRF8xNTQ6ZzFKa0RmY1hNb0k0","territory":"AU","api-version":"v200","geolocation":GEOLOCATION,"device-datetime":"2020-11-04T07:08:05.644Z"]
        
        let headers = ["client":"IT_0","x-api-key":"lzOlyufYrJ2puY0gIxEcy8QbS4gHCcZP6u3i6NUy", "Authorization":"Basic SVRfMDpnNmlEa3hzcE0xZlY=","territory":"AU","api-version":"v200","geolocation":GEOLOCATION,"device-datetime":"2020-11-04T07:08:05.644Z"]
            
        searchURLComponentrs.queryItems = [URLQueryItem(name: "n", value: "5"),URLQueryItem(name: "query", value: cinemaName)]
            
        var request = URLRequest(url: (searchURLComponentrs.url)!)
            request.httpMethod = "GET"
            for (key, value) in headers2 {
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
            
            if (data == nil) {
                self.showAlert(withTitle: "Search Fail", message: "There are no items that match keywords")
            } else {
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
            }}
            task.resume()

    }
    
}

