//
//  ArticleModel.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 18/3/21.
//

import Foundation

// MARK: - ArticleModel
struct ArticleModel: Codable {
    let success: Int
    let message: String
    let data: [Datum]
    let baseurl: String
}

// MARK: - Datum
//struct DataInModel: Codable {
//    let sl, articleID, articleCategoryName, articleName: String?
//    let articleStartDate, articleEndDate, eventOrganizedBy, eventLocation: String?
//    let eventLocationLattitude, eventLocationLongatude, isImage, imageName: String?
//    let isVideo: String?
//    let youtubeVideoLink: String?
//    let eventDetailsInfo, authorBy, imageCount: String?
//}

