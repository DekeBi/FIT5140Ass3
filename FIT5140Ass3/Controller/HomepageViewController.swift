//
//  HomepageViewController.swift
//  FIT5140Ass3
//
//  Created by Tilain Lei on 2020/11/19.
//

import UIKit
import CardSlider

struct MovieData: CardSliderItem {
    let image: UIImage
    let rating: Int?
    let title: String
    let subtitle: String?
    let description: String?
}

class HomepageViewController: UIViewController, DatabaseListener {
    
    var listenerType: ListenerType = .all
    weak var databaseController: DatabaseProtocol?
    
    var movies = [MovieData]()
    
    var movieList = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //initMovies()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        initMovies()
        
        let cardSlider = CardSliderViewController.with(dataSource: self)
        cardSlider.title = "Welcome"
        
        cardSlider.modalPresentationStyle = .currentContext
        
        present(cardSlider, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    func onCinemaListChange(change: DatabaseChange, cinemaList: [Cinema]) {
        
    }
    
    func onMovieListChange(change: DatabaseChange, movieList: [Movie]) {
        self.movieList = movieList
        
    }
    
    func onFilmListChange(change: DatabaseChange, filmList: [Film]) {
        
    }
    
    func onFilmChange(change: DatabaseChange, filmCinemas: [Cinema]) {
        
    }
   
}

extension HomepageViewController: CardSliderDataSource {
    func item(for index: Int) -> CardSliderItem {
        return movies[index]
    }
    
    func numberOfItems() -> Int {
        return movies.count
    }
    
    func initMovies(){
//        for mov in movieList {
//            let raInt = Int(mov.vote_average)
//            movies.append(MovieData(image: #imageLiteral(resourceName: "BG"), rating: raInt, title: mov.title, subtitle: mov.release_date, description: mov.overview))
//        }
        
        movies.append(MovieData(image: #imageLiteral(resourceName: "1"), rating: 4, title: "The SpongeBob Movie: Sponge on the Run", subtitle: "2020-08-14", description: "A young blade runner's discovery of a long-buried secret leads him to track down former blade runner Rick Deckard, who's been missing for thirty years."))
        movies.append(MovieData(image: #imageLiteral(resourceName: "3"), rating: 3, title: "Roald Dahl's The Witch", subtitle: "2020-10-26", description: "In late 1967, a young orphaned boy goes to live with his loving grandma in the rural Alabama town of Demopolis. As the boy and his grandmother encounter some deceptively glamorous but thoroughly diabolical witches, she wisely whisks him away to a seaside resort. Regrettably, they arrive at precisely the same time that the world's Grand High Witch has gathered."))
        movies.append(MovieData(image: #imageLiteral(resourceName: "2"), rating: 4, title: "Once Upon a Snowman", subtitle: "2020-10-23", description: "The previously untold origins of Olaf, the innocent and insightful, summer-loving snowman are revealed as we follow Olaf’s first steps as he comes to life and searches for his identity in the snowy mountains outside Arendelle."))
        
                
    }
}
