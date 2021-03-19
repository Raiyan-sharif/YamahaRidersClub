//
//  HomeViewController.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 15/3/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class HomeViewController: UIViewController{
    var topView: UIView?
    let transition = SlideInTransition()
    @IBOutlet weak var ItemMenuIcon: UIBarButtonItem!
    
    var userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationItem.hidesBackButton = true
        title = "YRC-BD"
        ItemMenuIcon.image = UIImage(systemName: "rectangle.split.3x3")
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1794194281, green: 0.06704645604, blue: 0.6007958055, alpha: 1)
        AF.request("https://apps.acibd.com/apps/yrc/syncdata/articalsync?articaltype=0&start=0&end=10").response { response in
//            debugPrint(response.debugDescription)
            if let res = response.value{
                if let finalData = res{
                    let swiftyJsonVar = JSON(finalData)
                    print(swiftyJsonVar)
                }
            }
        }
        fetchDataForProfile()
        
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
        let title = String(describing: menuType).capitalized
        self.title = title
        topView?.removeFromSuperview()
        switch menuType {
        case .Weather:
            let vc = storyboard?.instantiateViewController(withIdentifier: "WeatherViewController" ) as! WeatherViewController
            topView = vc.view
            self.view.addSubview(topView!)
//            gotToWeatherPage()
        case .MyPrifile:
            //ProfileViewController
            let vc = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController" ) as! ProfileViewController
            self.navigationController?.pushViewController(vc,
            animated: true)
            
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


