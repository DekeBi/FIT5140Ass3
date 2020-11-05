
//  CinemaDetailViewController.swift
//  FIT5140Ass3
//
//  Created by user174132 on 11/2/20.
//

import UIKit
import GoogleMaps

class CinemaDetailViewController: UIViewController {
    
    var selectedCinema: Cinema?
    let baseUrl = "https://maps.googleapis.com/maps/api/geocode/json?"
    let apikey = "AIzaSyBixFth5Vz_Gn27L46ZbsnfYS_SlZY_gDI"

    @IBOutlet weak var mapView: GMSMapView!
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
        
        self.drawCinemaOnMap(address: selectedCinema?.address ?? "675 Glenferrie Road")
        
    }
    
    func showMarker(position:CLLocationCoordinate2D){
        
        let marker = GMSMarker()
        marker.position = position
        marker.title = selectedCinema?.name
        marker.snippet = selectedCinema?.city
        marker.map = mapView
        
    }
    
    func drawCinemaOnMap(address:String){
        
        let searchString = "\(baseUrl)address=\(address)&key=\(apikey)"
        print(searchString)
        
        let jsonURL =
            URL(string: searchString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        
        let task = URLSession.shared.dataTask(with:jsonURL!) {
            (data,response,error) in
            
            if let error = error{
                print(error)
                return
            }

            do{
            
                let decoder = JSONDecoder()
                let addressVolumeData = try decoder.decode(AddressVolumnData.self, from: data!)
                var geometryData:GeometryData
                var locationData:LocationData
                var latLongData:LatLongData
                
                if addressVolumeData.status == "OK"{
                    
                     if let tempGeometry = addressVolumeData.result{
                        
                        geometryData = tempGeometry[0]
                        locationData = geometryData.geometry
                        latLongData = locationData.location!
                      
                        let latitude = Double(latLongData.lat!)
                        let longitude = Double(latLongData.long!)
                        
                        DispatchQueue.main.async {
                            let camera = GMSCameraPosition.camera(withLatitude:latitude!, longitude: longitude!, zoom: 15.0)
                            self.mapView.camera = camera
                            self.showMarker(position: self.mapView.camera.target)
                        }
                    }
                }
            }
            catch let err
            {
                print(err)
            }
        }
        
        task.resume()
    }
    
}
