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
            startStopBtn.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            startStopBtn.setTitle("Start", for: .normal)
            locationManager.stopUpdatingLocation()
            self.mapView.removeAnnotation(startAnnotaion)
        }
    }
    
    
    
    
}

extension NewRideViewController: CLLocationManagerDelegate{
//    func currentAddres(_ coordinate:CLLocationCoordinate2D) -> Void
//        {
//            geoCoder.reverseGeocodeCoordinate(coordinate) { (response, error) in
//
//                if error == nil
//                {
//                    if response != nil
//                    {
//                        let address:GMSAddress! = response!.firstResult()
//
//                        if address != nil
//                        {
//                            let addressArray:NSArray! = address.lines! as NSArray
//
//                            if addressArray.count > 1
//                            {
//                                var convertAddress:AnyObject! = addressArray.object(at: 0) as AnyObject!
//                                let space = ","
//                                let convertAddress1:AnyObject! = addressArray.object(at: 1) as AnyObject!
//                                let country:AnyObject! = address.country as AnyObject!
//
//                                convertAddress = (((convertAddress.appending(space) + (convertAddress1 as! String)) + space) + (country as! String)) as AnyObject
//
//                                self.currentlocationlbl.text = "\(convertAddress!)".appending(".")
//                            }
//                            else
//                            {
//                                self.currentlocationlbl.text = "Fetching current location failure!!!!"
//                            }
//                        }
//                    }
//                }
//            }
//    }
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
                
                let address = CLGeocoder.init()
                    address.reverseGeocodeLocation(location) { (places, error) in
                        if error == nil{
                            if let place = places{
                                print(place)
                            }
                        }
                    }
                
                listOfData?.rideCoordinates = []
                listOfData?.rideDetails = []
            
            }
        }
        else{
            //currentCenter
            if let location = locations.last{
                let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                print(location.speed)
                
                
                
                
                
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
