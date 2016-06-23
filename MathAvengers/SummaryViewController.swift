//
//  SummaryViewController.swift
//  MathAvengers
//
//  Created by SeoDongHee on 2016. 6. 20..
//  Copyright © 2016년 SeoDongHee. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController {
    
    let showLogSegueIdentifier = "showLogSegueIdentifier"
    
    var finalScore: NSTimeInterval = 0
    var countIncorrectAnswer = 0
    var calledTitle = ""
    var message = ["이런~ 3번 틀렸네요.\n다음엔 좀 더 잘 할 수 있을 거에요.", "음~ 두 번 틀렸네요.\n하지만 잘 했어요~", "오~ 하나 밖에 안 틀렸어요.\n이 정도면 훌륭해요!!", "와우! 모두 다 정답!\n최고로 잘 했어요!"]
    
    var stackView: UIStackView!
    var levelLabel: UILabel!
    var scoreLabel: UILabel!
    var messageLabel: UILabel!
    var showLogButton: UIButton!
    var imageView: UIImageView!
    
    let uidesign = UIDesign()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        setActions()

    }
    
    func setupUI() {
        
        //Navi Bar
        self.title = "Math Avengers - Summary"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "처음으로", style: .Plain, target: self, action: #selector(self.leftBarButtonPressed))

        
        levelLabel = UILabel()
        levelLabel.text = "도전 단계: \(calledTitle)"
        uidesign.setLabelLightGrayWithBorder(levelLabel, fontSize: 40)
        levelLabel.heightAnchor.constraintEqualToConstant(80).active = true
        
        scoreLabel = UILabel()
        scoreLabel.text = "최종 점수: \(String(round(finalScore * 10)/10))"
        uidesign.setLabelLightGrayWithBorder(scoreLabel, fontSize: 40)
        scoreLabel.heightAnchor.constraintEqualToConstant(80).active = true
        
        messageLabel = UILabel()
        messageLabel.lineBreakMode = .ByWordWrapping
        messageLabel.numberOfLines = 2
        messageLabel.text = message[countIncorrectAnswer]
        uidesign.setLabelLightGrayWithBorder(messageLabel, fontSize: 40)
        messageLabel.heightAnchor.constraintEqualToConstant(200).active = true
        
        showLogButton = UIButton()
        showLogButton.setTitle("내가 푼 문제 보기", forState: .Normal)
        uidesign.setButtonLightGrayWithBorder(showLogButton, fontSize: 40)
        
        imageView = UIImageView(image: UIImage(named: "010"))
        //imageView.frame.size = CGSizeMake(imageView.frame.width, imageView.frame.height / 2)
        imageView.heightAnchor.constraintEqualToConstant(400).active = true
        
        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(levelLabel)
        stackView.addArrangedSubview(scoreLabel)
        stackView.addArrangedSubview(messageLabel)
        stackView.addArrangedSubview(showLogButton)
        stackView.addArrangedSubview(imageView)
        
        stackView.axis = .Vertical
        stackView.distribution = .EqualSpacing
        stackView.alignment = .Fill
        self.view.addSubview(stackView)
        let viewsDictionary = ["stackView": stackView]
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[stackView]-20-|", options: .AlignAllCenterY, metrics: nil, views: viewsDictionary))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-\((self.navigationController?.navigationBar.frame.size.height)! + 40)-[stackView]-20-|", options: .AlignAllCenterX, metrics: nil, views: viewsDictionary))
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)

    }
    
    func setActions() {
        
        showLogButton.addTarget(self, action: #selector(self.showLogTouchUpInside(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    

    func leftBarButtonPressed(sender: UIBarButtonItem){
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func showLogTouchUpInside(sender: UIButton) {
        sender.backgroundColor = UIColor.orangeColor()
        
        performSegueWithIdentifier(showLogSegueIdentifier, sender: self)

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
