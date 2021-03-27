//
//  DealerModel.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 27/3/21.
//

import Foundation

struct DealerModel: Codable {
    let data: [DealerModelDatum]
    let msg, msgtype: String
}

// MARK: - Datum
struct DealerModelDatum: Codable {
    let dealerPointID, dealerPointName: String
    let dealerType: String
    let address, district, latitude, longitude: String
    let active: String

    enum CodingKeys: String, CodingKey {
        case dealerPointID = "DealerPointID"
        case dealerPointName = "DealerPointName"
        case dealerType = "DealerType"
        case address = "Address"
        case district = "District"
        case latitude = "Latitude"
        case longitude = "Longitude"
        case active = "Active"
    }
}
