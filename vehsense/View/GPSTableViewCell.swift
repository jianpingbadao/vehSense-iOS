//
//  GPSTableViewCell.swift
//  vehsense
//
//  Created by Brian Green on 6/28/18.
//  Copyright © 2018 Weida Zhong. All rights reserved.
//

import UIKit

class GPSTableViewCell: UITableViewCell {

    @IBOutlet weak var settingIcon: UIImageView!
    @IBOutlet weak var settingLabel: UILabel!
    @IBOutlet weak var gpsSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
