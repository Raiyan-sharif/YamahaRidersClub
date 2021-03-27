//
//  OfferModel.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 27/3/21.
//

import Foundation


struct OfferModel: Codable {
    let success: Bool
    let data: [OfferModelDatum]
    let baseurl: String
    let message: String
    let perPage: Int

    enum CodingKeys: String, CodingKey {
        case success, data, baseurl, message
        case perPage = "per_page"
    }
}

// MARK: - Datum
struct OfferModelDatum: Codable {
    let offerID, offerName, offerDetails, offerImage: String
    let expireDate: String

    enum CodingKeys: String, CodingKey {
        case offerID = "OfferID"
        case offerName = "OfferName"
        case offerDetails = "OfferDetails"
        case offerImage = "OfferImage"
        case expireDate = "ExpireDate"
    }
}
