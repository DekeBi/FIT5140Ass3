
//  CinemaDetailViewController.swift
//  FIT5140Ass3
//
//  Created by user174132 on 11/2/20.
//

import UIKit
import GoogleMaps

class CinemaDetailViewController: UIViewController,CLLocationManagerDelegate {
    
    var selectedCinema: Cinema?
    let baseUrl = "https://maps.googleapis.com/maps/api/geocode/json?"
    let baseUrlRoute = "https://maps.googleapis.com/maps/api/directions/json?"
    
    let apikey = "AIzaSyBixFth5Vz_Gn27L46ZbsnfYS_SlZY_gDI"

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var cinemaIdLabel: UILabel!
    @IBOutlet weak var cinemaNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var currentLocationButton: UIButton!
    var locationManager:CLLocationManager = CLLocationManager()
    
    var currentLocation:CLLocationCoordinate2D?
    
    
    var indicator = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cinemaIdLabel.text = "\(selectedCinema!.cinema_id!)"
        cinemaNameLabel.text = selectedCinema?.name
        addressLabel.text = selectedCinema?.address
        phoneLabel.text = selectedCinema?.city
       
        locationManager.delegate = self
        
        //Cinema Latitude and Longitude from String to Double
        if let tempLat = selectedCinema?.lat,let tempLong = selectedCinema?.lng{
            
            let lat = Double(tempLat)
            let long = Double(tempLong)
            
            let camera = GMSCameraPosition.camera(withLatitude:lat!, longitude:long!, zoom: 15.0)
                
            self.mapView.camera = camera
            
            if let cinemaName = selectedCinema?.name,
               let cinemaCity = selectedCinema?.city{
                
                self.showMarker(position: self.mapView.camera.target, name: cinemaName, city: cinemaCity)
            }
                
        }
//        self.drawCinemaOnMap(address: selectedCinema?.address ?? "675 Glenferrie Road")
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
            currentLocationButton.isHidden = false
        }
    }
    
    
    @IBAction func useCurrentLocation(_ sender: Any) {
        let authorisationStatus = CLLocationManager.authorizationStatus()
        
        if authorisationStatus != .authorizedWhenInUse{
                   
                currentLocationButton.isHidden = true
                   
                locationManager.requestWhenInUseAuthorization()

               }

    }
    
    
    @IBAction func Routing(_ sender: Any) {
        if let currentLocation = currentLocation{
            let source = "\(currentLocation.latitude),\(currentLocation.longitude)"
            var destination:String
            destination = ""
            if let tempLat = selectedCinema?.lat,let tempLong = selectedCinema?.lng{
                destination = "\(tempLat),\(tempLong)"
            }
            
            self.drawRouteOnMap(source: source, destination: destination)
            let camera = GMSCameraPosition.camera(withLatitude:currentLocation.latitude, longitude: currentLocation.longitude, zoom: 16.0)
                
            self.mapView.camera = camera
                
            self.showMarker(position: self.mapView.camera.target, name: "My Home", city: "Current Location")
            
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
        marker.map = mapView
        
    }
    
    func drawRouteOnMap(source:String,destination:String){
        
        let url = "\(baseUrlRoute)origin=\(source)&destination=\(destination)&mode=driving&key=\(apikey)"
        let jsonURL =
            URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        
        let task = URLSession.shared.dataTask(with:jsonURL!) {
            (data,response,error) in
            
            if let error = error{
                print(error)
                return
            }

            do{
                print(data)
                
                let decoder = JSONDecoder()
                let directionData = try decoder.decode(DirectionVolumeData.self, from: data!)
         
                if directionData.status == "OK"{
                    
                    if let tempRoute = directionData.routes{
                        
                        for route in tempRoute{
                            
                            let point = route.point

                            DispatchQueue.main.async {
                                let path = GMSPath.init(fromEncodedPath: point ?? "")
                                let polyline = GMSPolyline.init(path: path)
                                polyline.strokeColor = .systemRed
                                polyline.strokeWidth = 6
                                polyline.map = self.mapView
                                
                            }

                        }

                    }
                }

            }catch let err{
                print(err)
            }
        }
        task.resume()
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
//                            self.showMarker(position: self.mapView.camera.target)
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
