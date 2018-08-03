//
//  ExpandedTableViewCell.swift
//  vehsense
//
//  Created by Brian Green on 8/2/18.
//  Copyright © 2018 Weida Zhong. All rights reserved.
//

import UIKit


class ExpandedTableViewCell: UITableViewCell {
    
    let title : UILabel = {
        let label = UILabel()
        label.text = "Frequency"
        label.adjustsFontSizeToFitWidth = true
        label.lineBreakMode = .byClipping
        label.numberOfLines = 1
        return label
    }()
    
    let frequencySegment: UISegmentedControl = {
        let segment = UISegmentedControl()

        segment.insertSegment(withTitle:"20Hz", at: 0, animated: true)
        segment.insertSegment(withTitle: "50Hz", at: 1, animated: true)
        segment.insertSegment(withTitle: "200Hz", at: 2, animated: true)
        
        segment.selectedSegmentIndex = 0
  
        return segment
    }()
    
    

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell(){
        addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        title.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        title.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.3).isActive = true
        
        addSubview(frequencySegment)
        frequencySegment.translatesAutoresizingMaskIntoConstraints = false
        frequencySegment.leadingAnchor.constraint(equalTo: title.layoutMarginsGuide.trailingAnchor).isActive = true
        frequencySegment.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.6).isActive = true
        frequencySegment.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
}
