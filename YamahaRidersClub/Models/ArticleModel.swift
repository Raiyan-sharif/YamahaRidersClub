//
//  ArticleModel.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 18/3/21.
//

import Foundation

// MARK: - ArticleModel
struct ArticleModel: Codable {
    let baseurl: String
    let message: String
    let data: [ArticleModelDatum]
    let success: Int
}

// MARK: - ArticleModelDatum
struct ArticleModelDatum: Codable {
    let articleID, articleStartDate, sl, isVideo: String
    let eventOrganizedBy: String
    let youtubeVideoLink: String
    let eventLocation, authorBy, articleName, imageName: String
    let articleCategoryName, isImage, eventLocationLattitude, imageCount: String
    let articleEndDate, eventLocationLongatude, eventDetailsInfo: String

    enum CodingKeys: String, CodingKey {
        case articleID = "ArticleId"
        case articleStartDate = "ArticleStartDate"
        case sl = "SL"
        case isVideo = "IsVideo"
        case eventOrganizedBy = "EventOrganizedBy"
        case youtubeVideoLink = "YoutubeVideoLink"
        case eventLocation = "EventLocation"
        case authorBy = "AuthorBy"
        case articleName = "ArticleName"
        case imageName = "ImageName"
        case articleCategoryName = "ArticleCategoryName"
        case isImage = "IsImage"
        case eventLocationLattitude = "EventLocationLattitude"
        case imageCount = "ImageCount"
        case articleEndDate = "ArticleEndDate"
        case eventLocationLongatude = "EventLocationLongatude"
        case eventDetailsInfo = "EventDetailsInfo"
    }
}
