//
//  LoginManager.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 18/3/21.
//

import Foundation

protocol LoginManagerDelegate {
    func didLogin(_ userManager: LoginManager, user: LoginModel)
    func didFailWithError(error: Error)
}

struct LoginManager{
    var loginURL = "https://apps.acibd.com/apps/yrc/riderinfo/loginservice?"
//    var eventsURL = "https://apps.acibd.com/apps/yrc/syncdata/articalsync?articaltype=1&start=0&end=10"
    var delegate: LoginManagerDelegate?
    func fetchUser(mobileno: String, password: String){
        //mobileno=01755939896&password=1234
        let urlString = "\(loginURL)mobileno=\(mobileno)&password=\(password)"
        print(urlString)
        performReqest(urlString: urlString)
    }
    
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
                    if let user = self.parseJSON(userData: safeData){
//                        let weatherVC = WeatherViewController()
                        self.delegate?.didLogin(self, user: user)
                    }
//                    print(dataString)
                    
                }
            }
            
            
            task.resume()
        }
        
    }
    
    func parseJSON(userData: Data) -> LoginModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(LoginData.self, from: userData)
//            let id = decodedData.
//            let temp = decodedData.main.temp
//            let name = decodedData.name
            
//            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            let user = LoginModel(success: decodedData.success, message: decodedData.message, name: decodedData.name, age: decodedData.age, sex: decodedData.sex, mobileno: decodedData.mobileno, chessisno: decodedData.chessisno, engineno: decodedData.engineno, registrationno: decodedData.registrationno, brandcode: decodedData.brandcode, brandname: decodedData.brandname, productcode: decodedData.productcode, productname: decodedData.productname, dealarcode: decodedData.dealarcode, dealarname: decodedData.dealarname, address: decodedData.address)
//            print(weather.conditionName)
            return user
//            getConditionName(weatherId: id)
            
        }catch{
            
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
}
