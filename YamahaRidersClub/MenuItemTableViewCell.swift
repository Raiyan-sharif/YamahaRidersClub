//
//  MenuItemTableViewCell.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 15/3/21.
//

import UIKit

class MenuItemTableViewCell: UITableViewCell {
    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var menuItemName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
