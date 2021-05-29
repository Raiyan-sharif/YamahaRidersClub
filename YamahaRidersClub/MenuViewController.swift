//
//  MenuViewController.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 15/3/21.
//

import UIKit

class MenuViewController: UITableViewController {
    var didTapMenuType: ((DidSelectMenuItemOption) -> Void)?
    

    
    var menuItemList: [MenuListItem] = [MenuListItem(image: "person.fill", itemName: "My Profile"),
                                        MenuListItem(image: "radiowaves.right", itemName: "News Feed"),
                                        MenuListItem(image: "cart", itemName: "Products"),
                                        MenuListItem(image: "archivebox", itemName: "Offer"),
                                        MenuListItem(image: "books.vertical", itemName: "Parts"),
                                        MenuListItem(image: "giftcard.fill", itemName: "Dealer"),
                                        MenuListItem(image: "scanner", itemName: "QR Scanner"),
                                        MenuListItem(image: "video.bubble.left", itemName: "Events"),
                                        MenuListItem(image: "mappin.and.ellipse", itemName: "Tricks & Tips"),
                                        MenuListItem(image: "map", itemName: "New Ride"),
                                        MenuListItem(image: "bicycle", itemName: "My Ride"),
                                        MenuListItem(image: "wind", itemName: "Weather"),
                                        MenuListItem(image: "power", itemName: "Log out"),
                                        MenuListItem(image: "info", itemName: "About"),
                                        MenuListItem(image: "list.bullet.rectangle", itemName: "Privacy Policy"),
                                        MenuListItem(image: "list.bullet.rectangle", itemName: "License"),
    ]
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        
        
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {

        if let swipeGesture = gesture as? UISwipeGestureRecognizer {

            switch swipeGesture.direction {
            case .right:
                print("Swiped right")
                dismiss(animated: true)
            case .down:
                print("Swiped down")
            case .left:
                print("Swiped left")
                dismiss(animated: true)
            case .up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//
//        return menuItemList.count
//    }
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Hello"
//    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menuType = DidSelectMenuItemOption(rawValue: indexPath.row-1) else {
            return
        }
        dismiss(animated: true){
            
            print("Dismissing on click \(menuType) \(indexPath.row-1)")
            self.didTapMenuType?(menuType)
            
//            //WeatherViewController
//            if indexPath.row == 12{
//                print("ok")
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "WeatherViewController" ) as! WeatherViewController
//                self.navigationController?.topViewController?.addChild(vc)
////                self.getToWeatherPage()
//            }
            
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItemList.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "menuTitleCell") as! MenuTitleTableViewCell
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            
            cell.appVersionLabel.text = "App Version: \(appVersion ?? "1.0")"
            
            return cell
        }
        
        let menuItemImage = UIImage(systemName: menuItemList[indexPath.row-1].image)
        let menuTitleName = menuItemList[indexPath.row-1].itemName
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuItemCell") as! MenuItemTableViewCell
        
        cell.imageViewIcon.image = menuItemImage
        cell.menuItemName.text = menuTitleName
        return cell
    }

    

}
