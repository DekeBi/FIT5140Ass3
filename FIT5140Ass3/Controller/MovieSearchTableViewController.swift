//
//  MovieSearchTableViewController.swift
//  FIT5140Ass3
//
//  Created by user174132 on 11/2/20.
//

import UIKit

class MovieSearchTableViewController: UITableViewController {

    var searchMethod: String?
    
    var query: String?
    
    var year: String?
    
    var newFilms = [FilmData]()
    
    var imageURLsArray : [String] = []
    
    let CELL_FILM = "filmCell"
    
    let API_KEY = "ebaec4a7e78e4ee21f565b43fbc4e40e"
    let POST_PATH = "https://image.tmdb.org/t/p/original"
    
    var indicator = UIActivityIndicatorView()
    
    private var dataTask: URLSessionDataTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundView = UIImageView(image: UIImage(named: "bg4"))
        //self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "bg4"), for: .default)
        
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.center = self.tableView.center
        
        self.view.addSubview(indicator)
        
        indicator.startAnimating()
        indicator.backgroundColor = UIColor.clear
        
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
        var movieURL = "https://api.themoviedb.org/3/"
        if (query == nil && year == nil) {
            movieURL = movieURL + "movie/"
        }
        
        movieURL = movieURL + searchMethod! + "?api_key=" + API_KEY + "&language=en-US&page=1"
        
        if (query != nil) {
            movieURL = movieURL + searchMethod! +  "&include_adult=false&query=" + query!
        }
        if (year != nil) {
            movieURL = movieURL + "&year=" + year!
        }
        
        print(movieURL)
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
                    for film in films {
                        if film.poster_path != nil {
                        let imgURL = self.POST_PATH + film.poster_path!
                        //let imgURL =  film.poster_path
                        
                            self.imageURLsArray.append(imgURL)
                        } else {
                            self.imageURLsArray.append("https://www.tibs.org.tw/images/default.jpg")
                        }
                        
                    }
                    
                }
                self.downloadPicturesAndSaveToUserDefault()
                
            } catch let err {
                print(err) }
        }
        dataTask?.resume()
    }
    
    func downloadPicturesAndSaveToUserDefault(urls: String){

        let imageURL = URL(string: urls)
        let task = URLSession.shared.dataTask(with: imageURL!) { (data, response, error) in
            
            if let error = error{
                print(error.localizedDescription)
            }else{
                UserDefaults.standard.set(data,forKey: urls)
            }
        }
        task.resume()
    }
    
    func downloadPicturesAndSaveToUserDefault(){
        if (!imageURLsArray.isEmpty) {
            let imageURLString = imageURLsArray.removeFirst()
            
            let imageURL = URL(string: imageURLString)
            let task = URLSession.shared.dataTask(with: imageURL!){
                (data, response, error) in
                if let error = error{
                    print(error.localizedDescription)
                }else{
                    UserDefaults.standard.set(data, forKey: imageURLString)
                }
                if self.imageURLsArray.count > 0 {
                    self.downloadPicturesAndSaveToUserDefault()
                }
                if self.imageURLsArray.count == 0 {
                    DispatchQueue.main.async {
                        self.indicator.stopAnimating()
                        self.indicator.hidesWhenStopped = true
                        self.tableView.reloadData()
                    }
                }
            }
            task.resume()
        } else {
            showAlert(withTitle: "Search fail", message: "Could not find the movies!")
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_FILM, for: indexPath) as! MovieTableViewCell
        
        let film = newFilms[indexPath.row]
        cell.nameLabel.text = film.title
        cell.releaseLabel.text = film.release_date
        cell.despLabel.text = film.overview
        let imgURL = film.poster_path
        
        if imgURL != nil {
            let imgURL2 = self.POST_PATH + film.poster_path!
        
            let imageData = UserDefaults.standard.data(forKey: imgURL2)
            if imageData != nil {
                cell.movieImg.image = UIImage(data: imageData!)
            }
        } else {
            let imageDefault = "https://www.tibs.org.tw/images/default.jpg"
            let imageData = UserDefaults.standard.data(forKey: imageDefault)
            if imageData != nil {
                cell.movieImg.image = UIImage(data: imageData!)
            }
        }
        
        return cell
    }
    // segue to movie detail
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFilm = newFilms[indexPath.row]
        performSegue(withIdentifier: "showMovieDetail", sender: selectedFilm)
    }

    // MARK: - Segue Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMovieDetail"{
            let destination = segue.destination as! MovieDetailViewController
            destination.selectedFilm = sender as? FilmData
        }
    }
    
}
