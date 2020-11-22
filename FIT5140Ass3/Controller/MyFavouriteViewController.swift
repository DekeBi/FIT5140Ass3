//
//  MyFavouriteViewController.swift
//  FIT5140Ass3
//
//  Created by user174132 on 11/2/20.
//

import UIKit


//Reference:https://www.youtube.com/watch?v=Fup54OirnpI (About the Deletion of multiple items in collection view)
//Refernces:https://www.youtube.com/watch?v=NSryf0YJHHk (About implementation of Collection view)


class MyFavouriteViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, DatabaseListener, UICollectionViewDelegateFlowLayout {
    
    var listenerType: ListenerType = .all
    weak var databaseController: DatabaseProtocol?
    
    //two modes of collection view:
    //1. normal mode: can click the cell and go to cinema details
    //2. select mode: can select multiple items and delete them together
    
    enum Mode{
        case view
        case select
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    var movies = [Movie]()
    var movieImages = [UIImage]()
    var cinemas = [Cinema]()
    
    var mMode : Mode = .view{
        didSet{
            switch mMode {
            case .view:
                
                for(key ,value) in dictionarySelectedIndecPath{
                    if value{
                        collectionView.deselectItem(at: key, animated: true)
                    }
                }
                
                dictionarySelectedIndecPath.removeAll()
                
                selectBarButton.title = "Select"
                selectBarButton.tintColor = .white
                navigationItem.leftBarButtonItem = nil
                collectionView.allowsMultipleSelection = false
            case .select:
                selectBarButton.title = "Cancel"
                selectBarButton.tintColor = .yellow
                navigationItem.leftBarButtonItem = deleteBarButton
                collectionView.allowsMultipleSelection = true
            }
        }
    }
    
    lazy var selectBarButton:UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(didSelectButtonClicked(_:)))
        return barButtonItem
    }()
    
    lazy var deleteBarButton:UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didDeleteButtonClicked(_:)))
        barButtonItem.tintColor = .yellow
        return barButtonItem
    }()
    
    var dictionarySelectedIndecPath: [IndexPath:Bool] = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "bg4"), for: .default)
        let layout = UICollectionViewFlowLayout()
        let padding: CGFloat = 20
        let paddingH: CGFloat = 80
        
        let collectionCellWidth = collectionView.frame.size.width - padding
        let collectionCellHeight = collectionView.frame.size.height - paddingH
        layout.itemSize = CGSize(width: collectionCellWidth/2, height: collectionCellHeight/2)
        collectionView.collectionViewLayout = layout
        
        collectionView.dataSource = self
        collectionView.delegate = self
        setupButtonItems()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setupButtonItems(){
        navigationItem.rightBarButtonItem = selectBarButton
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
        print(indexPath.item)
        let movie = movies[indexPath.item]
        cell.movieLabel.text = movie.title
        let imgURL = movie.poster_path
        
        if imgURL != "" {
            let size = cell.movieImageView.frame.width
            let sizeH = cell.movieImageView.frame.height
            let imageData = UserDefaults.standard.data(forKey: imgURL)
            if imageData != nil {
                cell.movieImageView.image = UIImage(data: imageData!)?.reSizeImage(reSize: CGSize(width: size, height: sizeH))
            }
            
        }else {
            let imageDefault = "https://www.tibs.org.tw/images/default.jpg"
            let imageData = UserDefaults.standard.data(forKey: imageDefault)
            if imageData != nil {
                cell.movieImageView.image = UIImage(data: imageData!)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if mMode == .view {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let myFavouriteDetailViewController = storyboard.instantiateViewController(withIdentifier: "myFavouriteDetail") as! MyFavouriteDetailViewController
                myFavouriteDetailViewController.selectedMovie = movies[indexPath.item]
                navigationController?.pushViewController(myFavouriteDetailViewController, animated: true)
            
            
         
        }
        
        if mMode == .select{
            dictionarySelectedIndecPath[indexPath] = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if mMode == .select{
            dictionarySelectedIndecPath[indexPath] = false
        }
    }
    
    @objc func didSelectButtonClicked(_ sender:UIBarButtonItem){
        //mMode = mMode == .view ? .select : .view
        
        if mMode == .view
        {
            mMode = .select
        }
        else
        {
            mMode = .view
            dictionarySelectedIndecPath.removeAll()
            
        }
    }
    
    @objc func didDeleteButtonClicked(_ sender:UIBarButtonItem){
        var deleteNeededIndexPath:[IndexPath] = []
        
        for(key ,value) in dictionarySelectedIndecPath{
            if value{
                deleteNeededIndexPath.append(key)
                self.databaseController?.deleteMyFavouriteMovie(movie: movies[key.item])
            }
        }
        
        for i in deleteNeededIndexPath.sorted(by: {$0.item > $1.item} ){
            movies.remove(at: i.item)
        }
        collectionView.deleteItems(at: deleteNeededIndexPath)
        dictionarySelectedIndecPath.removeAll()
        collectionView.reloadData()
    }
    
    
    func onCinemaListChange(change: DatabaseChange, cinemaList: [Cinema]) {
        cinemas = cinemaList
        
    }
    
    func onMovieListChange(change: DatabaseChange, movieList: [Movie]) {
        movies = movieList
        
    }
     
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 20
        let paddingH: CGFloat = 80
        let collectionCellWidth = collectionView.frame.size.width - padding
        let collectionCellHeight = collectionView.frame.size.height - paddingH
        return CGSize(width: collectionCellWidth/2, height: collectionCellHeight/2)
    }

}
