//
//  MyRideViewController.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 27/3/21.
//

import UIKit
import Alamofire

class MyRideViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    var userDefaults = UserDefaults.standard
    var myRideModel: MyRideModel?
    @IBOutlet weak var tableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myRideModel?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyRideTableViewCell", for: indexPath) as? MyRideTableViewCell
        
        cell?.startAddress.text = myRideModel?.data[indexPath.row].startAddress
        cell?.endAddress.text = myRideModel?.data[indexPath.row].endAddress
        cell?.speed.text = "Avg speed - \(myRideModel?.data[indexPath.row].avgSpeed ?? "") - Max speed \(myRideModel?.data[indexPath.row].maxSpeed ?? "")"
        cell?.timeDuration.text = "\(myRideModel?.data[indexPath.row].startTime ?? "")\n\(myRideModel?.data[indexPath.row].endTime ?? "")"
        return cell ?? UITableViewCell()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        title = "My Ride History"
        loadAllRides()
        // Do any additional setup after loading the view.
    }
    
    
    func loadAllRides(){
        DispatchQueue.main.async {
            AF.request("http://apps.acibd.com/apps/yrc/syncdata/bikeride?mobileno=\(self.userDefaults.string(forKey: "mobileno") ?? "")").response { response in
    //            debugPrint(response.debugDescription)
                if let res = response.value{
                    if let finalData = res{
                        let decoder = JSONDecoder()
                        do{
                            self.myRideModel = try decoder.decode(MyRideModel.self, from: finalData)
                            print(self.myRideModel ?? "No Data")
                            
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
