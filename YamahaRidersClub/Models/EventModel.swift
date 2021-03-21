//
//  EventModel.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 21/3/21.
//

import Foundation

class EventModel {
    init() {
        
    }
    var data: [DataOfArticle] = []
    var baseurl: String?
    var message: String = ""
    var success: Int = 0
}

// MARK: - Datum
struct DataOfArticle {
    
//    init(eventOrganizedBy: String?, imageName: String?, isVideo: String?, articleCategoryName: String?, eventDetailsInfo: String?, eventLocationLongatude: String?, isImage: String?, youtubeVideoLink: String?, articleEndDate: String?, eventLocation: String?, articleStartDate: String?, articleName: String?, articleID: String?, authorBy: String?, eventLocationLattitude: String?, sl: String?, imageCount: String?){
//        self.eventOrganizedBy = eventOrganizedBy
//        self.imageName = imageName
//        self.isVideo = isVideo
//        self.articleCategoryName = articleCategoryName
//        self.eventDetailsInfo = eventDetailsInfo
//        self.eventLocationLongatude = eventLocationLongatude
//        self.isImage = isImage
//        self.youtubeVideoLink = youtubeVideoLink
//        self.articleEndDate = articleEndDate
//        self.eventLocation = eventLocation
//        self.articleStartDate = articleStartDate
//        self.articleName = articleName
//        self.articleID = articleID
//        self.authorBy = authorBy
//        self.eventLocationLattitude = eventLocationLattitude
//        self.sl = sl
//        self.imageCount = imageCount
//    }
//
    var eventOrganizedBy, imageName, isVideo, articleCategoryName: String?
    var eventDetailsInfo, eventLocationLongatude, isImage: String?
    var youtubeVideoLink: String?
    var articleEndDate, eventLocation, articleStartDate, articleName: String?
    var articleID, authorBy, eventLocationLattitude, sl: String?
    var imageCount: String?

}
