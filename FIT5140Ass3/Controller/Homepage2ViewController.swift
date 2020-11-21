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
    
    @IBOutlet weak var pageView: UIPageControl!
    @IBOutlet weak var backgroudImageView: UIImage!
        @IBOutlet weak var collectionView: UICollectionView!
        
        @IBOutlet weak var currentUserProfileImageButton: UIButton!
        @IBOutlet weak var currentUserFullNameButton: UIButton!
        
        var movies = [Movie]()
        var movieImages = [UIImage]()
    
        private var interests = Recommondation.createInterest()
    
        var timer = Timer()
        var counter = 0
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "bg4"), for: .default)
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            databaseController = appDelegate.databaseController
            
            pageView.numberOfPages = interests.count
            pageView.currentPage = 0
            DispatchQueue.main.async {
                self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
            }
            
            
            collectionView.dataSource = self
            collectionView.delegate = self
        }
        
        private struct Storyboard {
            static let CellIdentifier = "Interest Cell"
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // https://www.youtube.com/watch?v=cbeE3OQlU3c
    @objc func changeImage() {
        if counter < interests.count {
            let index = IndexPath.init(item: counter, section: 0)
            self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageView.currentPage = counter
            counter += 1
        } else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            pageView.currentPage = counter
            counter = 1
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
        collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "findShowing" {
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
        //cell.featuredImageView.layer.cornerRadius = 30.0
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //pageView.currentPage = indexPath.row
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
    
}


    

