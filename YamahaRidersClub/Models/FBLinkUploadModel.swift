//
//  FBLinkUploadModel.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 8/5/21.
//

import Foundation

struct FBLinkUploadModel: Codable{
    var mobileNo:String
    var fbLink:String
    enum CodingKeys: String, CodingKey{
        case mobileNo = "MobileNo"
        case fbLink = "FacebookIdLink"
    }
}
