//
//  ProductListViewController.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 28/3/21.
//

import UIKit
import Alamofire


class ProductListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var pageNo: Int = 1
    var success: Int = 1
    var productListModel: ProductsModel?
    @IBOutlet weak var tableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productListModel?.productInfo.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductsListTableViewCell") as? ProductsListTableViewCell
        let urlString = "http://dashboard.acigroup.info/yca/\(productListModel?.productInfo[indexPath.row].image ?? "assets/img/medium/R15%20V3-1.png")"
        print(urlString)
        let urlData = URL(string: urlString) ?? URL(string: "http://dashboard.acigroup.info/yca/assets/img/medium/R15%20V3-1.png")!
//        cell?.productImage.loadImge(withUrl: urlData)
        DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: urlData) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            cell?.productImage.image = image
                        }
                    }
                }
            }
        cell?.productName.text = productListModel?.productInfo[indexPath.row].productName
        
        return cell ?? UITableViewCell()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.pageNo = 1
        self.success = 1
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
//        for k in 1...4{
            grapBikeProducts()
            
            
//        }
        
        
    }
    

    func grapBikeProducts(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            AF.request("http://dashboard.acigroup.info/apps/yamahacustomerarsenal/product/getproduct?categoryname=\("Bikes")&page=\(self.pageNo)").response { response in
//                debugPrint(response.debugDescription)
                if let res = response.value{
                    if let finalData = res{
                        let decoder = JSONDecoder()
                        do{
                            
                            if(self.pageNo == 1){
                            self.productListModel = try decoder.decode(ProductsModel.self, from: finalData)
                            
                            self.success = self.productListModel?.success ?? 0
                            }
                            else if(self.success != 0 && self.pageNo > 1){
                                let temp = try decoder.decode(ProductsModel.self, from: finalData)
                                self.success = temp.success
                            }
                            print("\(self.pageNo) \(self.success)")
                            self.pageNo = self.pageNo + 1
                            if self.success == 0{
                                return
                            }
                            
                            
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
