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
//    var listOfData:MainNewRideMode?
    var rideCode:[RideCoordinate] = []
    var rideDet:[RideDetail] = []
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
//            listOfData?.rideCoordinates = []
//            listOfData?.rideDetails = []
            rideDet = []
            rideCode = []
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
            dataViaAlamorfire(lastLocation: lastLocation)
//            showMapRoute = false
//            let date = Date()
//            let format = DateFormatter()
//            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
//            let endtime = format.string(from: date)
//
//
//
//            let geoCoder = CLGeocoder()
//            var endAddress = startAddress
//            geoCoder.reverseGeocodeLocation(lastLocation!, completionHandler:
//            {
//                placemarks, error -> Void in
//
//                // Place details
//                guard let placeMark = placemarks?.last else { return }
//
//                // Location name
//                if let locationName = placeMark.location {
//    //                        print("Name \(locationName)")
//                    endAddress = "\(locationName)"
//                }
//                else{
//                    endAddress = "Unknown"
//                }
//            })
//            var mobileNo = ""
//            if userDefaults.string(forKey: "mobileno") != nil{
//                mobileNo = userDefaults.string(forKey: "mobileno")!
//            }
//            rideDet.append(RideDetail(mobile: mobileNo, startaddress: startAddress, endaddress: endAddress, distance: 0.1, avgspeed: 0.1, maxspeed: 1.1, startTime: startTime, endTime: endtime, endbyuser: 1))
//            print(mobileNo)
//            print(startAddress)
//            print(endAddress)
//            print(startTime)
//            print(endtime)
//
//            startStopBtn.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
//            startStopBtn.setTitle("Start", for: .normal)
//            locationManager.stopUpdatingLocation()
//            self.mapView.removeAnnotation(startAnnotaion)
//    //            let dic = ["data" : ["rideDetails": rideDet,"rideCoordinates": rideCode]]
//            let dataObj = NewRideModel(rideDetails: rideDet, rideCoordinates: rideCode)
//            let finalObj = MainNewRideModel(data: dataObj)
//
//
//            let url = URL(string: "http://apps.acibd.com/apps/yrc/syncdata/bikeridesync")!
//            var request = URLRequest(url: url)
//            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//            request.httpMethod = "POST"
//            let parameters: [String: Any] = ["data":["rideCoordinates":[["time":"1621849394.64643","longitude":"90.3770315654824","latitude":"23.80106560200154"],["time":"1621849394.735499","longitude":"90.37703069162616","latitude":"23.801069498485568"],["time":"1621849394.745178","longitude":"90.37703040529809","latitude":"23.801070775110638"],["time":"1621849399.5907822","longitude":"90.37699732648032","latitude":"23.801049898675647"],["time":"1621849405.6002269","longitude":"90.37689950321385","latitude":"23.8010054402637"]],"rideDetails":[["mobile":"01755939896","startaddress":"<+23.80099738,+90.37702229>  100.00m (speed -1.00 mps  course -1.00) @ 52421, 3:43:13 PM Bangladesh Standard Time","distance":0.10000000000000001,"endTime":"2021-05-24 15:43:27","endaddress":"<+23.80099738,+90.37702229> 100.00m (speed -1.00 mps course -1.00) @ 52421, 3:43:13 PM Bangladesh Standard Time","avgspeed":0.10000000000000001,"maxspeed":1.1000000000000001,"endbyuser":1,"startTime":"2021-05-24 15:43:12"]]]]
//            request.httpBody = parameters.percentEncoded()
//
//            let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                guard let data = data,
//                    let response = response as? HTTPURLResponse,
//                    error == nil else {                                              // check for fundamental networking error
//                    print("error", error ?? "Unknown error")
//                    return
//                }
//
//                guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
//                    print("statusCode should be 2xx, but is \(response.statusCode)")
//                    print("response = \(response)")
//                    return
//                }
//
//                let responseString = String(data: data, encoding: .utf8)
//                print("responseString = \(responseString)")
//            }
//
//            task.resume()
            
            
        }
    }
    func dataViaAlamorfire(lastLocation: CLLocation?) {
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
            else{
                endAddress = "Unknown"
            }
        })
        var mobileNo = ""
        if userDefaults.string(forKey: "mobileno") != nil{
            mobileNo = userDefaults.string(forKey: "mobileno")!
        }
        rideDet.append(RideDetail(mobile: mobileNo, startaddress: "datatest1", endaddress: "datatest1", distance: 0.1, avgspeed: 0.1, maxspeed: 1.1, startTime: startTime, endTime: endtime, endbyuser: 1))
        print(mobileNo)
        print(startAddress)
        print(endAddress)
        print(startTime)
        print(endtime)
        
        startStopBtn.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        startStopBtn.setTitle("Start", for: .normal)
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

                                self.dismiss(animated: false, completion:{ self.navigationController?.popToRootViewController(animated: true)
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
                    else{
                        self.startAddress = "Unknown"
                    }
                })
                print(self.startAddress)
                
            
                locationManager.stopUpdatingLocation()
            
            }
        }
        else{
            //currentCenter
            if let location = locations.last{
                let xLat = location.coordinate.latitude
                let xLon = location.coordinate.longitude
                
                let rLat = Double(round(100000000*xLat)/100000000)
                let rLon = Double(round(100000000*xLon)/100000000)
                let center = CLLocationCoordinate2D(latitude: rLat, longitude: rLon)
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
