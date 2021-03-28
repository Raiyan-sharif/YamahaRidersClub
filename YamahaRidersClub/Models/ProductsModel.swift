//
//  ProductsModel.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 28/3/21.
//

import Foundation

struct ProductsModel: Codable {
    let success: Int
    var productInfo: [ProductInfo]
    let message: String

    enum CodingKeys: String, CodingKey {
        case success
        case productInfo = "product_info"
        case message
    }
}

// MARK: - ProductInfo
struct ProductInfo: Codable {
    let sl, productID, categoryName, productName: String
    let price, productInfoDescription, entryBy, entryDate: String
    let active, imageID, image, defaultImage: String
  

    enum CodingKeys: String, CodingKey {
        case sl = "SL"
        case productID = "ProductID"
        case categoryName = "CategoryName"
        case productName = "ProductName"
        case price = "Price"
        case productInfoDescription = "Description"
        case entryBy = "EntryBy"
        case entryDate = "EntryDate"
        case active = "Active"
        case imageID = "ImageID"
        case image = "Image"
        case defaultImage = "DefaultImage"

    }
}
