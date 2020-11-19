//
//  Homepage2ViewController.swift
//  FIT5140Ass3
//
//  Created by Tilain Lei on 2020/11/20.
//

import UIKit

class Homepage2ViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate, DatabaseListener {

    var listenerType: ListenerType = .all
    weak var databaseController: DatabaseProtocol?
    
    @IBOutlet weak var backgroudImageView: UIImage!
        @IBOutlet weak var collectionView: UICollectionView!
        
        @IBOutlet weak var currentUserProfileImageButton: UIButton!
        @IBOutlet weak var currentUserFullNameButton: UIButton!
        
        var movies = [Movie]()
        var movieImages = [UIImage]()
    
    private var interests = Recommondation.createInterest()
    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            databaseController = appDelegate.databaseController
            collectionView.dataSource = self
            collectionView.delegate = self
        }
        
        private struct Storyboard {
            static let CellIdentifier = "Interest Cell"
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
        collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "findLat" {
            let destination = segue.destination as! MovieSearchTableViewController
            destination.searchMethod = "now_playing"
        }

    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return movies.count
        return interests.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.CellIdentifier, for: indexPath) as! HomepageCollectionViewCell
//        let movie = movies[indexPath.item]
//
//        cell.interestTitleLabel.text = movie.title
//        let imgURL = movie.poster_path
//
//        if imgURL != "" {
//
//            let imageData = UserDefaults.standard.data(forKey: imgURL)
//            if imageData != nil {
//                cell.featuredImageView.image = UIImage(data: imageData!)?.reSizeImage(reSize: CGSize(width: 300, height: 444))
//            }
//
//        }else {
//            let imageDefault = "https://www.tibs.org.tw/images/default.jpg"
//            let imageData = UserDefaults.standard.data(forKey: imageDefault)
//            if imageData != nil {
//                cell.featuredImageView.image = UIImage(data: imageData!)?.reSizeImage(reSize: CGSize(width: 300, height: 444))
//            }
//        }
        cell.interest = self.interests[indexPath.item]
        return cell
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
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


    

