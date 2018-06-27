//
//  BluetoothTableViewCell.swift
//  vehsense
//
//  Created by Brian Green on 6/24/18.
//  Copyright © 2018 Weida Zhong. All rights reserved.
//

import UIKit

class BluetoothTableViewCell: UITableViewCell {

    @IBOutlet weak var deviceName: UILabel!
    @IBOutlet weak var connectionStatusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
