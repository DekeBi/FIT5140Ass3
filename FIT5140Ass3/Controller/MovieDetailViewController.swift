//
//  MovieDetailViewController.swift
//  FIT5140Ass3
//
//  Created by user174132 on 11/2/20.
//
import youtube_ios_player_helper
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
        //ratingLabel.text = "\(selectedFilm!.vote_average!)"
        ratingLabel.text = ratingText + "  " + "\(ratingText.count)/10"
        
        addBtn.layer.cornerRadius = 5
        //addBtn.layer.borderWidth = 1
        //addBtn.layer.borderColor = UIColor.purple.cgColor
        
        //recomBtn.layer.cornerRadius = 5
        //recomBtn.layer.borderWidth = 1
        //recomBtn.layer.borderColor = UIColor.purple.cgColor
        
        //simBtn.layer.cornerRadius = 5
        //simBtn.layer.borderWidth = 1
        //simBtn.layer.borderColor = UIColor.purple.cgColor
        
        let movieId = selectedFilm?.id
        searchVedio(movie_id: movieId!)
        
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
        let count = movies.count
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
            let _ = databaseController?.addMovie(id:inStr, title: title!, overview: overview!, release_data:release_data!,poster_path:poster_path,backdrop_path:backdrop_path,vote_average:voteStr)
            
            addBtn.backgroundColor = UIColor.purple
            
            addBtn.setTitle("Add Successful", for: UIControl.State.normal)
            
            showAlert(withTitle: "Add Successful", message: "Added successful!")
        } else {
            showAlert(withTitle: "Add Fail", message: "This movie is already on your favorite list")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mid = String(selectedFilm!.id!)
        let method = mid + "/recommendations"
        if segue.identifier == "findRecomSegue" {
            let destination = segue.destination as! MovieSearchTableViewController
            destination.searchMethod = method
        }
        
        if segue.identifier == "findSimilarSegue" {
            let mid = String(selectedFilm!.id!)
            let method = mid + "/similar"
            let destination = segue.destination as! MovieSearchTableViewController
            destination.searchMethod = method
        }
        
    }
    
    func onCinemaListChange(change: DatabaseChange, cinemaList: [Cinema]) {
        
    }
    
    func onMovieListChange(change: DatabaseChange, movieList: [Movie]) {
        movies = movieList
        
    }
    
    func onFilmListChange(change: DatabaseChange, filmList: [Film]) {
        
    }
    
    func onFilmChange(change: DatabaseChange, filmCinemas: [Cinema]) {
        
    }
}
