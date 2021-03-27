//
//  DealerViewController.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 27/3/21.
//

import UIKit
import Alamofire

class DealerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var dealerList: DealerModel?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dealerList?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DealerTableViewCell", for: indexPath) as? DealerTableViewCell
        cell?.dealerName.text = dealerList?.data[indexPath.row].dealerPointName
        cell?.dealerType.text = dealerList?.data[indexPath.row].dealerType
        cell?.dealerAdress.text = dealerList?.data[indexPath.row].address
        let value = "\(dealerList?.data[indexPath.row].latitude ?? "23.0"),\(dealerList?.data[indexPath.row].longitude ?? "90.0")"
        
        let urlValue = "https://www.google.com/maps/search/?api=1&query=\(value)"
        cell?.urlToGoTo = urlValue
        return cell ?? UITableViewCell()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
        
        loadAllDealer()
    }
    

    func loadAllDealer(){
        DispatchQueue.main.async {
            AF.request("https://apps.acibd.com/apps/yrc/dealer-list").response { response in

                if let res = response.value{
                    if let finalData = res{
                        let decoder = JSONDecoder()
                        do{
                            self.dealerList = try decoder.decode(DealerModel.self, from: finalData)
                            print(self.dealerList)
                            
                            self.tableView.reloadData()
                        }
                        catch{
                            print(error)
                        }

                    }
                }
            }
        }
    }

}
