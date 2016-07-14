//
//  IntroViewController.swift
//  MathAvengers
//
//  Created by SeoDongHee on 2016. 7. 11..
//  Copyright © 2016년 SeoDongHee. All rights reserved.
//

import UIKit
import RealmSwift

class IntroViewController: UIViewController {
    
    let uidesign = UIDesign()
    
    // views
    let stackViews = [UIStackView()]
    let welcomeImageView = [UIImageView(), UIImageView()]
    let welcomeImage = [UIImage(named:"welcome"), UIImage(named:"owl"), UIImage(named: "start"), UIImage(named: "newname")]
    let welcomeLabel = [UILabel(), UILabel(), UILabel()]
    var labelText = ["환영합니다!", "지금 게임을 시작할까요?", "새로운 이름을 사용할래요?"]
    let okButton = UIButton(), cancelButton = UIButton()
    
    var userName = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        let realms = Realms()
        let results = realms.retreiveTB_USER()
        if results.count == 0 {
            // 생성해놓은 캐릭터가 없다
            debugPrint("생성해놓은 캐릭터가 없다")
            labelText[0] = "\(labelText[0])"
        }
        else {
            userName = results[0].userName
            labelText[0] = "\(userName)님! \(labelText[0])"
        }
        
        setupUI()
        
        if userName.isEmpty {
            welcomeLabel[1].hidden = true
            okButton.hidden = true
        }
    }
    
    func setupUI() {
        
        //  Navi Bar
        self.title = "Math Avengers - Intro"
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "이전 단계로", style: .Plain, target: self, action: #selector(self.leftBarButtonPressed))
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "다음 단계로", style: .Plain, target: self, action: #selector(self.nextButtonPressed))
        
        // Welcome Image
        for ii in 0 ..< welcomeImageView.count {
            welcomeImageView[ii].image = welcomeImage[ii]
            welcomeImageView[ii].translatesAutoresizingMaskIntoConstraints = false
            welcomeImageView[ii].backgroundColor = UIColor.whiteColor()
            welcomeImageView[ii].contentMode = .ScaleAspectFit
            self.view.addSubview(welcomeImageView[ii])
        }
        
        
        // welcome Text
        for ii in 0 ..< welcomeLabel.count {
            welcomeLabel[ii].translatesAutoresizingMaskIntoConstraints = false
            uidesign.setLabelLayout(welcomeLabel[ii], fontsize: 40)
            welcomeLabel[ii].text = labelText[ii]
            //welcomeLabel[ii].backgroundColor = UIColor.yellowColor()
            self.view.addSubview(welcomeLabel[ii])
        }
        
        // buttons
        okButton.translatesAutoresizingMaskIntoConstraints = false
        okButton.backgroundColor = UIColor.whiteColor()
        okButton.setImage(welcomeImage[2], forState: .Normal)
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.backgroundColor = UIColor.whiteColor()
        cancelButton.setImage(welcomeImage[3], forState: .Normal)
        //uidesign.setButtonLightGrayWithBorder(cancelButton, fontSize: 40)
        
        self.view.addSubview(okButton)
        self.view.addSubview(cancelButton)
        
        let viewsDictionary = ["welcomeImage0": welcomeImageView[0], "welcomeImage1": welcomeImageView[1], "welcomeLabel0": welcomeLabel[0], "welcomeLabel1": welcomeLabel[1], "welcomeLabel2": welcomeLabel[2], "okButton": okButton,  "cancelButton": cancelButton]
        var constraints: [NSLayoutConstraint] = []
        constraints.appendContentsOf(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-[welcomeLabel0]-|",
            options: [], metrics: nil, views: viewsDictionary))
        constraints.appendContentsOf(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-100-[welcomeImage0(\((welcomeImage[0]?.size.height)!))]-[welcomeLabel0(100)]",
            options: [NSLayoutFormatOptions.AlignAllCenterX], metrics: nil, views: viewsDictionary))

        constraints.appendContentsOf(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:[welcomeLabel0]-[welcomeLabel1]-[welcomeLabel2]",
            options: [], metrics: nil, views: viewsDictionary))
        constraints.appendContentsOf(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:[welcomeLabel0]-[okButton(93)]-[cancelButton(==okButton)]",
            options: [], metrics: nil, views: viewsDictionary))
        constraints.appendContentsOf(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-[welcomeLabel1]-[okButton(200)]-|",
            options: [NSLayoutFormatOptions.AlignAllCenterY], metrics: nil, views: viewsDictionary))
        constraints.appendContentsOf(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-[welcomeLabel2]-[cancelButton(==okButton)]-|",
            options: [NSLayoutFormatOptions.AlignAllCenterY], metrics: nil, views: viewsDictionary))

        constraints.appendContentsOf(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:[welcomeLabel2]-[welcomeImage1]|",
            options: [], metrics: nil, views: viewsDictionary))
        constraints.appendContentsOf(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-[welcomeImage1]-|",
            options: [], metrics: nil, views: viewsDictionary))
        
        NSLayoutConstraint.activateConstraints(constraints)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
