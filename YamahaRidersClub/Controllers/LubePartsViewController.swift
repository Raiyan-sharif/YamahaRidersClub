//
//  LubePartsViewController.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 6/4/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class LubePartsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    var listOfLube:[LubePartsModel] = []
    var imageLoadingBaseUrl:String = "http://dashboard.acigroup.info/yca/"
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfLube.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LubePartsTableViewCell", for: indexPath) as? LubePartsTableViewCell
        
//        cell?.imageOfProduct.image
        if let urlString = URL(string: (imageLoadingBaseUrl + (listOfLube[indexPath.row].imageOfProduct))){
            cell?.imageOfProduct.loadImge(withUrl: urlString)
        }
        cell?.YamaLubeName.text = listOfLube[indexPath.row].yamaLubeName
        cell?.bikeModel.text = listOfLube[indexPath.row].bikeModel
        cell?.changingInterval.text = listOfLube[indexPath.row].changingInterval
        cell?.mRP.text = listOfLube[indexPath.row].mRP
                            
        
        
        
        return cell ?? UITableViewCell()
    }
    
    let lubeDataPageurlString: String = "http://dashboard.acigroup.info/apps/yamahacustomerarsenal/generaluser/yamalube"

    override func viewDidLoad() {
        super.viewDidLoad()
        //http://dashboard.acigroup.info/apps/yamahacustomerarsenal/generaluser/yamalube
        
        //http://dashboard.acigroup.info/yca/assets/img/thumbnail/lube1.png
        
        //LubePartsTableViewCell
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        loadAllLubesData()
        
    }
    
    func loadAllLubesData(){
        print("Calle")
        DispatchQueue.main.async {
            AF.request(self.lubeDataPageurlString).response { response in
    //            debugPrint(response.debugDescription)
                if let res = response.value{
                    if let finalData = res{
                        
                        let swiftyJsonVar = JSON(finalData)
//                        print("Home View")
                        print(swiftyJsonVar["YamaLube"])
                        var tempCount = 0
                        for _ in swiftyJsonVar["YamaLube"]{
                            self.listOfLube.append(LubePartsModel(imageOfProduct: ("\(swiftyJsonVar["YamaLube"][tempCount]["Thumb"])" ), yamaLubeName: ("\(swiftyJsonVar["YamaLube"][tempCount]["YamaLubeName"])" ), changingInterval: ("ChangingInterval: \(swiftyJsonVar["YamaLube"][tempCount]["ChangingInterval"])" ), mRP: ("\(swiftyJsonVar["YamaLube"][tempCount]["MRP"])/-" ), bikeModel: ("\(swiftyJsonVar["YamaLube"][tempCount]["BikeModel"])" )))
                            
                            tempCount = tempCount + 1
                        }
                        
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
