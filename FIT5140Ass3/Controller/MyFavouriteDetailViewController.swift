//
//  MyFavouriteDetailViewController.swift
//  FIT5140Ass3
//
//  Created by user174132 on 11/18/20.
//

import UIKit
import youtube_ios_player_helper
import SafariServices

class MyFavouriteDetailViewController: UIViewController {
    
    var selectedMovie:Movie?

    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var playerView: YTPlayerView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var releaseLabel: UILabel!
    
    @IBOutlet weak var overviewLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var recomBtn: UIButton!
    @IBOutlet weak var simBtn: UIButton!
    var newVideos = [VideoData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        let rt = selectedMovie?.runtime ?? "120"
        runtimeLabel.text = rt + " mins"
        
        recomBtn.layer.cornerRadius = 5
        
        simBtn.layer.cornerRadius = 5
        
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
    
    
    @IBAction func recomButton(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let movieSearchTableViewController = storyboard.instantiateViewController(withIdentifier: "movieSearch") as! MovieSearchTableViewController
        
        if let id = selectedMovie?.id{
            
            let mid = String(id)
            let method = mid + "/recommendations"
            
            movieSearchTableViewController.searchMethod = method
                navigationController?.pushViewController(movieSearchTableViewController, animated: true)
        }
        
    }
    
    @IBAction func searchMoreBtn(_ sender: Any) {
        let imdb_id = self.selectedMovie!.imdb_id
        let searchURL = "https://www.imdb.com/title/\(imdb_id)/"
        let vc = SFSafariViewController(url: URL(string: searchURL)!)
        present(vc, animated: true)
    }
    
    @IBAction func simButton(_ sender: Any) {
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let movieSearchTableViewController = storyboard.instantiateViewController(withIdentifier: "movieSearch") as! MovieSearchTableViewController
        if let id = selectedMovie?.id{
            
            let mid = String(id)
            let method = mid + "/similar"
            
            movieSearchTableViewController.searchMethod = method
                navigationController?.pushViewController(movieSearchTableViewController, animated: true)
        }
       
    }
    
}
