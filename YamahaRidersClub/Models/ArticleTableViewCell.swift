//
//  ArticleTableViewCell.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 21/3/21.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var monthOfEvent: UILabel!
    @IBOutlet weak var dayOfEvent: UILabel!
    @IBOutlet weak var articleNameLabel: UILabel!
    @IBOutlet weak var articleStartEndDate: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var youtubeVideoLinkBtn: UIButton!
    @IBOutlet weak var eventDetailsInfoLabel: UILabel!
    @IBOutlet weak var articleAuthor: UILabel!
    @IBOutlet weak var imageOfLocation: UIImageView!
    var urlOfYouTube: String!
    
    @IBAction func youtubeButtonOnPress(_ sender: Any) {
        print("ok")
        UIApplication.shared.openURL(NSURL(string: urlOfYouTube)! as URL)
    }
    
}
