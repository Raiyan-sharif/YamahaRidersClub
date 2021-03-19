//
//  WeatherViewController.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 19/3/21.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, UITextFieldDelegate, WeatherManagerDelegate {

    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.requestLocation()
        
        
//        searchTextField.delegate = self
        weatherManager.delegate = self
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.requestLocation()
    }
    
    func didUpdateWeather(_ weatherManger: WeatherManager, weather: WeatherModel){
//        print(weather.temperature)
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
        
        
    }
    func didFailWithError(error: Error) {
        print(error)
    }
    @IBAction func getCurrentLocationData(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
}

//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
//            print("Go to \(location.coordinate.latitude)  \(location.coordinate.longitude)")
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Waht an \(error)")
    }
}
