//
//  DataViewCollectionViewCell.swift
//  vehsense
//
//  Created by Brian Green on 7/9/18.
//  Copyright © 2018 Weida Zhong. All rights reserved.
//

import UIKit

class DataViewCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionLabel2: UILabel!
    @IBOutlet weak var descriptionLabel3: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        descriptionLabel2.text = ""
        descriptionLabel3.text = ""
    }
}
