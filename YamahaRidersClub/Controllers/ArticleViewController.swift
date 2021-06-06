//
//  ArticleViewController.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 21/3/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class ArticleViewController: UITableViewController {
    var eventModel = EventModel()
    {
        didSet {
            // because we perform this operation on the main thread, it is safe
            print("OK")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        tableView12 = tableView
//        tableView.reloadData()
        debugPrint("ok in count \(eventModel)")
        return eventModel.data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell") as! ArticleTableViewCell
//        cell.articleNameLabel.text = "Hello"
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell") as! ArticleTableViewCell
//        let imageUrlString = httpCheckProfile + (UserInfo.picture ?? "")
        let stringURL = "\(eventModel.baseurl ?? "")\(eventModel.data[indexPath.row].imageName?.replacingOccurrences(of: " ", with: "%20") ?? "")"
//        print(stringURL)
//        let imageUrl:URL = URL(string:stringURL)!
//        let image = UIImageView()
//        cell.articleImageView.loadImge(withUrl:imageUrl)
//        imgView.sd_imageIndicator = SDWebImageActivityIndicator.gray
//        imgView.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(named: "placeholder"))
        cell.articleImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.articleImageView.sd_setImage(with: URL(string: stringURL), placeholderImage: #imageLiteral(resourceName: "yamaha_login_logo"))
        
        cell.monthOfEvent.text =  eventModel.data[indexPath.row].articleStartDate
        cell.articleNameLabel.text = eventModel.data[indexPath.row].articleName
        
//        tableView.reloadData()
        return cell
        
    }
    
    func fethDataForAtricle(){
        AF.request("https://apps.acibd.com/apps/yrc/syncdata/articalsync?articaltype=0&start=0&end=10").response { response in
//            debugPrint(response.debugDescription)
            if let res = response.value{
                if let finalData = res{
                    let swiftyJsonVar = JSON(finalData)
                    print(swiftyJsonVar)
                    
                    //self.eventModel.baseurl = self.converHttpToHttps( swiftyJsonVar["baseurl"].string ?? "")
                    self.eventModel.baseurl = swiftyJsonVar["baseurl"].string ?? ""
                    
                    self.eventModel.message = swiftyJsonVar["message"].string ?? ""
                    self.eventModel.success = swiftyJsonVar["message"].int ?? 0
                    print(swiftyJsonVar["data"].count)
//                    var i = 0
                    let maxVal = swiftyJsonVar["data"].count
                    for i in 0...(maxVal-1){
                        print(swiftyJsonVar["data"][i])
                        let newData = DataOfArticle(eventOrganizedBy: swiftyJsonVar["data"][i]["EventOrganizedBy"].string ?? "", imageName:swiftyJsonVar["data"][i]["ImageName"].string ?? "", isVideo: swiftyJsonVar["data"][i]["IsVideo"].string ?? "", articleCategoryName: swiftyJsonVar["data"][i]["ArticleCategoryName"].string ?? "", eventDetailsInfo: swiftyJsonVar["data"][i]["EventDetailsInfo"].string ?? "", eventLocationLongatude: swiftyJsonVar["data"][i]["EventLocationLongatude"].string ?? "", isImage: swiftyJsonVar["data"][i]["IsImage"].string ?? "", youtubeVideoLink: swiftyJsonVar["data"][i]["YoutubeVideoLink"].string ?? "", articleEndDate: swiftyJsonVar["data"][i]["ArticleEndDate"].string ?? "", eventLocation: swiftyJsonVar["data"][i]["EventLocation"].string ?? "", articleStartDate: swiftyJsonVar["data"][i]["ArticleStartDate"].string ?? "", articleName: swiftyJsonVar["data"][i]["ArticleName"].string ?? "", articleID: swiftyJsonVar["data"][i]["ArticleId"].string ?? "", authorBy: swiftyJsonVar["data"][i]["AuthorBy"].string ?? "", eventLocationLattitude: swiftyJsonVar["data"][i]["EventLocationLattitude"].string ?? "", sl: swiftyJsonVar["data"][i]["SL"].string ?? "", imageCount: (swiftyJsonVar["data"][i]["ImageCount"].string ?? ""))
                        self.eventModel.data.append(newData)
                        print(self.eventModel.data[i].imageName)
                        DispatchQueue.main.async {
                            print("OK in for")
                            self.tableView.reloadData()
                        }
                        
                    }
                }
                
            }
        }
    }
    func converHttpToHttps(_ httpCheckProfile: String) -> String{
        var temp:String
        if(httpCheckProfile.contains("https")){
            temp = httpCheckProfile
        }
        else{
            let endOfSentence = httpCheckProfile.firstIndex(of: ":")!
            let firstSentence = httpCheckProfile[endOfSentence...]
            temp = "https"+firstSentence
        }
        return temp
    }
                
                    
    override func viewWillAppear(_ animated: Bool) {
//        eventModel.fethDataForAtricle{[weak self] in
//            DispatchQueue.main.async {
        fethDataForAtricle()
//                self.tableView.reloadData()
//            }
//        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        title = "Events"
//        tableView.reloadData()
//        tableView.delegate = self
//        tableView.dataSource = self
////        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ArticleTableViewCell")
//        title = "Article"

        // Do any additional setup after loading the view.
    }
    

}

