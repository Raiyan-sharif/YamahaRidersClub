//
//  AccessoriesNHalmetViewController.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 6/4/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class AccessoriesNHalmetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var stringURL = "http://dashboard.acigroup.info/apps/yamahacustomerarsenal/generaluser/accessories_helmet"
    
    var nameList:[String] = []
    var priceList:[String] = []
    var imageList:[String] = []
    var imageLoadingBaseUrl:String = "http://dashboard.acigroup.info/yca/"
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HalmetTableViewCell", for: indexPath) as! HalmetTableViewCell
        if let urlString = URL(string: (imageLoadingBaseUrl + (imageList[indexPath.row]))){
            cell.imageOfHalmet.loadImge(withUrl: urlString)
        }
        cell.priceTag.text = "\(priceList[indexPath.row])/-"
        cell.titleDescription.text = nameList[indexPath.row]
        return cell
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        loadAllLubesData()
        // Do any additional setup after loading the view.
    }
    

    func loadAllLubesData(){
        print("Calle")
        DispatchQueue.main.async {
            AF.request(self.stringURL).response { response in
    //            debugPrint(response.debugDescription)
                if let res = response.value{
                    if let finalData = res{
                        
                        let swiftyJsonVar = JSON(finalData)
//                        print("Home View")
                        print(swiftyJsonVar)
                        let dataList = swiftyJsonVar["AccessoriesHelmet"]
                        for i in 0 ... dataList.count-1{
                            self.nameList.append(swiftyJsonVar["AccessoriesHelmet"][i]["Name"].string ?? "")
                            self.priceList.append(swiftyJsonVar["AccessoriesHelmet"][i]["MRP"].string ?? "")
                            self.imageList.append(swiftyJsonVar["AccessoriesHelmet"][i]["Image"].string ?? "")
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
