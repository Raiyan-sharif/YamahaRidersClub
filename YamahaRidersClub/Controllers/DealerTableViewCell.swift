//
//  DealerTableViewCell.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 27/3/21.
//

import UIKit

class DealerTableViewCell: UITableViewCell {

    @IBOutlet weak var dealerName: UILabel!
    @IBOutlet weak var dealerType: UILabel!
    @IBOutlet weak var dealerAdress: UILabel!
    var urlToGoTo: String!

    @IBAction func tappedOnMap(_ sender: UIButton) {
        UIApplication.shared.openURL(NSURL(string: urlToGoTo)! as URL)
    }
    
}
