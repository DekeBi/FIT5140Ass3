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
    
    @IBOutlet weak var movieNameTextField: UITextField!
    @IBOutlet weak var releaseYearTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var searchBtn: UIButton!
    
    var searchMethod : String = ""
    var flag : Bool = false
    //var queryString : String = ""
    
    //var yearString : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorMessageLabel.isHidden = true
    }
    
    @IBAction func popularBtn(_ sender: UIButton) {

        
    }
    
    @IBAction func searchBtn(_ sender: Any) {
        //flag = isValida()
    }
    
    // prevent segue
    // https://stackoverflow.com/questions/28883050/swift-prepareforsegue-cancel
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        errorMessageLabel.isHidden = true
        
        if identifier == "searchSegue" {
            let keyCount = movieNameTextField.text?.count
            if keyCount == 0 {
                errorMessageLabel.isHidden = false
                errorMessageLabel.text = "Please enter keywords!"
                return false
            }
        }
        return true
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

        if segue.identifier == "searchSegue" {
            let destination = segue.destination as! MovieSearchTableViewController
            destination.searchMethod = "search/movie"
            
            let queryString = movieNameTextField.text
            destination.query = queryString

            if releaseYearTextField.text != "" {
                let yearString = releaseYearTextField.text!
                destination.year = yearString
            }
            
        }
        
    }
    
}
