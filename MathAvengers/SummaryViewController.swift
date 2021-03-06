//
//  SummaryViewController.swift
//  MathAvengers
//
//  Created by SeoDongHee on 2016. 6. 20..
//  Copyright © 2016년 SeoDongHee. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController {
    
    var countLife = 3
    var finalScore: NSTimeInterval = 0
    var finalScoreInt: Int {
        if countLife == 0 {
            return 0
        }
        else {
            return Int(abs(round(finalScore * 10000)))
        }
    }
    var calledTitle = ""
    var message = ["Hmm~ Wrong 3 times.\nNext time you can do better.".localize(), "Hmm~ Wrong 2 times.\nBut well done~".localize(), "Oh~ Only one wrong\nYou are very good!!".localize(), "WOW! Perfect!\n You are the BEST!".localize(), "Oh my god~ Spended all the time\nNext time little bit faster.".localize()]
    
    var stackView: UIStackView!
    var levelLabel: UILabel!
    var scoreLabel: UILabel!
    var messageLabel: UILabel!
    var imageView: UIImageView!
    let retryButton = UIButton()
    
    let uidesign = UIDesign()
    
    let userName = NSUserDefaults.standardUserDefaults().objectForKey("userName") as! String
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        // 최종 플레이시간, 최고 기록 갱신
        let realms = Realms()
        realms.updateTB_USER(userName, bestScore: finalScoreInt)
        debugPrint("\(finalScoreInt) \(countLife)")

        // icloud에 저장
        if NSUserDefaults.standardUserDefaults().boolForKey("iCloudYN") {
            let cloud = CloudViewController()
            cloud.initialize()
            cloud.command = CloudViewController.commandType.store
            //self.navigationController?.pushViewController(cloud, animated: true)
            if cloud.storeFile("default.realm") {
                debugPrint("저장 성공")
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - setupUI
    func setupUI() {
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        //Navi Bar
        self.title = "Summary".localize()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Go to the Intro".localize(), style: .Plain, target: self, action: #selector(self.leftBarButtonPressed))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Go to the Log".localize(), style: .Plain, target: self, action: #selector(self.rightBarButtonPressed))

        
        levelLabel = UILabel()
        levelLabel.text = "LEVEL: ".localize() + "\(calledTitle)"
        uidesign.setLabelBubbleGreenSmallWithBorder(levelLabel, fontSize: 40)
        levelLabel.adjustsFontSizeToFitWidth = true
        levelLabel.heightAnchor.constraintEqualToConstant(80).active = true
        
        scoreLabel = UILabel()
        scoreLabel.text = "Final Score: ".localize() + "\(String(finalScoreInt))"
        uidesign.setLabelBubbleGreenSmallWithBorder(scoreLabel, fontSize: 40)
        scoreLabel.heightAnchor.constraintEqualToConstant(80).active = true
        
        messageLabel = UILabel()
        messageLabel.lineBreakMode = .ByWordWrapping
        messageLabel.numberOfLines = 2
        if finalScore > 0 {
            messageLabel.text = message[countLife]
        }
        else {
            messageLabel.text = message.last
        }
        uidesign.setLabelBubbleGreenWithBorder(messageLabel, fontSize: 40)
        messageLabel.backgroundColor = UIColor(patternImage: UIImage(named:"tile001")!)
        messageLabel.heightAnchor.constraintEqualToConstant(200).active = true
        
        let image: UIImage!
        // 시간 초과나 3번 틀리면 OTL
        if countLife == 0 || finalScore <= 0 {
            image = UIImage(named: "otl")
        }
        else if countLife == 3 && finalScore > 0 {
            image = UIImage(named: "awesome")
        }
        else {
            image = UIImage(named: "good")
        }
        imageView = UIImageView(image: image)
        imageView.contentMode = .ScaleAspectFit
        imageView.heightAnchor.constraintEqualToConstant(image.size.height > 250 ? 250 : image.size.height).active = true
        
        
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        retryButton.setTitle("Play one more time".localize(), forState: .Normal)
        uidesign.setTextButton(retryButton, fontColor: UIColor.blueColor(), fontSize: 30)
        retryButton.addTarget(self, action: #selector(retryGame), forControlEvents: UIControlEvents.TouchUpInside)
        
        stackView = UIStackView()
        stackView.spacing = 50
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .Vertical
        stackView.distribution = .EqualSpacing
        stackView.alignment = .Fill
        
        self.view.addSubview(stackView)
        UIView.animateWithDuration(0.75, animations: {
            self.stackView.addArrangedSubview(self.levelLabel)
            self.stackView.addArrangedSubview(self.scoreLabel)
            self.stackView.addArrangedSubview(self.messageLabel)
            self.stackView.addArrangedSubview(self.imageView)
            self.stackView.addArrangedSubview(self.retryButton)
            self.stackView.layoutIfNeeded()
        })
        
        let viewsDictionary = ["stackView": stackView]
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[stackView]-20-|", options: [], metrics: nil, views: viewsDictionary))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-\((self.navigationController?.navigationBar.frame.size.height)! + 40)-[stackView]-20-|", options: [], metrics: nil, views: viewsDictionary))
        
    }

    

    // MARK: - Actions
    func leftBarButtonPressed(sender: UIBarButtonItem){
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func rightBarButtonPressed() {
        let targetView = ShowLogViewController()
        self.navigationController?.pushViewController(targetView, animated: true)

    }
    
    func retryGame() {
        let level = NSUserDefaults.standardUserDefaults().integerForKey("level")
        let levelTitle = NSUserDefaults.standardUserDefaults().stringForKey("levelTitle")
        debugPrint(levelTitle)
        let targetView = QuestionViewController()
        targetView.calledTitle = levelTitle!
        targetView.calledLevel = level
        self.navigationController?.pushViewController(targetView, animated: true)
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
