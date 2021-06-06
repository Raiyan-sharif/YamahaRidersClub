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
import GoogleMaps
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
    var previousCenter:CLLocationCoordinate2D!
    let startAnnotaion = MKPointAnnotation()
//    var listOfData:MainNewRideMode?
    var rideCode:[RideCoordinate] = []
    var rideDet:[RideDetail] = []
    var startTime: String = ""
    var currentTime: String = ""
    var endtime: String = ""
    var startAddress:String = "UnTracked"
    var endAddress:String = "UnTracked"
    var userDefaults = UserDefaults.standard
    let googleApiKey = "AIzaSyClQ4Umev_hqXM-fsq1tsxKBMm_u03Jlso"
    var finalDistance:CLLocationDegrees = 0.0
    var finalAvgSpeed:CLLocationDegrees = 0.0
    var finalMaxSpeed:CLLocationDegrees = 0.0
    var t=false

    @IBOutlet weak var startStopBtn: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var descriptionLabel: UILabel!
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
             overrideUserInterfaceStyle = .light
         }
        title = "New Ride"
        GMSServices.provideAPIKey(googleApiKey)
//        if(!AppSettingVariable.isNewRideOn){
            if (CLLocationManager.locationServicesEnabled())
                    {
                        locationManager = CLLocationManager()
                        locationManager.delegate = self
                        locationManager.desiredAccuracy = kCLLocationAccuracyBest
                        locationManager.requestWhenInUseAuthorization()
                        locationManager.startUpdatingLocation()
                locationManager.allowsBackgroundLocationUpdates = true
                locationManager.showsBackgroundLocationIndicator = true
                
                
//            }
        }
        
        mapView.delegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "<Back", style: .plain, target: self, action: #selector(NewRideViewController.backButtonTapped))
        
        navigationItem.leftBarButtonItem?.isEnabled = true
        print("viewDidLoad")
        
        
    }
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        
      // 1
      let geocoder = GMSGeocoder()
    
        
      // 2
      geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
        guard let address = response?.firstResult(), let lines = address.lines else {
          return
        }
          
        if(!self.showMapRoute){
            self.startAddress = lines.joined(separator: "\n")
        }
        else{
            self.endAddress = lines.joined(separator:"\n")
        }
        
         print(lines.joined(separator: "\n"))
          
        

        
      }
    }
    //Using Web
    //https://maps.googleapis.com/maps/api/geocode/json?latlng=23.8010060654051,90.37684489470378&key=AIzaSyCooDbojEIjQ0YA3jp0YD2cP1x3W-6Aves
    

    
    @IBAction func newRideTapped(_ sender: Any) {
        var lastLocation = locationManager.location
        startAnnotaion.title = "Start Location "
        print(showMapRoute)
        if(!showMapRoute){
//            listOfData?.rideCoordinates = []
//            listOfData?.rideDetails = []
            self.reverseGeocodeCoordinate(startCenter)
            rideDet = []
            rideCode = []
            locationManager.startUpdatingLocation()
            startAnnotaion.coordinate = startCenter
            self.mapView.addAnnotation(startAnnotaion)
            
            startStopBtn.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            startStopBtn.setTitle("Stop", for: .normal)
            AppSettingVariable.isNewRideOn = true
            
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
            showMapRoute = true
            
            
            
        }
        else{
            self.reverseGeocodeCoordinate(currentCenter)
            
            //Distance Calculation
            let coordinate0 = CLLocation(latitude: startCenter.latitude, longitude: startCenter.longitude)
            let coordinate1 = CLLocation(latitude: currentCenter.latitude, longitude: currentCenter.longitude)
            finalDistance = coordinate0.distance(from: coordinate1)
            
            let date = Date()
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
            endtime = format.string(from: date)
            let startDate = format.date(from: startTime)!
            let endDate = format.date(from: endtime)!
            let differenceInSeconds = endDate.timeIntervalSince(startDate)
            if(differenceInSeconds < 1.0){
                finalAvgSpeed = finalDistance/1
            }
            else{
                finalAvgSpeed = finalDistance/differenceInSeconds
            }
            //Avg Calculation
            
//            let differenceInSeconds = startTime.timeIntervalSince(endtime)
            
            dataViaAlamorfire(lastLocation: lastLocation)
        }
    }
    
  
    
    @objc func backButtonTapped() {
//        self.navigationController?.popViewController(animated: true)
        if (AppSettingVariable.isNewRideOn){
            print("Ride on going")
            let alertVC = UIAlertController(title: "Warning", message: "Do you want stop the ride now? To Get Back to main menu stop the ride", preferredStyle: .alert)
            

            
            
            let cancelAction = UIAlertAction(title: "Ok", style: .default, handler: {
                (alert) -> Void in
                
                
                self.dismiss(animated: true, completion: nil)
                print("Ok")
            })
            cancelAction.setValue(UIColor.white, forKey: "titleTextColor")
            
            
            alertVC.addAction(cancelAction)
            present(alertVC, animated: true, completion: nil)
            
//            if let homeVC = AppSettingVariable.homeVc{
//
//                self.navigationController?.pushViewController(homeVC, animated: true)
//
//                }
//            else{
//                let vc2 = storyboard?.instantiateViewController(withIdentifier: "HomeViewController" ) as! HomeViewController
//                AppSettingVariable.homeVc = vc2
//                self.navigationController?.pushViewController(vc2, animated: true)
//            }
        }
        else{
//            if let homeVC = AppSettingVariable.homeVc{
//                homeVC.dismiss(animated: false) {
                    self.navigationController?.popViewController(animated: true)
//                }
//            }
            
            
        }
        
        print("Back Button pressed")
    }
    
    func dataViaAlamorfire(lastLocation: CLLocation?) {
        showMapRoute = false
        
        
      
        
        
        var mobileNo = ""
        if userDefaults.string(forKey: "mobileno") != nil{
            mobileNo = userDefaults.string(forKey: "mobileno")!
        }
        rideDet.append(RideDetail(mobile: mobileNo, startaddress: "\(startAddress)", endaddress: "\(endAddress)", distance: finalDistance, avgspeed: finalAvgSpeed, maxspeed: finalMaxSpeed, startTime: startTime, endTime: endtime, endbyuser: 1))
        print(mobileNo)
        print(startAddress)
        print(endAddress)
        print(startTime)
        print(endtime)
        
        startStopBtn.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        startStopBtn.setTitle("Start", for: .normal)
        AppSettingVariable.isNewRideOn = false
        locationManager.stopUpdatingLocation()
        self.mapView.removeAnnotation(startAnnotaion)
//            let dic = ["data" : ["rideDetails": rideDet,"rideCoordinates": rideCode]]
        let dataObj = NewRideModel(rideDetails: rideDet, rideCoordinates: rideCode)
        let finalObj = MainNewRideModel(data: dataObj)

        
        
//        let jsonData2 = json.data(using: .utf8, allowLossyConversion: false)!
//        print("json data \(jsonData2)")
        print("came")
        
        guard let dic2 = dataObj.dictionary else { return}
        print("No \(dic2)")
//            guard let dic3 = rideCode.dictionary else { return}
//            print("No \(dic3)")
        let encoder = JSONEncoder()
        let encodedArrayRideDet = try! encoder.encode(rideDet)
        let encodedArrayRidecode = try! encoder.encode(rideCode)
        
        var dataStringDet: String { return String(data: encodedArrayRideDet, encoding: .utf8)! }
        var dataStringCode: String { return String(data: encodedArrayRidecode, encoding: .utf8)! }
//        let parameters: [String: Any] = ["data": ["rideDetails":dataStringDet, "rideCoordinates": dataStringCode]]
        let parameters: [String: Any] =  ["rideDetails":dataStringDet, "rideCoordinates": dataStringCode]
        
        print("parameter : \(parameters)")
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(dataObj)
        let json = String(data: jsonData, encoding: String.Encoding.utf8)!
        print("json \(json)")
        var params = ["data": json] as [String: Any]
        
//        let encoder = URLEncodedFormParameterEncoder(encoder: URLEncodedFormEncoder(arrayEncoding: .noBrackets))
//        URLEncodedFormParameterEncoder.default JSONEncoding.default encoding: JSONEncoding.default
        //encoder: JSONParameterEncoder.default,
//            , headers: [
//                "Content-Type": "application/x-www-form-urlencoded"
//            ]
        AF.request("http://apps.acibd.com/apps/yrc/syncdata/bikeridesync",method: .post,parameters: ["data":json]).response { response in
            debugPrint(response.debugDescription)
            
//            if let res = response.value{
//                if let finalData = res{
//                    let swiftyJsonVar = JSON(finalData)
//                    print(swiftyJsonVar)
//                    print("Here")
//
//
//                }
//
//            }
            let result = response.result
                switch result{
                    case .success(let value):
                        if let res = response.value{
                            if let finalData = res{
                                let swiftyJsonVar = JSON(finalData)
                                print(swiftyJsonVar)
                                print("Here \(value)")

                                self.dismiss(animated: false, completion:{
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyRideViewController" ) as! MyRideViewController
                                    self.navigationController?.pushViewController(vc,
                                    animated: true)
                                })
                            }
                            
                        }
                case .failure(let errno):
                    print(errno)
                }
            
        }

    }
    
    
    
}

extension NewRideViewController: CLLocationManagerDelegate{

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !showMapRoute {
            
            if let location = locations.last{
                let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                
                print("R \(location.coordinate)")
                reverseGeocodeCoordinate(center)
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                startCenter = center
                currentCenter = center
                previousCenter = center
                self.mapView.setRegion(region, animated: true)
                
                let date = Date()
                let format = DateFormatter()
                format.dateFormat = "yyyy-MM-dd HH:mm:ss"
                startTime = format.string(from: date)
                currentTime = startTime
                print(startTime)
//                let geoCoder = CLGeocoder()
//                startAddress = ""
//                geoCoder.reverseGeocodeLocation(location, completionHandler:
//                {
//                    placemarks, error -> Void in
//
//                    // Place details
//                    guard let placeMark = placemarks?.first else { return }
//
//                    // Location name
//                    if let locationName = placeMark.location {
////                        print("Name \(locationName)")
//                        self.startAddress = "\(locationName)"
//                    }
//                    else{
//                        self.startAddress = "Unknown"
//                    }
//                })
//                print(self.startAddress)
                
            
                locationManager.stopUpdatingLocation()
            
            }
        }
        else{
            //currentCenter
            if let location = locations.last{
                let xLat = location.coordinate.latitude
                let xLon = location.coordinate.longitude
                
//                let rLat = Double(round(100000000*xLat)/100000000)
//                let rLon = Double(round(100000000*xLon)/100000000)
                let center = CLLocationCoordinate2D(latitude: xLat, longitude: xLon)
                print(location.speed)
                
                
                print("Is IT\(self.startAddress)")
                
                
                let date2 = NSDate() // current date
                let unixtime = date2.timeIntervalSince1970
                
                print("Cordinate = \(location.coordinate), timestamp = \(unixtime)")
                var d = RideCoordinate(latitude: "\(location.coordinate.latitude)", longitude: "\(location.coordinate.longitude)", time:"\(unixtime)")
                rideCode.append(RideCoordinate(latitude: "\(location.coordinate.latitude)", longitude: "\(location.coordinate.longitude)", time:"\(unixtime)"))
                print(d)
                
                
                
                
                
                
            
                
                print(rideCode)
//                listOfData?.rideCoordinates.append(d)
                
                
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                currentCenter = center
                self.mapView.setRegion(region, animated: true)
                
                let date = Date()
                let format = DateFormatter()
                format.dateFormat = "yyyy-MM-dd HH:mm:ss"
                endtime = format.string(from: date)
    //            let differenceInSeconds = startTime.timeIntervalSince(endtime)
                let startDate = format.date(from: currentTime)!
                let endDate = format.date(from: endtime)!
                
                let differenceInSeconds = endDate.timeIntervalSince(startDate)
                let coordinate0 = CLLocation(latitude: previousCenter.latitude, longitude: previousCenter.longitude)
                let coordinate1 = CLLocation(latitude: currentCenter.latitude, longitude: currentCenter.longitude)
                let tempDistance = coordinate0.distance(from: coordinate1)
                print("Time Diff is \(differenceInSeconds)")
                print("Distance : \(tempDistance)")
                if(differenceInSeconds > 5.0){
                    print("5 Second")
                    let tempSpeed = tempDistance/differenceInSeconds
                    print("Speed: \(tempSpeed)")
                    previousCenter = currentCenter
                    currentTime = endtime
                    if(tempSpeed > finalMaxSpeed){
                        finalMaxSpeed = tempSpeed
                    }
                    
                }
            
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

extension Encodable {
  var dictionary: [String: Any]? {
    guard let data = try? JSONEncoder().encode(self) else { return nil }
    return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
  }
}
extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
