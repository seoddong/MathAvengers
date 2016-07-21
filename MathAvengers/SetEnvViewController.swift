//
//  SetEnvironmentViewController.swift
//  MathAvengers
//
//  Created by SeoDongHee on 2016. 7. 19..
//  Copyright © 2016년 SeoDongHee. All rights reserved.
//

import UIKit
import RealmSwift

class SetEnvViewController: UIViewController {
    
    let uidesign = UIDesign()
    let util = Util()
    
    // views
    let stackViews = [UIStackView(), UIStackView()]
    let welcomeImageView = [UIImageView(), UIImageView()]
    let welcomeImage = [UIImage(named:"welcome"), UIImage(named:"owl_small")]
    let welcomeLabel = [UILabel()]
    let welcomeText = ["환경 설정"]
    var labelText = ["     즉시 iCloud에서 데이터 복원!     ", "     자동으로 iCloud에 저장!     "]
    let introButton = [UIButton(), UIButton()]
    let cloudSwitch = UISwitch()
    var userName = ""


    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func switchSync(sender: UISwitch) {
        switch sender {
        case cloudSwitch:
            if NSUserDefaults.standardUserDefaults().boolForKey("iCloudYN") {
                //cloudSwitch.on = true
                cloudSwitch.setOn(true, animated: true)
            }
            else {
                //cloudSwitch.on = false
                cloudSwitch.setOn(false, animated: true)
            }
            break
        default:
            break
        }
    }
    
    
    // MARK: - setupUI
    func setupUI() {
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        //  Navi Bar
        self.title = "환경 설정"
        
        // Welcome Image
        for ii in 0 ..< welcomeImageView.count {
            welcomeImageView[ii].image = welcomeImage[ii]
            welcomeImageView[ii].translatesAutoresizingMaskIntoConstraints = false
            welcomeImageView[ii].backgroundColor = UIColor.whiteColor()
            welcomeImageView[ii].contentMode = .ScaleAspectFit
        }
        
        // welcome Text
        for ii in 0 ..< welcomeLabel.count {
            welcomeLabel[ii].translatesAutoresizingMaskIntoConstraints = false
            uidesign.setLabelLayout(welcomeLabel[ii], fontsize: 40)
            welcomeLabel[ii].text = welcomeText[ii]
            //welcomeLabel[ii].backgroundColor = UIColor.yellowColor()
        }
        
        // buttons
        for ii in 0 ..< introButton.count {
            
            introButton[ii].translatesAutoresizingMaskIntoConstraints = false
            introButton[ii].setTitle(labelText[ii], forState: .Normal)
            uidesign.setTextButton(introButton[ii], fontColor: UIColor.blueColor(), fontSize: 30)
        }
        
        cloudSwitch.translatesAutoresizingMaskIntoConstraints = false
        switchSync(cloudSwitch)
        
//        introButton[0].addTarget(self, action: #selector(startGame), forControlEvents: UIControlEvents.TouchUpInside)
        introButton[1].addTarget(self, action: #selector(saveCloudYN), forControlEvents: UIControlEvents.TouchUpInside)
        cloudSwitch.addTarget(self, action: #selector(saveCloudYN), forControlEvents: UIControlEvents.TouchUpInside)

        
        stackViews[1].addArrangedSubview(introButton[1])
        stackViews[1].addArrangedSubview(cloudSwitch)
        stackViews[1].axis = .Horizontal
        stackViews[1].distribution = UIStackViewDistribution.Fill
        stackViews[1].alignment = .Center
        stackViews[1].spacing = 20
        stackViews[1].translatesAutoresizingMaskIntoConstraints = false
        
        stackViews[0].addArrangedSubview(welcomeImageView[0])
        stackViews[0].addArrangedSubview(welcomeLabel[0])
        stackViews[0].addArrangedSubview(introButton[0])
        stackViews[0].addArrangedSubview(stackViews[1])
        stackViews[0].addArrangedSubview(welcomeImageView[1])
        self.view.addSubview(stackViews[0])
        
        // stackView[0] Layout 설정
        stackViews[0].axis = .Vertical
        stackViews[0].distribution = .EqualSpacing
        stackViews[0].alignment = .Center
        stackViews[0].spacing = 20
        stackViews[0].translatesAutoresizingMaskIntoConstraints = false
        stackViews[0].frame = self.view.frame
        
        let margins = self.view.layoutMarginsGuide
        stackViews[0].leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor).active = true
        stackViews[0].trailingAnchor.constraintEqualToAnchor(margins.trailingAnchor).active = true
        NSLayoutConstraint(item: stackViews[0], attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .TopMargin, multiplier: 1.0, constant: 100.0).active = true
        NSLayoutConstraint(item: stackViews[0], attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .BottomMargin, multiplier: 1.0, constant: -50.0).active = true
        
    }
    
    // MARK: - Actions
    func saveCloudYN() {
        if NSUserDefaults.standardUserDefaults().boolForKey("iCloudYN") {
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "iCloudYN")
        }
        else {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "iCloudYN")
        }
        switchSync(cloudSwitch)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
