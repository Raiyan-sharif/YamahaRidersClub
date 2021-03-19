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


