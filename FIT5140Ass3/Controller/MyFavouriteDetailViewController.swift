//
//  MyFavouriteDetailViewController.swift
//  FIT5140Ass3
//
//  Created by user174132 on 11/18/20.
//

import UIKit
import youtube_ios_player_helper

class MyFavouriteDetailViewController: UIViewController {
    
    var selectedMovie:Movie?

    @IBOutlet weak var playerView: YTPlayerView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var releaseLabel: UILabel!
    
    @IBOutlet weak var overviewLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    var newVideos = [VideoData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"bg4")!)

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "bg4"), for: .default)
        titleLabel.text = selectedMovie?.title
        releaseLabel.text = selectedMovie?.release_date
        overviewLabel.numberOfLines = 0
        overviewLabel.sizeToFit()
        overviewLabel.text = selectedMovie?.overview
        
        if let ratingString = (selectedMovie?.vote_average){
            
            if let ratingDouble = Double(ratingString){
                let rating = Int(ratingDouble)
                    let ratingText = (0..<rating).reduce("") { (acc, _) -> String in
                        return acc + "★"
                    }
                    ratingLabel.text = ratingText + "  " + "\(ratingText.count)/10"
            }
            
        }
        
  
        
        if let movieId = (selectedMovie?.id){
            if let movieInt = Int(movieId){
                searchVideo(movie_id: movieInt )
            }
            
            
        }
        
    }
    
    func searchVideo(movie_id : Int){
        
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
                            self.playerView.load(withVideoId: videoId!)
                        }
                    }
                }
            } catch let err {
                print(err)
            }
        }

        task.resume()
    }

}
