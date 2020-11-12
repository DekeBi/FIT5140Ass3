//
//  MovieSearchTableViewController.swift
//  FIT5140Ass3
//
//  Created by user174132 on 11/2/20.
//

import UIKit

class MovieSearchTableViewController: UITableViewController {

    var searchMethod: String?
    
    var newFilms = [FilmData]()
    
    let CELL_FILM = "filmCell"
    
    let API_KEY = "ebaec4a7e78e4ee21f565b43fbc4e40e"
    
    var indicator = UIActivityIndicatorView()
    
    
    private var dataTask: URLSessionDataTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.center = self.tableView.center
        self.view.addSubview(indicator)
        
        searchFilms()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return newFilms.count
    }

    func searchFilms(){
        let movieURL = "https://api.themoviedb.org/3/movie/" + searchMethod! + "?api_key=ebaec4a7e78e4ee21f565b43fbc4e40e&language=en-US&page=1"
        guard let url = URL(string: movieURL) else {return}

        dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error { print(error)
                return
            }
            do {
                let decoder = JSONDecoder()
                //print(data!)
                let volumeData = try decoder.decode(VolumeData.self, from: data!)
                if let films = volumeData.results {
                    self.newFilms.append(contentsOf: films)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()}
                }
            } catch let err {
                print(err) }
        }
        dataTask?.resume()
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_FILM, for: indexPath)
        
        let film = newFilms[indexPath.row]
        cell.textLabel?.text = film.title
        cell.detailTextLabel?.text = film.overview
        
        return cell
    }
    

    

}
