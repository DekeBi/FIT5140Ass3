//
//  SearchFilterViewController.swift
//  FIT5140Ass3
//
//  Created by Tilain Lei on 2020/11/11.
//

import UIKit

class SearchFilterViewController: UIViewController {
    @IBOutlet weak var popularBtn: UIButton!
    
    @IBOutlet weak var topBtn: UIButton!
    
    @IBOutlet weak var upComingBtn: UIButton!
    
    @IBOutlet weak var lastestBtn: UIButton!
    
    var searchMethod : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func popularBtn(_ sender: UIButton) {
//        let searchMethod = "popular"
//        performSegue(withIdentifier: "findPopSegue", sender: searchMethod)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "findPopSegue" {
            let destination = segue.destination as! MovieSearchTableViewController
            destination.searchMethod = "popular"
        }
        
        if segue.identifier == "findTopSegue" {
            let destination = segue.destination as! MovieSearchTableViewController
            destination.searchMethod = "top_rated"
        }
        
        if segue.identifier == "findUpSegue" {
            let destination = segue.destination as! MovieSearchTableViewController
            destination.searchMethod = "upcoming"
        }
        
        if segue.identifier == "findLastestSegue" {
            let destination = segue.destination as! MovieSearchTableViewController
            destination.searchMethod = "now_playing"
        }
        
    }
    
}
