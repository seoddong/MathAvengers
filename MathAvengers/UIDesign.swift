//
//  UIDesign.swift
//  MathAvengers
//
//  Created by SeoDongHee on 2016. 6. 20..
//  Copyright © 2016년 SeoDongHee. All rights reserved.
//

import UIKit

class UIDesign {
    func setButtonLightGrayWithBorder(aButton: UIButton, fontSize: CGFloat?) {
        if let fontSize = fontSize {
            aButton.titleLabel?.font = aButton.titleLabel?.font.fontWithSize(fontSize)
        }
        aButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        aButton.layer.cornerRadius = 10
        aButton.layer.borderWidth = 3
        aButton.layer.borderColor = UIColor.blackColor().CGColor
        aButton.clipsToBounds = true
        aButton.backgroundColor = UIColor.lightGrayColor()
        aButton.translatesAutoresizingMaskIntoConstraints = true
    }
    
    func setLabelLightGrayWithBorder(aLabel: UILabel, fontSize: CGFloat?) {
        if let fontSize = fontSize {
            aLabel.font = aLabel.font.fontWithSize(fontSize)
        }
        aLabel.textAlignment = .Center
        aLabel.layer.cornerRadius = 10
        aLabel.layer.borderWidth = 3
        aLabel.layer.borderColor = UIColor.blackColor().CGColor
        aLabel.clipsToBounds = true
        aLabel.backgroundColor = UIColor.lightGrayColor()
        aLabel.translatesAutoresizingMaskIntoConstraints = true
    }
}