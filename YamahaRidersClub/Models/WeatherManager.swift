//
//  WeatherManager.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 19/3/21.
//

import Foundation
import  CoreLocation

protocol WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManger: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager{
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?APPID=f352e794e221747bf0ad789ac5c8cadb&units=metric"
    var delegate: WeatherManagerDelegate?
    //    let weatherURL = "http://apps.acibd.com/apps/yrc/riderinfo/loginservice?mobileno=01755939896&password=1234"
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString =  "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performReqest(urlString: urlString)
    }
//    func fetchWeather(cityName: String){
//        let urlString = "\(weatherURL)&q=\(cityName)"
//        //        performReqest(urlString: "https://apps.acibd.com/apps/yrc/riderinfo/loginservice?mobileno=01755939896&password=1234")
//        performReqest(urlString: urlString)
//        
//    }
    func performReqest(urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with:url) { (data,response,error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data{
//                    let dataString = String(data: safeData, encoding: .utf8)
                    if let weather = self.parseJSON(weatherData: safeData){
//                        let weatherVC = WeatherViewController()
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
//                    print(dataString)
                    
                }
            }
            
            
            task.resume()
        }
        
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            print(weather.conditionName)
            return weather
//            getConditionName(weatherId: id)
            
        }catch{
            
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
}

