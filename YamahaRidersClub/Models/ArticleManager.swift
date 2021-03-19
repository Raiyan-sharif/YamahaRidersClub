//
//  ArticleManager.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 18/3/21.
//


import Foundation

protocol ArticleManagerDelegate {
    func getArticleData(article: ArticleModel)
    func didFailWithError(error: Error)
}

struct ArticleManager{
    let eventsURL = "https://apps.acibd.com/apps/yrc/syncdata/articalsync?articaltype=0&start=0&end=10"
    var delegate: ArticleManagerDelegate?
    
    func getArticle(){
        
        if let url = URL(string: eventsURL){
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with:url) { (data,response,error) in
                
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data{
                    
                    if let article = self.parseJSON(userData: safeData){
//                        print(article.data)
                        self.delegate?.getArticleData(article: article)
                    }
                }
            }
            task.resume()
        }
    }
    
        
    
    
    func parseJSON(userData: Data) -> ArticleModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(ArticleData.self, from: userData)
//            let id = decodedData.
//            let temp = decodedData.main.temp
//            let name = decodedData.name
            
//            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
//            print(decodedData.data)
            let article = ArticleModel(success: decodedData.success, message: decodedData.message, data: decodedData.data, baseurl: decodedData.baseurl)
//            print(weather.conditionName)
            return article
//            getConditionName(weatherId: id)
            
        }catch{
            
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
}

