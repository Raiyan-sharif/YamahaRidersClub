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
        
        //Date Manipulations
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let startDate = dateFormatter.date(from: myRideModel?.data[indexPath.row].startTime ?? "2021-03-11 00:00:00.000")
        let endDate = dateFormatter.date(from: myRideModel?.data[indexPath.row].startTime ?? "2021-03-11 00:00:00.000")
        
//        print(date)
        let cellDateFormat = DateFormatter()
        cellDateFormat.setLocalizedDateFormatFromTemplate("MMM dd, yyyy HH:mm")
        let st = cellDateFormat.string(from: startDate ?? Date())
       
        let lt = cellDateFormat.string(from: endDate ?? Date())
        
//        cellDateFormat.setLocalizedDateFormatFromTemplate("MMM dd")
//        let startDay = cellDateFormat.string(from: startDate ?? Date())
//        let endDay = cellDateFormat.string(from: endDate ?? Date())
        cell?.timeDuration.text = "\(st)\n\(lt)"
        return cell ?? UITableViewCell()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
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
