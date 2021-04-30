//
//  ProductListDetailView.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 29/4/21.
//

import UIKit
import Photos
import Alamofire
import SwiftyJSON

class ProductListDetailViewController: UIViewController
{
    
    
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var pageViewController: UIPageControl!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var featureLabel: UILabel!
    @IBOutlet weak var specificationLabel: UILabel!
    
    
    
    
   
    
    var featureList:[String] = []
    var specificationList:[String] = []
    
    var urlToGetImageDetails = "http://dashboard.acigroup.info/apps/yamahacustomerarsenal/product/getproductdetails?productid=\(ProductsModel.productid)"
    /*
     "http://dashboard.acigroup.info/yca/assets/img/medium/132032621_3421792221262659_8457206876493126947_n_(1)_medium-800x800.png",
     "http://dashboard.acigroup.info/yca/assets/img/medium/136541176_3709780029105130_764696159298926066_n_medium-800x800.png",
     "http://dashboard.acigroup.info/yca/assets/img/medium/142032854_5120198814689287_7256142203356588508_n_medium-800x800.png",
     "http://dashboard.acigroup.info/yca/137871771_3991968927504583_4510368679345436491_n_medium-800x800.png"
     */
    var imageUrlList:[String] = [
        
    ]
    var time = Timer()
    var count = 0
//
    func fetchDataForProfile(){
        let urlString = "http://dashboard.acigroup.info/apps/yamahacustomerarsenal/product/getproductdetails?productid=\(ProductsModel.productInfo[ProductsModel.activeSelectionIndex].productID)"
        print(urlString)
        DispatchQueue.main.async{
            AF.request(urlString).response { (response) in
              
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    
                    print(json["ProductImage"])
                    let images = json["ProductImage"]
                    for i in 0 ... images.count - 1{
                        self.imageUrlList.append("http://dashboard.acigroup.info/yca/\(json["ProductImage"][i]["Image"].string ?? "")")
                    }
                    let feature = json["Features"]
                    if(feature.count > 0){
                        for i in 0 ... feature.count-1{
                            self.featureLabel.text = (self.featureLabel.text ?? "") +
                            "\n\(json["Features"][i]["FeatureName"].string ?? "")"
                            
                            self.featureList.append(json["Features"][i]["FeatureName"].string ?? "")
                        }
                    }
                    
                    
                    let specification = json["Specifications"]
                    if(specification.count > 0){
                        for i in 0 ... specification.count-1{
                            self.specificationLabel.text = (self.specificationLabel.text ?? "") + "\nSpecification Type:\n\(json["Specifications"][i]["SpecificationType"].string ?? "")\nSpecification Name:\n\(json["Specifications"][i]["SpecificationName"].string ?? "")\nSpecification Value:\n\(json["Specifications"][i]["SpecificationValue"].string ?? "")\n"
                            self.specificationList.append("\nSpecification Type: \(json["Specifications"][i]["SpecificationType"].string ?? "")\n Specification Name: \(json["Specifications"][i]["SpecificationName"].string ?? "")\n SpecificationValue: \(json["Specifications"][i]["SpecificationValue"].string ?? "")\n")
                        }
                    }
                    
                    
                    self.sliderCollectionView.reloadData()
                    
                
                case .failure(let error):
                    print(error.localizedDescription)
                    
                }
            
            }
            
        }
    }
    deinit {
        imageUrlList = []
        featureList = []
        specificationList = []
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        pageViewController.numberOfPages = imageUrlList.count
        pageViewController.currentPage = 0
        
        fetchDataForProfile()
        productNameLabel.text = ProductsModel.productInfo[ProductsModel.activeSelectionIndex].productName
        descriptionLabel.text = ProductsModel.productInfo[ProductsModel.activeSelectionIndex].productInfoDescription
        priceLabel.text = "Price: Tk\(ProductsModel.productInfo[ProductsModel.activeSelectionIndex].price)"
        
        
        DispatchQueue.main.async {
            self.time = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
        
        
    }
    
    
    @objc func changeImage(){
        if count < imageUrlList.count{
            let index = IndexPath.init(item: count, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageViewController.currentPage = count
            count += 1
        }
        else{
            count = 0
            let index = IndexPath.init(item: count, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageViewController.currentPage = count
        }
    }
}


extension ProductListDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrlList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImageDetailsCollectionViewCell", for: indexPath) as! ProductImageDetailsCollectionViewCell
//        cell.productImage.image = imageList[indexPath.row]
        let urlData = URL(string: imageUrlList[indexPath.row]) ?? URL(string: "http://dashboard.acigroup.info/yca/assets/img/medium/R15%20V3-1.png")!
        print("ok")
        cell.productImage.loadImge(withUrl: urlData)
        print(indexPath.row)
        
        return cell
    }
    
    
}

extension ProductListDetailViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = sliderCollectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
