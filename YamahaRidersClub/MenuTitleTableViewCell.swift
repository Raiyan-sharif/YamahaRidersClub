//
//  MenuTitleTableViewCell.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 15/3/21.
//

import UIKit

class MenuTitleTableViewCell: UITableViewCell {

    @IBOutlet weak var titleMenuImage: UIImageView!
    @IBOutlet weak var titleAppName: UILabel!
    @IBOutlet weak var appVersionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
