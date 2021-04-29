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
    var imageList:[UIImage] = []
    
    var urlToGetImageDetails = "http://dashboard.acigroup.info/apps/yamahacustomerarsenal/product/getproductdetails?productid=\(ProductsModel.productid)"
    
    var imageUrlList = [
        "http://dashboard.acigroup.info/yca/assets/img/medium/132032621_3421792221262659_8457206876493126947_n_(1)_medium-800x800.png",
        "http://dashboard.acigroup.info/yca/assets/img/medium/136541176_3709780029105130_764696159298926066_n_medium-800x800.png",
        "http://dashboard.acigroup.info/yca/assets/img/medium/142032854_5120198814689287_7256142203356588508_n_medium-800x800.png",
        "http://dashboard.acigroup.info/yca/137871771_3991968927504583_4510368679345436491_n_medium-800x800.png"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
//        cell?.productImage.loadImge(withUrl: urlData)
        for i in 0 ... imageUrlList.count-1{
            let urlData = URL(string: imageUrlList[i]) ?? URL(string: "http://dashboard.acigroup.info/yca/assets/img/medium/R15%20V3-1.png")!
            DispatchQueue.global().async { [weak self] in
                    if let data = try? Data(contentsOf: urlData) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self?.imageList.append(image)
                            }
                        }
                    }
                }
        }
    }
}


extension ProductListDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductListDetailViewCell", for: indexPath)
        
        if let vc = cell.viewWithTag(111) as? UIImageView{
            print("Here")
            vc.image = imageList[indexPath.row]
        }
        else if let ab = cell.viewWithTag(222) as? UIPageControl{
            print("There")
            ab.currentPage = indexPath.row
        }
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
