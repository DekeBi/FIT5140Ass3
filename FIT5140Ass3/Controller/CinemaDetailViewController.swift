
//  CinemaDetailViewController.swift
//  FIT5140Ass3
//
//  Created by user174132 on 11/2/20.
//

import UIKit

class CinemaDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func mapButton(_ sender: Any) {
        
        let storyboard = UIStoryboard(name:"Main",bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "map") as! MapViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}
