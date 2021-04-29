//
//  GeneralUserBikeModelViewController.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 5/4/21.
//

import UIKit
import Alamofire
import SwiftyJSON
class GeneralUserBikeModelViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
//    let cellSpacingHeight: CGFloat = 5
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bikeModelNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
//        let imageUrlString = httpCheckProfile + (UserInfo.picture ?? "")
        print(indexPath.row)
        cell.textLabel?.text = bikeModelNames[indexPath.row]
        cell.textLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cell.contentView.layer.borderWidth = 2.0
        
        cell.contentView.layer.borderColor = #colorLiteral(red: 0.1790010631, green: 0.06708221883, blue: 0.6007973552, alpha: 1)
        cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.imageView?.image = #imageLiteral(resourceName: "ic_launcher_foreground")
//        tableView.layoutMargins.bottom = 10.0
        
        
        
        

        return cell
    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//            return cellSpacingHeight
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Tapped on \(self.bikeBikeModelIDs[indexPath.row])")
        GeneralUserBikeModelSelection.selection = self.bikeBikeModelIDs[indexPath.row]
        
        gotoDetailsPage()
    }
    func gotoDetailsPage(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "GeneralUserBikeModelDetailsViewController" ) as! GeneralUserBikeModelDetailsViewController
         
         navigationController?.pushViewController(vc,
         animated: true)
    }
    

    @IBOutlet weak var tableView: UITableView!
    
    var bikeModelNames:[String] = []
    var bikeBikeModelIDs:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tableView.dataSource = self
        tableView.delegate = self
        fethDataGeneralUserBikeModel()
        // Do any additional setup after loading the view.
    }
    

    func fethDataGeneralUserBikeModel(){
        AF.request("http://dashboard.acigroup.info/apps/yamahacustomerarsenal/generaluser/bike_models").response { response in
//            debugPrint(response.debugDescription)
            if let res = response.value{
                if let finalData = res{
                    let swiftyJsonVar = JSON(finalData)
//                    print(swiftyJsonVar["BikeModel"])
                    var k = 0
                    for i in swiftyJsonVar["BikeModel"]{
                        
                        print(swiftyJsonVar["BikeModel"][k])
                        
                        self.bikeModelNames.append("\(swiftyJsonVar["BikeModel"][k]["BikeModelName"])")
                        self.bikeBikeModelIDs.append("\(swiftyJsonVar["BikeModel"][k]["BikeModelID"])")
                        k = k + 1
                    }
                    
                    self.tableView.reloadData()
                }
                
            }
        }
    }
}
