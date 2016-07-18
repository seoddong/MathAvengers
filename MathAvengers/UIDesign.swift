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
    
    func setTextFieldLayout(textField: UITextField, fontsize: CGFloat) {
        textField.textAlignment = .Center
        textField.font = UIFont(name: "Verdana", size: fontsize)
        textField.layer.borderColor = UIColor.blackColor().CGColor
        textField.layer.borderWidth = 3
        textField.layer.cornerRadius = 10
        textField.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        textField.clearButtonMode = .WhileEditing
    }
    
    func setLabelLayout(label: UILabel, fontsize: CGFloat) {
        label.textAlignment = .Center
        label.font = UIFont(name: "Verdana", size: fontsize)
        label.layer.cornerRadius = 10
        
    }
    
    
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
    
    func setLabelBubbleGreenWithBorder(aLabel: UILabel, fontSize: CGFloat?) {
        if let fontSize = fontSize {
            aLabel.font = aLabel.font.fontWithSize(fontSize)
        }
        aLabel.textAlignment = .Center
        aLabel.layer.cornerRadius = 10
        aLabel.layer.borderWidth = 3
        aLabel.layer.borderColor = UIColor.blackColor().CGColor
        aLabel.clipsToBounds = true
        aLabel.backgroundColor = UIColor(patternImage: UIImage(named: "bubble_green")!) //UIColor.lightGrayColor()
        aLabel.translatesAutoresizingMaskIntoConstraints = true
    }
    
    func setLabelBubbleGreenSmallWithBorder(aLabel: UILabel, fontSize: CGFloat?) {
        if let fontSize = fontSize {
            aLabel.font = aLabel.font.fontWithSize(fontSize)
        }
        aLabel.textAlignment = .Center
        aLabel.layer.cornerRadius = 10
        aLabel.layer.borderWidth = 0
        aLabel.layer.borderColor = UIColor.blackColor().CGColor
        aLabel.clipsToBounds = true
        aLabel.backgroundColor = UIColor(patternImage: UIImage(named: "bubble_green_small")!) //UIColor.lightGrayColor()
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
    
    func setTextButton(aButton: UIButton, fontColor: UIColor?, fontSize: CGFloat?) {
        if let fontSize = fontSize {
            aButton.titleLabel?.font = aButton.titleLabel?.font.fontWithSize(fontSize)
        }
        if let color = fontColor {
            aButton.setTitleColor(color, forState: .Normal)
        }
        aButton.backgroundColor = UIColor.whiteColor()
        aButton.clipsToBounds = true
        aButton.setTitleShadowColor(UIColor.lightGrayColor(), forState: .Normal)
        aButton.translatesAutoresizingMaskIntoConstraints = true
        aButton.layer.cornerRadius = 5
        
        aButton.layer.shadowRadius = 5
        aButton.layer.shadowColor = UIColor.lightGrayColor().CGColor
        aButton.layer.shadowOffset = CGSizeMake(0, 1)
        aButton.layer.shadowOpacity = 0.5
        aButton.layer.masksToBounds = false
    }
}