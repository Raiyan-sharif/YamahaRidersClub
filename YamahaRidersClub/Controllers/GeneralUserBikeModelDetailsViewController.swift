//
//  GeneralUserBikeModelDetailsViewController.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 5/4/21.
//

import UIKit
import Alamofire
import SwiftyJSON
class GeneralUserBikeModelDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    var listOfElements: [ItemsOfGeneuinePArtsDetails] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfElements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GeneralUserBikeModelDetailsTableViewCell", for: indexPath) as? GeneralUserBikeModelDetailsTableViewCell
      
        
        
        cell?.partsNameLablel.text = listOfElements[indexPath.row].partsName
        cell?.partsNoLabel.text = listOfElements[indexPath.row].partsNo
        cell?.mRPLabel.text = listOfElements[indexPath.row].mRP
        

        return cell ?? UITableViewCell()
       
    }
    

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tableView.dataSource = self
        tableView.delegate = self
        fethDataGeneralUserBikeModel()
        // Do any additional setup after loading the view.
    }
    

    func fethDataGeneralUserBikeModel(){
        listOfElements = []
        AF.request("http://dashboard.acigroup.info/apps/yamahacustomerarsenal/generaluser/genuine_parts?bike_model_id=\(GeneralUserBikeModelSelection.selection)").response { response in
//            debugPrint(response.debugDescription)
            if let res = response.value{
                if let finalData = res{
                    let swiftyJsonVar = JSON(finalData)
                    print(swiftyJsonVar)
                    var temCout = 0
                    for i in swiftyJsonVar["Parts"]{
                        self.listOfElements.append(ItemsOfGeneuinePArtsDetails(partsName: "\(swiftyJsonVar["Parts"][temCout]["PartsName"])", partsNo: "\(swiftyJsonVar["Parts"][temCout]["PartNo"])", mRP: "\(swiftyJsonVar["Parts"][temCout]["MRP"])"))
                        temCout = temCout + 1
                    }
                    
                    
                    self.tableView.reloadData()
                }
                
            }
        }
    }

}

struct ItemsOfGeneuinePArtsDetails{
    var partsName:String = ""
    var partsNo:String
    var mRP: String
}
