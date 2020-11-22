//
//  NearbyCinemaViewController.swift
//  FIT5140Ass3
//
//  Created by user174132 on 11/19/20.
//

import UIKit
import GoogleMaps

//References:https://www.youtube.com/watch?v=_mFR7C6jKpM&t=929s  About how to integrate google map in to ios application development
//References:https://www.youtube.com/watch?v=JYjTiMli7S4  About how to draw route between start point and destination

class NearbyCinemaViewController: UIViewController ,CLLocationManagerDelegate{

    @IBOutlet weak var nearbyCinemaMap: GMSMapView!
    
    @IBOutlet weak var findButton: UIBarButtonItem!
    
    let baseUrl = "https://maps.googleapis.com/maps/api/geocode/json?"
    let baseUrlRoute = "https://maps.googleapis.com/maps/api/directions/json?"
    
    let apikey = "AIzaSyBixFth5Vz_Gn27L46ZbsnfYS_SlZY_gDI"
    var locationManager:CLLocationManager = CLLocationManager()
    
    var currentLocation:CLLocationCoordinate2D?
    
    var indicator = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "bg4"), for: .default)
        
        let camera = GMSCameraPosition.camera(withLatitude:-33.872889, longitude:151.206244, zoom: 6.0)
            
        self.nearbyCinemaMap.camera = camera
        
        locationManager.delegate = self
        self.nearbyCinemaMap.delegate = self
        
        let authorisationStatus = CLLocationManager.authorizationStatus()
        
        if authorisationStatus != .authorizedWhenInUse{
                   
                   
                locationManager.requestWhenInUseAuthorization()

               }
        
     
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
         super.viewWillDisappear(animated)
         locationManager.stopUpdatingLocation()
        
     }
    
    func locationManager(_ manage:CLLocationManager,didUpdateLocations locations:[CLLocation]){
          if let location = locations.last{
              currentLocation = location.coordinate
          }
      }
    
    func locationManager(_ manager:CLLocationManager,didChangeAuthorization status:CLAuthorizationStatus){
        if status == .authorizedWhenInUse{

        }
    }
    
    
    @IBAction func findNearbyCinema(_ sender: Any) {
        
        if let currentLocation = currentLocation{
            let camera = GMSCameraPosition.camera(withLatitude:currentLocation.latitude, longitude: currentLocation.longitude, zoom: 14.0)
            self.nearbyCinemaMap.camera = camera
            self.showMarker(position: self.nearbyCinemaMap.camera.target, name: "Current Location", information: "Current Location")
//            let position = CLLocationCoordinate2D(latitude: -33.870878, longitude: 151.206224)
//            self.showMarker(position: position, name: "Test", city: "Test")
            
                let centrePoint = "\(currentLocation.latitude);\(currentLocation.longitude)"
//            print(centrePoint)
            self.requestNearbyCinema(centre: centrePoint)
            
        }
        else{
            
            let alertController = UIAlertController(title: "Location Not Found", message: "The location has not yet been detemined", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            present(alertController,animated: true,completion: nil)
        }
        
    }
    


    func showMarker(position:CLLocationCoordinate2D,name:String,information:String){
        
        let marker = GMSMarker()
        marker.position = position
        marker.title = name
        marker.snippet = information
        marker.map = nearbyCinemaMap
        
    }
    
    func requestNearbyCinema(centre:String)
    {
        
    let GEOLOCATION = centre
   //URL构建器
   var searchURLComponentrs = URLComponents()
   searchURLComponentrs.scheme = "https"
   searchURLComponentrs.host = "api-gate2.movieglu.com"
   searchURLComponentrs.path = "/cinemasNearby/"
       
   // alternate new api
   let headers2 = ["client":"    STUD_154","x-api-key":"010t1k7dg58xPGY98RwunS659q9n7C03SBIXKXwd", "Authorization":"Basic U1RVRF8xNTQ6ZzFKa0RmY1hNb0k0","territory":"AU","api-version":"v200","geolocation":GEOLOCATION,"device-datetime":"2020-11-19T11:49:25.865Z"]
        
   let headers = ["client":"IT_0","x-api-key":"lzOlyufYrJ2puY0gIxEcy8QbS4gHCcZP6u3i6NUy", "Authorization":"Basic SVRfMDpnNmlEa3hzcE0xZlY=","territory":"AU","api-version":"v200","geolocation":GEOLOCATION,"device-datetime":"2020-11-19T11:49:25.865Z"]
       
   searchURLComponentrs.queryItems = [URLQueryItem(name: "n", value: "5")]
       
       //print(searchURLComponentrs.url)
   var request = URLRequest(url: (searchURLComponentrs.url)!)
       request.httpMethod = "GET"
       for (key, value) in headers2 {
           request.setValue(value, forHTTPHeaderField: key)
       }

   let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
           // Regardless of response end the loading icon from the main thread

       if let error = error { print(error)
           return
       }
       do {
            //print(data)
           let decoder = JSONDecoder()
           let volumeData = try decoder.decode(VolumeData.self, from: data!)
           if let cinemas = volumeData.cinemas {

//               self.newCinemas.append(contentsOf: cinemas)
            
            for cinema in cinemas{
                
                let cinemaName = cinema.name
                //print(cinemaName)
                let latitude = Double(cinema.lat!)
                let longitude = Double(cinema.lng!)
                
                if let cinemaId = cinema.cinema_id,
                   let cinemaCity = cinema.city,
                   let cinemaAddress = cinema.address {
                    
                    let information = "\(cinemaId),\(cinemaCity),\(cinemaAddress)"
                    print(information)
                    let position = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                    
                    DispatchQueue.main.async {
     //                   self.tableView.reloadData()
                        self.showMarker(position: position, name: cinemaName!, information: information)
                        
                    }
                }
                   
                
            }

           }
       } catch let err {
           print(err) }
       }
       task.resume()
    }
    

}

extension NearbyCinemaViewController:GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        if(marker.title == "Current Location"){
            let alertController = UIAlertController(title: "You Current Location", message: "Please tap other cinema marker to go to the cinema detail", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            present(alertController,animated: true,completion: nil)
            
        }
        else{
            
            //print(marker.title)
            let cinemaName = marker.title
            let latitude = "\(marker.position.latitude)"
            let longitude = "\(marker.position.longitude)"
            //print(marker.snippet)
            if let informationArray = marker.snippet?.components(separatedBy: ","){
                let cinemaId = informationArray[0]
                let cinemaCity = informationArray[1]
                let cinemaAddress = informationArray[2]
                let cinema = Cinema(id: "AA", cinema_id: cinemaId, name: cinemaName!, address: cinemaAddress, city: cinemaCity, lat: latitude, lng: longitude)
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                let cinemaDetailViewController = storyboard.instantiateViewController(withIdentifier: "cinemaDetail") as! CinemaDetailViewController
                cinemaDetailViewController.selectedCinema = cinema
                navigationController?.pushViewController(cinemaDetailViewController, animated: true)
                
            }
            
        }

        return true
    }
}
