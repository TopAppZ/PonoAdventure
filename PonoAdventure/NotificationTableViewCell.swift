//
//  NotificationTableViewCell.swift
//  PonoAdventure
//
//  Created by Ria and Dev on 16/02/17.
//  Copyright © 2017 Agileinf. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var notificationText: UILabel!
    @IBOutlet weak var timeIntervalText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
