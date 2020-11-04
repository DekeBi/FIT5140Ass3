//
//  HomeViewController.swift
//  FIT5140Ass3
//
//  Created by user174132 on 11/2/20.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DatabaseListener {
    
    var listenerType: ListenerType = .all
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var filmTableView: UITableView!
    
    var allFilms: [Film] = []
    
    weak var databaseController: DatabaseProtocol?
    
    var imgArr = [UIImage(named:"image3")?.reSizeImage(reSize: CGSize(width: 414, height: 300)) ,
        UIImage(named:"image2")?.reSizeImage(reSize: CGSize(width: 414, height: 300)),
        UIImage(named:"image4")?.reSizeImage(reSize: CGSize(width: 414, height: 300))]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        filmTableView.dataSource = self
        filmTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.filmTableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allFilms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = filmTableView.dequeueReusableCell(withIdentifier: "filmCell", for: indexPath) as! FilmTableViewCell
        let film = allFilms[indexPath.row]
        cell.nameLabel.text = film.film_name
        cell.despLabel.text = film.film_image
        
        return cell
        
    }
    
    func onCinemaListChange(change: DatabaseChange, cinemaList: [Cinema]) {
        // do nothing
    }
    
    func onFilmListChange(change: DatabaseChange, filmList: [Film]) {
        allFilms = filmList
    }
    
    func onFilmChange(change: DatabaseChange, filmCinemas: [Cinema]) {
        // do something
    }

}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? DataCollectionViewCell
        cell?.img.image = imgArr[indexPath.row]
        return cell!
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        return CGSize(width: size.width, height:size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
