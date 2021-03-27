//
//  HomeViewController.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 15/3/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class HomeViewController: UIViewController, UITableViewDelegate,UITableViewDataSource{
    
    var optionToSelectedForEvent:Int = 0
    var countOfData:Int = 0
    //0- for all, 1 for event, 2 for tick & tips
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countOfData = articles?.data.count ?? 0
        if countOfData == 0{
            return 1
        }
        print(countOfData)
        return articles?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if countOfData == 0{
            let emptyCell = tableView.dequeueReusableCell(withIdentifier: "EmptyDataCell")
            
//            emptyCell.imageView?.frame = CGRectMake(emptyCell.imageView?.frame.origin.x,emptyCell.imageView?.frame.origin.y,desiredWidth,self.imageView.frame.size.height);
            emptyCell?.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            return emptyCell ?? UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as? ArticleTableViewCell
        if let urlString = URL(string: (articles?.baseurl ?? "") + (articles?.data[0].imageName ?? "")){
            cell?.articleImageView.loadImge(withUrl: urlString)
        }
        
        
        //Date Manipulations
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let startDate = dateFormatter.date(from: articles?.data[indexPath.row].articleStartDate ?? "2021-03-11 00:00:00.000")
        let endDate = dateFormatter.date(from: articles?.data[indexPath.row].articleEndDate ?? "2021-03-11 00:00:00.000")
        
//        print(date)
        let cellDateFormat = DateFormatter()
        cellDateFormat.setLocalizedDateFormatFromTemplate("MMM")
        let month = cellDateFormat.string(from: startDate ?? Date())
        cellDateFormat.setLocalizedDateFormatFromTemplate("dd")
        let day = cellDateFormat.string(from: startDate ?? Date())
        
        cellDateFormat.setLocalizedDateFormatFromTemplate("MMM dd")
        let startDay = cellDateFormat.string(from: startDate ?? Date())
        let endDay = cellDateFormat.string(from: endDate ?? Date())
        
        print("\(startDay) - \(endDay)")
        
        cell?.monthOfEvent.text = month
        cell?.dayOfEvent.text = day
        cell?.articleStartEndDate.text = "\(startDay) - \(endDay)"
        cell?.articleNameLabel.text = articles?.data[indexPath.row].articleName
        cell?.eventLocation.text = articles?.data[indexPath.row].eventLocation
        cell?.eventDetailsInfoLabel.text = articles?.data[indexPath.row].eventDetailsInfo
        cell?.articleAuthor.text = articles?.data[indexPath.row].authorBy
        cell?.urlOfYouTube = articles?.data[indexPath.row].youtubeVideoLink ?? "www.youtube.com"
        
        
        
        return cell ?? UITableViewCell()
    }
    
    
    
    var topView: UIView?
    var articles: ArticleModel?
    let transition = SlideInTransition()
    @IBOutlet weak var ItemMenuIcon: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    var userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationController?.navigationItem.hidesBackButton = true
        
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        navigationController?.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        tableView.layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tableView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        title = "YRC-BD"
        ItemMenuIcon.image = UIImage(systemName: "rectangle.split.3x3")
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1794194281, green: 0.06704645604, blue: 0.6007958055, alpha: 1)
        
        
        loadAllEvents()
        fetchDataForProfile()
        
    }
    func loadAllEvents(){
        DispatchQueue.main.async {
            AF.request("https://apps.acibd.com/apps/yrc/syncdata/articalsync?articaltype=\(self.optionToSelectedForEvent)&start=0&end=10").response { response in
    //            debugPrint(response.debugDescription)
                if let res = response.value{
                    if let finalData = res{
                        let decoder = JSONDecoder()
                        do{
                            self.articles = try decoder.decode(ArticleModel.self, from: finalData)
                            print(self.articles ?? "No Data")
                            
                            self.tableView.reloadData()
                        }
                        catch{
                            print(error)
                        }
//                        let swiftyJsonVar = JSON(finalData)
//                        print("Home View")
//                        print(swiftyJsonVar)
                    }
                }
            }
        }
    }
    func fetchDataForProfile(){
        DispatchQueue.main.async {
            print(ConstantSring.baseURLRiderProfile+"?MobileNo="+self.userDefaults.string(forKey: "mobileno")!)
            AF.request(ConstantSring.baseURLRiderProfile+"?MobileNo="+self.userDefaults.string(forKey: "mobileno")!).responseJSON { (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    print(json)
                    if json["success"] == 1{
                        UserInfo.baseurl = json["baseurl"].string
                        UserInfo.message = json["message"].string
                        UserInfo.chassisNo = json["data"][0]["ChassisNo"].string
                        UserInfo.registrationNo = json["data"][0]["RegistrationNo"].string
                        UserInfo.avgSpeed = json["data"][0]["AvgSpeed"].string
                        UserInfo.maxSpeed = json["data"][0]["MaxSpeed"].string
                        UserInfo.bloodGroup = json["data"][0]["BloodGroup"].string
                        UserInfo.engineNo = json["data"][0]["EngineNo"].string
                        UserInfo.facebookIDLink = json["data"][0]["FacebookIdLink"].string
                        UserInfo.drivingLicense = json["data"][0]["DrivingLicense"].string
                        UserInfo.coverPhoto = json["data"][0]["CoverPhoto"].string
                        UserInfo.brandName = json["data"][0]["BrandName"].string
                        UserInfo.picture = json["data"][0]["Picture"].string
                        UserInfo.mobileno = json["data"][0]["Mobileno"].string
                        UserInfo.name = json["data"][0]["Name"].string
                        UserInfo.dateOfBirth = json["data"][0]["DateOfBirth"].string
                        UserInfo.nid = json["data"][0]["NID"].string
                        UserInfo.bikeModel = json["data"][0]["BikeModel"].string
                        UserInfo.memberDays = json["data"][0]["MemberDays"].string
                    }
                
                case .failure(let error):
                    print(error.localizedDescription)
                    
                }
            
            }
        }
    }
    
    func gotToWeatherPage(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "WeatherViewController" ) as! WeatherViewController
         
         navigationController?.pushViewController(vc,
         animated: true)
    }
    
    func goToScannerPage(){
//        QRScannerViewController
        let vc = storyboard?.instantiateViewController(withIdentifier: "QRScannerViewController" ) as! QRScannerViewController
         
         navigationController?.pushViewController(vc,
         animated: true)
    }
    
//    func goToArticlePage(){
//        //ArticleViewController
//        let vc = storyboard?.instantiateViewController(withIdentifier: "ArticleViewController" ) as! ArticleViewController
//
//         navigationController?.pushViewController(vc,
//         animated: true)
//    }
    
    
    @IBAction func didTapHomeMenu(_ sender: UIBarButtonItem) {
        
        guard let menuViewController = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else {return}
        menuViewController.didTapMenuType = {
            menuType in
            print(menuType)
            self.transitionToNew(menuType)
        }
        menuViewController.modalPresentationStyle = .overCurrentContext
        menuViewController.transitioningDelegate = self
        present(menuViewController, animated: true)
        
    }
    
    func transitionToNew(_ menuType: DidSelectMenuItemOption){
//        let title = String(describing: menuType).capitalized
//        self.title = title
        topView?.removeFromSuperview()
        switch menuType {
        
        case .MyPrifile:
            //ProfileViewController
            let vc = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController" ) as! ProfileViewController
            self.navigationController?.pushViewController(vc,
            animated: true)
            
        case .NewsFeed:
            self.optionToSelectedForEvent = 0
            loadAllEvents()
        case .Offer:
            //OfferViewController
            let vc = storyboard?.instantiateViewController(withIdentifier: "OfferViewController" ) as! OfferViewController
            self.navigationController?.pushViewController(vc,
            animated: true)
            
        case .Dealer:
            //DealerViewController
            let vc = storyboard?.instantiateViewController(withIdentifier: "DealerViewController" ) as! DealerViewController
            self.navigationController?.pushViewController(vc,
            animated: true)
        case .Events:
//            goToArticlePage()
            self.optionToSelectedForEvent = 1
            loadAllEvents()
        
            
        case .TricksnTips:
            self.optionToSelectedForEvent = 2
            loadAllEvents()
        
        case .Weather:
            gotToWeatherPage()
        case .QRScanner:
            goToScannerPage()
            
        case .Logout:
            self.userDefaults.setValue(false, forKey: "isloggedIn")
            self.userDefaults.setValue("", forKey: "mobileno")
            self.userDefaults.setValue("", forKey: "password")
            self.navigationController?.popToRootViewController(animated: true)
            
            
            
        default:
            dismiss(animated: false, completion: nil)
        }
        
    }
}

extension HomeViewController: UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPressenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPressenting = false
        return transition
    }
}


