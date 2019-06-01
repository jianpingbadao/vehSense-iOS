//
//  SetupTableViewCell.swift
//  vehsense
//
//  Created by Brian Green on 6/21/18.
//  Copyright © 2018 Weida Zhong. All rights reserved.
//

import UIKit

class SetupTableHeaderView: UITableViewHeaderFooterView {
    
    let titleLabel : UILabel = {
        let label = UILabel()
        return label
    }()
    
    let optionSwitch : UISwitch = {
        let tempSwitch = UISwitch()
        return tempSwitch
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout(){
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        
        addSubview(optionSwitch)
        optionSwitch.translatesAutoresizingMaskIntoConstraints = false
        optionSwitch.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        optionSwitch.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
    }
    
}
