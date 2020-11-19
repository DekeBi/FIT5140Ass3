//
//  MyFavouriteViewController.swift
//  FIT5140Ass3
//
//  Created by user174132 on 11/2/20.
//

import UIKit

class MyFavouriteViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, DatabaseListener, UICollectionViewDelegateFlowLayout {
    
    var listenerType: ListenerType = .all
    weak var databaseController: DatabaseProtocol?
    
    @IBOutlet weak var collectionView: UICollectionView!
    var movies = [Movie]()
    var movieImages = [UIImage]()
    var cinemas = [Cinema]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 160, height: 300)
        collectionView.collectionViewLayout = layout
        
        collectionView.dataSource = self
        collectionView.delegate = self

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
        collectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myFavouriteCell", for: indexPath) as! MyFavouriteCollectionViewCell
        let movie = movies[indexPath.item]
        cell.movieLabel.text = movie.title
        let imgURL = movie.poster_path
        
        if imgURL != "" {
        
            let imageData = UserDefaults.standard.data(forKey: imgURL)
            if imageData != nil {
                cell.movieImageView.image = UIImage(data: imageData!)
            }
            
        } else {
            let imageDefault = "https://www.tibs.org.tw/images/default.jpg"
            let imageData = UserDefaults.standard.data(forKey: imageDefault)
            if imageData != nil {
                cell.movieImageView.image = UIImage(data: imageData!)
            }
        }
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let selectedMovie =  movies[indexPath.row]
//        performSegue(withIdentifier: "myFavouriteSegue", sender: selectedMovie)
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "myFavouriteSegue"{
        
        if let cell = sender as? UICollectionViewCell,
           let indexPath = self.collectionView.indexPath(for: cell){
            let selectedMovie =  movies[indexPath.item]
            let destination = segue.destination as! MyFavouriteDetailViewController
            destination.selectedMovie = selectedMovie
            
        }
        }
           
    }
    
    func onCinemaListChange(change: DatabaseChange, cinemaList: [Cinema]) {
        cinemas = cinemaList
        
    }
    
    func onMovieListChange(change: DatabaseChange, movieList: [Movie]) {
        movies = movieList
        
    }
    
    func onFilmListChange(change: DatabaseChange, filmList: [Film]) {
        
    }
    
    func onFilmChange(change: DatabaseChange, filmCinemas: [Cinema]) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 300)
    }

}
