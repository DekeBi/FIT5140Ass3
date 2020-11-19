//
//  NearbyCinemaViewController.swift
//  FIT5140Ass3
//
//  Created by user174132 on 11/19/20.
//

import UIKit
import GoogleMaps

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
        locationManager.delegate = self
        
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
            let camera = GMSCameraPosition.camera(withLatitude:currentLocation.latitude, longitude: currentLocation.longitude, zoom: 16.0)
            self.nearbyCinemaMap.camera = camera
            self.showMarker(position: self.nearbyCinemaMap.camera.target, name: "Current Location", city: "Current Location")
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
    

    func showMarker(position:CLLocationCoordinate2D,name:String,city:String){
        
        let marker = GMSMarker()
        marker.position = position
        marker.title = name
        marker.snippet = city
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
       
   let headers = ["client":"PERS_77","x-api-key":"j8WskErfCq348pPp6bNd7auiIsaE3L3d3lOHOYjA", "Authorization":"Basic UEVSU183N19YWDpXaFVuRTZpVnlQSWw=","territory":"XX","api-version":"v200","geolocation":GEOLOCATION,"device-datetime":"2020-11-04T07:08:05.644Z"]
   
   
   // new api credential
   let headers2 = ["client":"IT_0","x-api-key":"lzOlyufYrJ2puY0gIxEcy8QbS4gHCcZP6u3i6NUy", "Authorization":"Basic SVRfMDpnNmlEa3hzcE0xZlY=","territory":"AU","api-version":"v200","geolocation":GEOLOCATION,"device-datetime":"2020-11-19T11:49:25.865Z"]
       
   searchURLComponentrs.queryItems = [URLQueryItem(name: "n", value: "5")]
       
       print(searchURLComponentrs.url)
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
            print(data)
           let decoder = JSONDecoder()
           let volumeData = try decoder.decode(VolumeData.self, from: data!)
           if let cinemas = volumeData.cinemas {

//               self.newCinemas.append(contentsOf: cinemas)
            
            for cinema in cinemas{
                
                let cinemaName = cinema.name
                print(cinemaName)
                let cinemaAddress = cinema.address
                let latitude = Double(cinema.lat!)
                let longitude = Double(cinema.lng!)
                let position = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                
                DispatchQueue.main.async {
 //                   self.tableView.reloadData()
                    self.showMarker(position: position, name: cinemaName!, city: cinemaAddress!)
                    
                }
            }

           }
       } catch let err {
           print(err) }
       }
       task.resume()
    }
    

}
