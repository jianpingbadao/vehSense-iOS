//
//  SetupTableViewCell.swift
//  vehsense
//
//  Created by Brian Green on 6/21/18.
//  Copyright © 2018 Weida Zhong. All rights reserved.
//

import UIKit

class SetupTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var optionSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
