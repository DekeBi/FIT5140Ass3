//
//  MovieDetailViewController.swift
//  FIT5140Ass3
//
//  Created by user174132 on 11/2/20.
//
import youtube_ios_player_helper
import UIKit

class MovieDetailViewController: UIViewController {

    var selectedFilm : FilmData?
    
    @IBOutlet var youtubePlayer: YTPlayerView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var simBtn: UIButton!
    @IBOutlet weak var recomBtn: UIButton!
    
    var newVideos = [VideoData]()
    
    let POST_PATH = "https://image.tmdb.org/t/p/original"
    
    weak var databaseController: DatabaseProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
//        favoriteBtn.layer.cornerRadius = 5
//        favoriteBtn.layer.borderWidth = 1
//        favoriteBtn.layer.borderColor = UIColor.purple.cgColor
        
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
                        let videoId = self.newVideos[0].key
                        self.youtubePlayer.load(withVideoId: videoId!)
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
        showAlert(withTitle: "Adding Successful", message: "Already added this movie to your favorite")
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
}
