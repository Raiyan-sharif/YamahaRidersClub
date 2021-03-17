//
//  MenuViewController.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 15/3/21.
//

import UIKit

class MenuViewController: UITableViewController {
    var menuItemList: [MenuListItem] = [MenuListItem(image: "person.fill", itemName: "My Profile"),
                                        MenuListItem(image: "person.fill", itemName: "News Feed"),
                                        MenuListItem(image: "person.fill", itemName: "Products"),
                                        MenuListItem(image: "person.fill", itemName: "Offer"),
                                        MenuListItem(image: "person.fill", itemName: "Parts"),
                                        MenuListItem(image: "person.fill", itemName: "Dealer"),
                                        MenuListItem(image: "person.fill", itemName: "QR Scanner"),
                                        MenuListItem(image: "person.fill", itemName: "Events"),
                                        MenuListItem(image: "person.fill", itemName: "Tricks & Tips"),
                                        MenuListItem(image: "person.fill", itemName: "New Ride"),
                                        MenuListItem(image: "person.fill", itemName: "My Ride"),
                                        MenuListItem(image: "person.fill", itemName: "Weather"),
                                        MenuListItem(image: "person.fill", itemName: "Log out"),
                                        MenuListItem(image: "person.fill", itemName: "About")]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
            
            
            if(menuType.rawValue == DidSelectMenuItemOption.Logout.rawValue){
                
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItemList.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "menuTitleCell") as! MenuTitleTableViewCell
            
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
