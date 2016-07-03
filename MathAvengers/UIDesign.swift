//
//  UIDesign.swift
//  MathAvengers
//
//  Created by SeoDongHee on 2016. 6. 20..
//  Copyright © 2016년 SeoDongHee. All rights reserved.
//

import UIKit

class UIDesign {
    
    let colors = [
        UIColor(red: 1, green: 0, blue: 0, alpha: 0.5),
        UIColor(red: 1, green: 0.5, blue: 0, alpha: 0.5),
        UIColor(red: 1, green: 1, blue: 0, alpha: 0.5),
        UIColor(red: 0, green: 1, blue: 0, alpha: 0.5),
        UIColor(red: 0, green: 0, blue: 1, alpha: 0.5),
        UIColor(red: 0.5, green: 0, blue: 1, alpha: 0.5),
        UIColor(red: 0.5, green: 0, blue: 0.5, alpha: 0.5),
        UIColor.whiteColor()
    ]
    
    
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
    
    func setViewLayout(view: UIView, color: Int?) {
        if let col = color where col < colors.count {
            view.backgroundColor = colors[col]
        }
        view.layer.cornerRadius = 30
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.blackColor().CGColor
    }
}