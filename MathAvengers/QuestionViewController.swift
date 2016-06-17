//
//  QuestionViewController.swift
//  MathAvengers
//
//  Created by SeoDongHee on 2016. 6. 16..
//  Copyright © 2016년 SeoDongHee. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {
    
    var qLabel: UILabel!
    var a1Button: UIButton!
    var a2Button: UIButton!
    var a3Button: UIButton!
    var a4Button: UIButton!
    var aButton: [UIButton] = [UIButton(), UIButton(), UIButton(), UIButton()]
    
    let statusBarHeight: CGFloat = 20.0
    
    var correctAnswer: UInt32 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initUIs()
        
        //setActions()
        
        makeQuestionLevel1()
    }
    
    func setActions() {
        // TouchUpInside
        a1Button.addTarget(self, action: #selector(QuestionViewController.aButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        a2Button.addTarget(self, action: #selector(QuestionViewController.aButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        a3Button.addTarget(self, action: #selector(QuestionViewController.aButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        a4Button.addTarget(self, action: #selector(QuestionViewController.aButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        // 버튼을 눌렀을 때
        a1Button.addTarget(self, action: #selector(QuestionViewController.aButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        a2Button.addTarget(self, action: #selector(QuestionViewController.aButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        a3Button.addTarget(self, action: #selector(QuestionViewController.aButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        a4Button.addTarget(self, action: #selector(QuestionViewController.aButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func makeQuestionLevel1() {
        // 레벨 1: 합이 10 이하의 덧셈 문제
        
        let p1 = arc4random_uniform(10)
        let p2 = arc4random_uniform(10 - p1)
        qLabel.text = "\(p1) + \(p2) = ?"
        correctAnswer = p1 + p2

    }
    
    func initUIs() {

        let viewFrame = self.view.frame
        let viewFrameInset:CGFloat = 10.0
        let qLabelWidth = round(viewFrame.width - (viewFrameInset * 2))
        let qLabelHeight = round((viewFrame.height - (viewFrameInset * 2)) / 2 - viewFrameInset)
        let qLabelFrame = CGRectMake(viewFrameInset, statusBarHeight + viewFrameInset, qLabelWidth, qLabelHeight)
        qLabel = UILabel(frame: qLabelFrame)
        qLabel.text = "TEST"
        qLabel.font = qLabel.font.fontWithSize(100)
        setDesignForLabel(qLabel)
        self.view.addSubview(qLabel)
        
        let aLabelWidth = floor(qLabelWidth / 2) - viewFrameInset
        let aLabelHeight = floor(qLabelHeight / 2) - (viewFrameInset * 2)
        
        let aButtonFrame: [CGRect] = [
            CGRectMake(viewFrameInset, statusBarHeight + viewFrameInset + qLabelHeight + (viewFrameInset * 2), aLabelWidth, aLabelHeight),
            CGRectMake(viewFrameInset + aLabelWidth + (viewFrameInset * 2), statusBarHeight + viewFrameInset + qLabelHeight + (viewFrameInset * 2), aLabelWidth, aLabelHeight),
            CGRectMake(viewFrameInset, statusBarHeight + viewFrameInset + qLabelHeight + (viewFrameInset * 4) + aLabelHeight, aLabelWidth, aLabelHeight),
            CGRectMake(viewFrameInset + aLabelWidth + (viewFrameInset * 2), statusBarHeight + viewFrameInset + qLabelHeight + (viewFrameInset * 4) + aLabelHeight, aLabelWidth, aLabelHeight)
        ]
        
        for ii in 0...3 {
            aButton[ii] = UIButton(frame: aButtonFrame[ii])
            setDesignForButton(aButton[ii])
            self.view.addSubview(aButton[ii])
        }
        
        debugPrint("setLabels: qLabel.bounds=\(qLabel.bounds)")
        debugPrint("setLabels: qLabel.frame=\(qLabel.frame)")
        
        loadViewIfNeeded()
    }
    
    func setDesignForButton(aButton: UIButton) {
        //aLabel = self.view.center
        aButton.setTitle("ANSWER", forState: .Normal)
        aButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        aButton.titleLabel?.font = aButton.titleLabel?.font.fontWithSize(40)
        //aButton.textAlignment = .Center
        aButton.layer.cornerRadius = 10
        aButton.layer.borderWidth = 3
        aButton.layer.borderColor = UIColor.blackColor().CGColor
        aButton.clipsToBounds = true
        aButton.backgroundColor = UIColor.lightGrayColor()
        aButton.translatesAutoresizingMaskIntoConstraints = true
    }
    
    func setDesignForLabel(aLabel: UILabel) {
        //aLabel = self.view.center
        aLabel.textAlignment = .Center
        aLabel.layer.cornerRadius = 10
        aLabel.layer.borderWidth = 3
        aLabel.layer.borderColor = UIColor.blackColor().CGColor
        aLabel.clipsToBounds = true
        aLabel.backgroundColor = UIColor.lightGrayColor()
        aLabel.translatesAutoresizingMaskIntoConstraints = true
    }
    
    func checkAnswer(sender:UIButton!) {
        
    }
    
    
    func aButtonPressed(sender:UIButton!) {
        print("\(sender.titleLabel?.text) Button Clicked")
        if sender == a1Button {
            
        }
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
