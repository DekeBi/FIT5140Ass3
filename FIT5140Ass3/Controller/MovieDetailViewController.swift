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
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var simBtn: UIButton!
    @IBOutlet weak var recomBtn: UIButton!
    var newVideos = [VideoData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = selectedFilm?.title
        releaseLabel.text = selectedFilm?.release_date
        overviewLabel.numberOfLines = 0
        overviewLabel.sizeToFit()
        overviewLabel.text = selectedFilm?.overview
        ratingLabel.text = "\(selectedFilm!.vote_average!)"
        let movieId = selectedFilm?.id
        searchVedio(movie_id: movieId!)
        
    }

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
}
