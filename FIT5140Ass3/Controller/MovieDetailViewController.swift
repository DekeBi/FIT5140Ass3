//
//  MovieDetailViewController.swift
//  FIT5140Ass3
//
//  Created by user174132 on 11/2/20.
//
import youtube_ios_player_helper
import SafariServices
import UIKit

class MovieDetailViewController: UIViewController, DatabaseListener {
    
    var listenerType: ListenerType = .all
    weak var databaseController: DatabaseProtocol?

    var selectedFilm : FilmData?
    var movies = [Movie]()
    @IBOutlet var youtubePlayer: YTPlayerView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var simBtn: UIButton!
    @IBOutlet weak var recomBtn: UIButton!
    
    var newVideos = [VideoData]()
    
    let POST_PATH = "https://image.tmdb.org/t/p/original"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "bg4"), for: .default)
        titleLabel.text = selectedFilm?.title
        releaseLabel.text = selectedFilm?.release_date
        overviewLabel.numberOfLines = 0
        overviewLabel.sizeToFit()
        overviewLabel.text = selectedFilm?.overview
        let rating = Int(selectedFilm!.vote_average!)
        let ratingText = (0..<rating).reduce("") { (acc, _) -> String in
            return acc + "★"
        }
        
        ratingLabel.text = ratingText + "  " + "\(ratingText.count)/10"
        
        addBtn.layer.cornerRadius = 5
        
        recomBtn.layer.cornerRadius = 5
        
        simBtn.layer.cornerRadius = 5
        
        let movieId = selectedFilm?.id
        searchVedio(movie_id: movieId!)
        
        if selectedFilm?.imdb_id == nil {
            searchImdbID(movie_id: movieId!)
        }
        searchImdbID(movie_id: movieId!)
        
        //db
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }

    // https://www.youtube.com/watch?v=bsM1qdGAVbU
    func searchVedio(movie_id : Int){
        
        let vedioURL = "https://api.themoviedb.org/3/movie/\(movie_id)/videos?api_key=ebaec4a7e78e4ee21f565b43fbc4e40e&language=en-US"
        guard let url = URL(string: vedioURL) else {return}

        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            
            if let error = error {
                print(error)
                return
            }

            do {
                let decoder = JSONDecoder()
                let volumeData = try decoder.decode(VedioVolumeData.self, from: data!)
                if let videos = volumeData.results {
                    self.newVideos.append(contentsOf: videos)

                    DispatchQueue.main.async {
                        if (self.newVideos.count > 0){
                            let videoId = self.newVideos[0].key
                            self.youtubePlayer.load(withVideoId: videoId!)
                        }
                    }
                }
            } catch let err {
                print(err)
            }
        }

        task.resume()
    }
    
    @IBAction func addBtn(_ sender: Any) {
        
        let id = selectedFilm!.id!
        let inStr = String(id)
        var flag = true
        for mov in movies {
            if mov.id == inStr {
                flag = false
            }
        }
        if flag {
            let title = selectedFilm?.title
            let overview = selectedFilm?.overview
            let release_data = selectedFilm?.release_date
            let pp = selectedFilm?.poster_path!
            let poster_path = POST_PATH + pp!
            let bp = selectedFilm?.backdrop_path
            let backdrop_path = POST_PATH + bp!
            let vote_average = selectedFilm!.vote_average!
            let voteStr = String(vote_average)
            let imdb_id = selectedFilm!.imdb_id!
            let runtimeInt = selectedFilm!.runtime!
            let runtimeStr = String(runtimeInt)
            let _ = databaseController?.addMovie(id:inStr, title: title!, overview: overview!, release_data:release_data!,poster_path:poster_path,backdrop_path:backdrop_path,vote_average:voteStr,imdb_id: imdb_id,runtime: runtimeStr)
            
            addBtn.backgroundColor = UIColor.purple
            
            addBtn.setTitle("Add Successful", for: UIControl.State.normal)
            
            addBtn.isEnabled = false
            
            showAlert(withTitle: "Add Successful", message: "Added successful!")
        } else {
            addBtn.backgroundColor = UIColor.purple
            
            addBtn.setTitle("Already in favorite", for: UIControl.State.normal)
            
            addBtn.isEnabled = false
            
            showAlert(withTitle: "Add Fail", message: "This movie is already on your favorite list")
        }
        
    }
    
    @IBAction func searchMoreBtn(_ sender: Any) {
        let imdb_id = self.selectedFilm!.imdb_id!
        let searchURL = "https://www.imdb.com/title/\(imdb_id)/"
        let vc = SFSafariViewController(url: URL(string: searchURL)!)
        present(vc, animated: true)
    }
    
    @IBAction func recomButton(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let movieSearchTableViewController = storyboard.instantiateViewController(withIdentifier: "movieSearch") as! MovieSearchTableViewController
        
        let mid = String(selectedFilm!.id!)
        let method = mid + "/recommendations"
        
        movieSearchTableViewController.searchMethod = method
            navigationController?.pushViewController(movieSearchTableViewController, animated: true)
    }
    
    
    @IBAction func simButton(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let movieSearchTableViewController = storyboard.instantiateViewController(withIdentifier: "movieSearch") as! MovieSearchTableViewController
        
        let mid = String(selectedFilm!.id!)
        let method = mid + "/similar"
        
        movieSearchTableViewController.searchMethod = method
            navigationController?.pushViewController(movieSearchTableViewController, animated: true)
        
    }
    
    func onCinemaListChange(change: DatabaseChange, cinemaList: [Cinema]) {
        
    }
    
    func onMovieListChange(change: DatabaseChange, movieList: [Movie]) {
        movies = movieList
        
    }
    
    func searchImdbID(movie_id : Int){
        let movieURL = "https://api.themoviedb.org/3/movie/\(movie_id)?api_key=ebaec4a7e78e4ee21f565b43fbc4e40e&append_to_response=videos,credits"
        guard let url = URL(string: movieURL) else {return}

        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error { print(error)
                    return
            }
            
            guard let data = data else {return}

        do {
            let film = try JSONDecoder().decode(FilmEXTRA.self, from: data)
            self.selectedFilm?.imdb_id = film.imdb_id
            self.selectedFilm?.runtime = film.runtime
            let runtimeInt = film.runtime
            let runtimeStr = String(runtimeInt)
            DispatchQueue.main.async {
                self.runtimeLabel.text = runtimeStr + " mins"
            }
            
                
        } catch let err {
            print(err)
        }
        }
        dataTask.resume()
    }
}

struct FilmEXTRA : Decodable{
    let imdb_id: String
    let runtime: Int
}
