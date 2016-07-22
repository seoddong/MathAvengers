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
    let welcomeImage = [UIImage(named:"welcome"), UIImage(named:"owl_small")]
    let welcomeLabel = [UILabel()]
    var labelText = ["환영합니다!", "     지금 게임을 시작할래요!     ", "     다른 이름을 선택할래요!     ", "     새로운 이름을 사용할래요!     ", "     클라우드 데이터 가져오기     "]
    let introButton = [UIButton(), UIButton(), UIButton(), UIButton()]
    
    var userName = ""

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    override func viewWillAppear(animated: Bool) {
      
        let realms = Realms()
        let results = realms.retreiveCurrentTB_USER()
        if results.count == 0 {
            // 생성해놓은 캐릭터가 없다
            debugPrint("생성해놓은 캐릭터가 없다")
            labelText[0] = "\(labelText[0])"
        }
        else {
            userName = results[0].userName
            NSUserDefaults.standardUserDefaults().setObject(results[0].userName, forKey: "userName")
            labelText[0] = "\(userName)님! 환영합니다!"
        }
        
        setupUI()
        
        if userName.isEmpty {
            introButton[0].hidden = true
            introButton[1].hidden = true
        }
        else {
            introButton[0].hidden = false
            introButton[1].hidden = false
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - setupUI
    func setupUI() {
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        //  Navi Bar
        self.title = "Intro"
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "이전 단계로", style: .Plain, target: self, action: #selector(self.leftBarButtonPressed))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "세팅", style: .Plain, target: self, action: #selector(settingGame))
        
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
            welcomeLabel[ii].text = labelText.first!
            //welcomeLabel[ii].backgroundColor = UIColor.yellowColor()
        }
        
        // buttons
        for ii in 0 ..< introButton.count {
            
            introButton[ii].translatesAutoresizingMaskIntoConstraints = false
            introButton[ii].setTitle(labelText[ii+1], forState: .Normal)
            uidesign.setTextButton(introButton[ii], fontColor: UIColor.blueColor(), fontSize: 30)
            introButton[ii].addTarget(self, action: #selector(blink), forControlEvents: UIControlEvents.TouchDown)
        }

        introButton[0].addTarget(self, action: #selector(startGame), forControlEvents: UIControlEvents.TouchUpInside)
        introButton[1].addTarget(self, action: #selector(selectOtherName), forControlEvents: UIControlEvents.TouchUpInside)
        introButton[2].addTarget(self, action: #selector(createNewname), forControlEvents: UIControlEvents.TouchUpInside)
        introButton[3].addTarget(self, action: #selector(getCloud), forControlEvents: UIControlEvents.TouchUpInside)

        
        stackViews[0].addArrangedSubview(welcomeImageView[0])
        stackViews[0].addArrangedSubview(welcomeLabel[0])
        _ = introButton.map({stackViews[0].addArrangedSubview($0)})
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
    func settingGame() {
        debugPrint(settingGame)
        let setGame = SetEnvViewController()
        self.navigationController?.pushViewController(setGame, animated: true)
    }
    
    func startGame(sender: UIButton!) {
        debugPrint(startGame)
        let start = MainViewController()
        self.navigationController?.pushViewController(start, animated: true)
    }
    
    func selectOtherName(sender: UIButton!) {
        debugPrint(selectOtherName)
        let users = UsersViewController()
        self.navigationController?.pushViewController(users, animated: true)
    }
    
    func createNewname(sender: UIButton!) {
        debugPrint(createNewname)
        let settings = SettingsViewController()
        self.navigationController?.pushViewController(settings, animated: true)
    }
    
    func getCloud(sender: UIButton!) {
        debugPrint(getCloud)
        let cloud = CloudViewController()
        cloud.command = CloudViewController.commandType.downloadWithReturn
        self.navigationController?.pushViewController(cloud, animated: true)
    }
    
    func blink(sender: UIButton!) {
        sender.backgroundColor = UIColor.yellowColor()
        
        // 잠시 후에 배경색 원복
        let seconds = 0.1
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            sender.backgroundColor = UIColor.whiteColor()
        })
        
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
