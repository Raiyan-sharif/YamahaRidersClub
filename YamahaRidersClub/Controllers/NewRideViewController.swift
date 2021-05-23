//
//  NewRideViewController.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 4/5/21.
//

import UIKit
import CoreLocation
import MapKit
import AVFoundation
import Alamofire
import SwiftyJSON
//import GooglePlaces
//CLLocationManagerDelegate
class NewRideViewController: UIViewController{
    var steps: [MKRoute.Step] = []
    var stepCounter = 0
    var route:MKRoute?
    var showMapRoute = false
    var showNavigationStarted = false
    var locationDistance:Double = 500
    var speedSynthesizer = AVSpeechSynthesizer()
    var startCenter:CLLocationCoordinate2D!
    var currentCenter:CLLocationCoordinate2D!
    let startAnnotaion = MKPointAnnotation()
    var listOfData:NewRideModel?
    var startTime: String = ""
    var startAddress:String = ""
    var userDefaults = UserDefaults.standard

    @IBOutlet weak var startStopBtn: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var descriptionLabel: UILabel!
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
             overrideUserInterfaceStyle = .light
         }
        if (CLLocationManager.locationServicesEnabled())
                {
                    locationManager = CLLocationManager()
                    locationManager.delegate = self
                    locationManager.desiredAccuracy = kCLLocationAccuracyBest
                    locationManager.requestWhenInUseAuthorization()
                    locationManager.startUpdatingLocation()
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.showsBackgroundLocationIndicator = true
            
            
        }
        mapView.delegate = self
        
        
    }
    
    @IBAction func newRideTapped(_ sender: Any) {
        var lastLocation = locationManager.location
        startAnnotaion.title = "Start Location "
        print(showMapRoute)
        if(!showMapRoute){
            locationManager.startUpdatingLocation()
            startAnnotaion.coordinate = startCenter
            self.mapView.addAnnotation(startAnnotaion)
            showMapRoute = true
            startStopBtn.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            startStopBtn.setTitle("Stop", for: .normal)
            
//            let geoCoder = CLGeocoder()
//            geoCoder.geocodeAddressString("Mirpur 13") { (placemarks, error) in
//                if let error = error{
//                    print(error.localizedDescription)
//                    return
//                }
//            }
            
            let sourcePlaceMark = MKPlacemark(coordinate: startCenter)
            let destinationPlaceMark = MKPlacemark(coordinate: currentCenter)
            let sourceItem = MKMapItem(placemark: sourcePlaceMark)
            let destinationItem = MKMapItem(placemark: destinationPlaceMark)
            let requestRoute = MKDirections.Request()
            requestRoute.source = sourceItem
            requestRoute.destination = destinationItem
            requestRoute.transportType = .automobile
            let directions = MKDirections(request: requestRoute)
            directions.calculate { (response, error) in
                if let error = error{
                    print(error.localizedDescription)
                    return
                }
                guard let response = response, let routes = response.routes.first else {return}
                self.route = routes
                
                self.mapView.addOverlay(routes.polyline)
                self.mapView.setVisibleMapRect(routes.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0), animated: true)
            
            }
            
            
            
        }
        else{
            showMapRoute = false
            let date = Date()
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let endtime = format.string(from: date)
            
            
            
            let geoCoder = CLGeocoder()
            var endAddress = startAddress
            geoCoder.reverseGeocodeLocation(lastLocation!, completionHandler:
            {
                placemarks, error -> Void in

                // Place details
                guard let placeMark = placemarks?.last else { return }

                // Location name
                if let locationName = placeMark.location {
//                        print("Name \(locationName)")
                    endAddress = "\(locationName)"
                }
                // Street address
                if let street = placeMark.thoroughfare {
//                        print("Street \(street)")
                    endAddress += "\(street)"
                }
                // City
                if let city = placeMark.subAdministrativeArea {
//                        print("City \(city)")
                    endAddress += "\(city)"
                }
                // Zip code
                if let zip = placeMark.isoCountryCode {
//                        print("Zip \(zip)")
                    endAddress += "\(zip)"
                }
                // Country
                if let country = placeMark.country {
//                        print("Country \(country)")
                    endAddress += "\(country)"
                    
                }
            })
            var mobileNo = ""
            if userDefaults.string(forKey: "mobileno") != nil{
                mobileNo = userDefaults.string(forKey: "mobileno")!
            }
            
            listOfData?.rideDetails.append(RideDetail(mobile: mobileNo, startaddress: startAddress, endaddress: endAddress, distance: 0.1, avgspeed: 0.1, maxspeed: 1.1, startTime: startTime, endTime: endtime, endbyuser: 1))
            print(mobileNo)
            print(startAddress)
            print(endAddress)
            print(startTime)
            print(endtime)
            
            startStopBtn.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            startStopBtn.setTitle("Start", for: .normal)
            locationManager.stopUpdatingLocation()
            self.mapView.removeAnnotation(startAnnotaion)
            AF.request("https://apps.acibd.com/apps/yrc/syncdata/bikeridesync",method: .post,parameters: listOfData, encoder: URLEncodedFormParameterEncoder(destination: .httpBody), headers: [
                "Content-Type": "application/json"
            ]).response { response in
    //            debugPrint(response.debugDescription)
                if let res = response.value{
                    if let finalData = res{
                        let swiftyJsonVar = JSON(finalData)
                        print(swiftyJsonVar.error)
                        print("Here")
//                        if(swiftyJsonVar["msgtype"]=="success"){
//                           
//                            self.fbProfileLink.text = newLink
//                            UserInfo.facebookIDLink = newLink
//                        }
                       
                    }
                    
                }
                
            }
        }
    }
    
    
    
    
}

extension NewRideViewController: CLLocationManagerDelegate{

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !showMapRoute {
            if let location = locations.last{
                let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                
                print("\(location.coordinate)")
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                startCenter = center
                currentCenter = center
                self.mapView.setRegion(region, animated: true)
                
                let date = Date()
                let format = DateFormatter()
                format.dateFormat = "yyyy-MM-dd HH:mm:ss"
                startTime = format.string(from: date)
                print(startTime)
                let geoCoder = CLGeocoder()
                startAddress = ""
                geoCoder.reverseGeocodeLocation(location, completionHandler:
                {
                    placemarks, error -> Void in

                    // Place details
                    guard let placeMark = placemarks?.first else { return }

                    // Location name
                    if let locationName = placeMark.location {
//                        print("Name \(locationName)")
                        self.startAddress = "\(locationName)"
                    }
                    // Street address
                    if let street = placeMark.thoroughfare {
//                        print("Street \(street)")
                        self.startAddress += "\(street)"
                    }
                    // City
                    if let city = placeMark.subAdministrativeArea {
//                        print("City \(city)")
                        self.startAddress += "\(city)"
                    }
                    // Zip code
                    if let zip = placeMark.isoCountryCode {
//                        print("Zip \(zip)")
                        self.startAddress += "\(zip)"
                    }
                    // Country
                    if let country = placeMark.country {
//                        print("Country \(country)")
                        self.startAddress += "\(country)"
                        
                    }
                })
                print(self.startAddress)
                
                
                
                listOfData?.rideCoordinates = []
                listOfData?.rideDetails = []
                locationManager.stopUpdatingLocation()
            
            }
        }
        else{
            //currentCenter
            if let location = locations.last{
                let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                print(location.speed)
                
                
                print("Is IT\(self.startAddress)")
                
                
                let date2 = NSDate() // current date
                let unixtime = date2.timeIntervalSince1970
                
                print("Cordinate = \(location.coordinate), timestamp = \(unixtime)")
                listOfData?.rideCoordinates.append(RideCoordinate(latitude: "\(location.coordinate.latitude)", longitude: "\(location.coordinate.longitude)", time:"\(unixtime)"))
                
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                currentCenter = center
                self.mapView.setRegion(region, animated: true)
            
            }
        }
    }
}

extension NewRideViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .systemBlue
        return renderer
    }
}
