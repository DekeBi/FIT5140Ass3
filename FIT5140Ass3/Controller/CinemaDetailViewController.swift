
//  CinemaDetailViewController.swift
//  FIT5140Ass3
//
//  Created by user174132 on 11/2/20.
//

import UIKit

class CinemaDetailViewController: UIViewController {
    
    var selectedCinema: Cinema?

    @IBOutlet weak var cinemaIdLabel: UILabel!
    @IBOutlet weak var cinemaNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!

    var indicator = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cinemaIdLabel.text = "\(selectedCinema!.cinema_id!)"
        cinemaNameLabel.text = selectedCinema?.name
        addressLabel.text = selectedCinema?.address
        phoneLabel.text = selectedCinema?.city
        
    }
    
}
