//
//  ProductsModel.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 28/3/21.
//

import Foundation

class ProductsModel{
    static var productInfo: [ProductInfo] = []
    static var productid = 58
    static var activeSelectionIndex = 0
}

// MARK: - ProductInfo
struct ProductInfo{
    let sl, productID, categoryName, productName: String
    let price, productInfoDescription, entryBy, entryDate: String
    let active, imageID, image, defaultImage: String
  
}
