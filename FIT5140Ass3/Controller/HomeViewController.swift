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
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
        //self.filmTableView.reloadData()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        databaseController?.addListener(listener: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allFilms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = filmTableView.dequeueReusableCell(withIdentifier: "filmCell", for: indexPath) as! FilmTableViewCell
        let film = allFilms[indexPath.row]
        cell.nameLabel.text = film.film_name
        cell.despLabel.text = film.film_desc
        cell.img.image = UIImage(named:"mulan")?.reSizeImage(reSize: CGSize(width: 30, height: 50))
        //downLoadImage(film : film)
        return cell
        
    }
    
    func downLoadImage(film : Film) {
         URLSession.shared.invalidateAndCancel()
        let imgUrl = film.film_image
        
        let jsonURL = URL(string: imgUrl)
        let task = URLSession.shared.dataTask(with: jsonURL!) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            if let uiImage = UIImage(data: data!){
                DispatchQueue.main.async {
                    //self.cardImage.image = uiImage
                }
            }
        }
        task.resume()

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFilm = allFilms[indexPath.row]
        performSegue(withIdentifier: "showFilmDetail", sender: selectedFilm)
    }

    // MARK: - Segue Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFilmDetail"{
            //let destination = segue.destination as! MovieDetailViewController
            //destination.selectedFilm = sender as? Film
        }
    }
    
    func onCinemaListChange(change: DatabaseChange, cinemaList: [Cinema]) {
        // do nothing
    }
    
    func onFilmListChange(change: DatabaseChange, filmList: [Film]) {
        allFilms = filmList
        self.filmTableView.reloadData()
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
