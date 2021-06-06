//
//  ProductListViewController.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 28/3/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProductListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var pageNo: Int = 1
    var success: Int = 1
//    var productListModel: ProductsModel?
    @IBOutlet weak var tableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProductsModel.productInfo.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ProductListDetailViewController" ) as! ProductListDetailViewController
        ProductsModel.activeSelectionIndex = indexPath.row
        self.navigationController?.pushViewController(vc,
        animated: true)
        
        print(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductsListTableViewCell") as? ProductsListTableViewCell
        let urlString = "http://dashboard.acigroup.info/yca/\(ProductsModel.productInfo[indexPath.row].image ?? "assets/img/medium/R15%20V3-1.png")"
        print(urlString)
        let urlData = URL(string: urlString) ?? URL(string: "http://dashboard.acigroup.info/yca/assets/img/medium/R15%20V3-1.png")!
//        cell?.productImage.loadImge(withUrl: urlData)
        
        cell?.productImage.downloaded(from: urlString.replacingOccurrences(of: " ", with: "%20"))
//        DispatchQueue.global().async { [weak self] in
//                if let data = try? Data(contentsOf: urlData) {
//                    if let image = UIImage(data: data) {
//                        DispatchQueue.main.async {
//                            cell?.productImage.image = image
//                        }
//                    }
//                }
//            }
        cell?.productName.text = ProductsModel.productInfo[indexPath.row].productName
        
        return cell ?? UITableViewCell()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.pageNo = 1
        self.success = 1
        title = "Products"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
//        for k in 1...4{
        grabBikeProducts()
            
            
//        }
    }
    deinit {
        ProductsModel.productInfo = []
    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        ProductsModel.productInfo = []
//        grabBikeProducts()
//
//    }
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        ProductsModel.productInfo = []
//    }
    
    

    func grabBikeProducts(){
        print("K")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            AF.request("http://dashboard.acigroup.info/apps/yamahacustomerarsenal/product/getproduct?categoryname=\("Bikes")&page=\(self.pageNo)").response { response in
             
                switch response.result{
                    case .success(let value):
                        let json = JSON(value)
                        print(json)
                        if(json["success"]==0){
                            print("Not Ok")
                            return
                            
                        }
                        else{
                            let dataLoop = json["product_info"]
                            
                            for i in 0 ... dataLoop.count-1{
                          
                                let product = ProductInfo(sl: json["product_info"][i]["SL"].string ?? "", productID: json["product_info"][i]["ProductID"].string ?? "", categoryName: json["product_info"][i]["CategoryName"].string ?? "", productName: json["product_info"][i]["ProductName"].string ?? "", price: json["product_info"][i]["Price"].string ?? "", productInfoDescription: json["product_info"][i]["Description"].string ?? "", entryBy: json["product_info"][i]["EntryBy"].string ?? "", entryDate: json["product_info"][i]["EntryDate"].string ?? "", active: json["product_info"][i]["Active"].string ?? "", imageID: json["product_info"][i]["ImageID"].string ?? "", image: json["product_info"][i]["Image"].string ?? "", defaultImage: json["product_info"][i]["DefaultImage"].string ?? "")
                                ProductsModel.productInfo.append(product)
                            }
                            self.pageNo = self.pageNo + 1
                            self.grabBikeProducts()
                        }
                case .failure:
                    print("Fail")
                }
                self.tableView.reloadData()
//                let json = JSON(value)
//                print(json)
//
//                if let res = response.value{
//                    if let finalData = res{
//                        let decoder = JSONDecoder()
//                        do{
//
//                            if(self.pageNo == 1){
//                            self.productListModel = try decoder.decode(ProductsModel.self, from: finalData)
//
//                            self.success = self.productListModel?.success ?? 0
//                            }
//                            else if(self.success != 0 && self.pageNo > 1){
//                                let temp = try decoder.decode(ProductsModel.self, from: finalData)
//                                self.success = temp.success
//                            }
//                            print("\(self.pageNo) \(self.success)")
//                            self.pageNo = self.pageNo + 1
//                            if self.success == 0{
//                                return
//                            }
//
//
//                            self.tableView.reloadData()
//                        }
//                        catch{
//                            print(error)
//                        }
//
//                    }
//                }
            }
        }
    }

}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleToFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleToFill) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
