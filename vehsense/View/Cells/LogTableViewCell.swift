//
//  LogTableViewCell.swift
//  vehsense
//
//  Created by Brian Green on 7/16/18.
//  Copyright © 2018 Weida Zhong. All rights reserved.
//

import UIKit

class LogTableViewCell: UITableViewCell {

    @IBOutlet weak var sessionTimestamp: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
