//
//  OfferViewController.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 27/3/21.
//

import UIKit
import Alamofire



class OfferViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var tableView: UITableView!
    var offerList: OfferModel?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offerList?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OfferTableViewCell", for: indexPath) as? OfferTableViewCell
        let urlOfImageString = "\(offerList?.baseurl ?? "")\(offerList?.data[indexPath.row].offerImage ?? "")"
        print(urlOfImageString)
        if let urlImage = URL(string: urlOfImageString){
            cell?.offerImage.loadImge(withUrl: urlImage)
        }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let expireDate = dateFormatter.date(from: offerList?.data[indexPath.row].expireDate ?? "2021-03-11 00:00:00.000")
       
        let cellDateFormat = DateFormatter()
        cellDateFormat.setLocalizedDateFormatFromTemplate("MMM dd, yyyy")
        let finalExpirationDate = cellDateFormat.string(from: expireDate ?? Date())
        
        cell?.expirationDate.text = finalExpirationDate
        cell?.offerDetails.text = offerList?.data[indexPath.row].offerDetails
        cell?.offerName.text = offerList?.data[indexPath.row].offerName
        print("\(finalExpirationDate)")
        
        
        
        return cell ?? UITableViewCell()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        loadAllOffers()
        // Do any additional setup after loading the view.
    }
    func loadAllOffers(){
        DispatchQueue.main.async {
            AF.request("https://apps.acibd.com/apps/yrc/offer/offerlist?page=1").response { response in
    //            debugPrint(response.debugDescription)
                if let res = response.value{
                    if let finalData = res{
                        let decoder = JSONDecoder()
                        do{
                            self.offerList = try decoder.decode(OfferModel.self, from: finalData)
                            print(self.offerList ?? "")
                            
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
