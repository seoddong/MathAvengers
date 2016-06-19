//
//  QuestionViewController.swift
//  MathAvengers
//
//  Created by SeoDongHee on 2016. 6. 16..
//  Copyright © 2016년 SeoDongHee. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {
    
    // UIs
    var stackView: UIStackView!
    var cancelButton: UIButton!
    var titleLabel, scoreLabel: UILabel!
    var starImageView: [UIImageView] = [UIImageView(), UIImageView(), UIImageView()]
    var qLabel: UILabel!
    var aButton: [UIButton] = [UIButton(), UIButton(), UIButton(), UIButton()]
    
    // Layout
    let statusBarHeight: CGFloat = 20.0
    
    // Utility
    let util = Util()
    
    // 호출됨
    var calledTitle = ""
    var calledLevel = 0
    
    // 채점, 이력 관리
    var correctAnswer: UInt32 = 0
    var answerArray: [UInt32] = []
    var countCorrectAnswer = 0
    var currentLevel = 0
    var gameOver = false
    var startTime = NSDate.timeIntervalSinceReferenceDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initUIs()
        
        setActions()
        
        if calledLevel > 0 {
            currentLevel = calledLevel
            gameOver = false
            makeQuestionLevel(currentLevel)
            
            startTime = NSDate.timeIntervalSinceReferenceDate()
            _ = NSTimer.scheduledTimerWithTimeInterval(
                0.02,
                target: self,
                selector: (#selector(QuestionViewController.displayCollapsedTime(_:))),
                userInfo: nil,
                repeats: true)
        }
        
    }
    
    func displayCollapsedTime(timer: NSTimer)
    {
        
        let timeRemaining = NSDate.timeIntervalSinceReferenceDate() - startTime
        if !gameOver {
            scoreLabel.text = String(format: "%.07f", timeRemaining)
        }
        else{
            timer.invalidate()
            //Force the label to 0.0000000 at the end
            scoreLabel.text = String(format: "%.07f", 0.0)
        }
    }
    
    func setActions() {
        
        cancelButton.addTarget(self, action: #selector(QuestionViewController.cancelTouchUpInside(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        for ii in 0...3 {
            // TouchUpInside
            aButton[ii].addTarget(self, action: #selector(QuestionViewController.aButtonTouchUpInside(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            // 버튼을 눌렀을 때
            aButton[ii].addTarget(self, action: #selector(QuestionViewController.aButtonTouchDown(_:)), forControlEvents: UIControlEvents.TouchDown)
        }

    }
    
    func initSettings() {
        // 보기 초기화
        answerArray.removeAll()
        
        // 보기 버튼 초기화
        for ii in 0...3 {
            aButton[ii].backgroundColor = UIColor.lightGrayColor()
        }
        
    }
    
    func createLevel1() {
        
        // 문제 생성
        let p1 = arc4random_uniform(10)
        let p2 = arc4random_uniform(10 - p1)
        qLabel.text = "\(p1) + \(p2) = ?"
        correctAnswer = p1 + p2
        
        // 보기 배열 생성
        // 같은 보기가 나오면 안 된다.
        var ii = 0
        answerArray.append(correctAnswer)
        while (true) {
            if ii >= 3 {
                break
            }
            let answer = arc4random_uniform(10)
            if answerArray.contains({$0 == answer}) {
                // 이미 같은 보기가 있으므로 loop를 한 번 더 돈다.
                debugPrint("already has \(answer)")
            }
            else {
                
                answerArray.append(answer)
                ii += 1
            }
        }
    }
    
    
    func makeQuestionLevel(level: Int) {
        // 레벨 1: 합이 10 이하의 덧셈 문제
        
        initSettings()
        
        switch level {
        case 1:
            createLevel1()
        default:
            createLevel1()
        }

        // 답 배열 섞기
        let shuffledArray = util.arrayShuffle([0,1,2,3])
        debugPrint("suffledArray=\(shuffledArray)")
        
        // 답 세팅
        for ii in 0...3 {
            aButton[ii].setTitle(String(answerArray[shuffledArray[ii] as! Int]), forState: .Normal)
        }
        

    }
    
    func initUIs() {

        let viewFrame = self.view.frame
        let viewFrameInset:CGFloat = 10.0
        let fullWidth = round(viewFrame.width - (viewFrameInset * 2))
        
        // 취소, 타이틀(레벨), 남은 시간, 별
        let sbHeight:CGFloat = 80
        let stackViewFrame = CGRectMake(viewFrameInset, statusBarHeight + viewFrameInset, fullWidth, sbHeight)
        stackView = UIStackView(frame: stackViewFrame)
        cancelButton = UIButton()
        setDesignForButton(cancelButton)
        cancelButton.setTitle("X", forState: .Normal)
        cancelButton.widthAnchor.constraintEqualToConstant(100).active = true
        
        titleLabel = UILabel()
        setDesignForLabel(titleLabel)
        titleLabel.text = calledTitle
        titleLabel.font = titleLabel.font.fontWithSize(40)
        
        scoreLabel = UILabel()
        setDesignForLabel(scoreLabel)
        titleLabel.font = titleLabel.font.fontWithSize(40)
        scoreLabel.widthAnchor.constraintEqualToConstant(200).active = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = true
        stackView.addArrangedSubview(cancelButton)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(scoreLabel)
        
//        for ii in 0...2 {
//            starImageView[ii] = UIImageView(image: UIImage(named: "star_yellow"))
//            starImageView[ii].widthAnchor.constraintEqualToConstant(50).active = true
//            stackView.addArrangedSubview(starImageView[ii])
//        }
        
        stackView.axis = .Horizontal
        stackView.distribution = .Fill
        stackView.alignment = .Fill
        stackView.spacing = 10
        self.view.addSubview(stackView)
        
        
        // 문제 Label 생성
        let qLabelHeight = round((viewFrame.height - (viewFrameInset * 2)) / 2 - viewFrameInset - sbHeight)
        let qLabelFrame = CGRectMake(viewFrameInset, statusBarHeight + viewFrameInset + sbHeight + viewFrameInset + viewFrameInset, fullWidth, qLabelHeight - sbHeight - viewFrameInset - viewFrameInset)
        qLabel = UILabel(frame: qLabelFrame)
        qLabel.text = "TEST"
        qLabel.font = qLabel.font.fontWithSize(120)
        setDesignForLabel(qLabel)
        self.view.addSubview(qLabel)
        
        let aLabelWidth = floor(fullWidth / 2) - viewFrameInset
        let aLabelHeight = floor(qLabelHeight / 2) - (viewFrameInset * 2)
        
        let aButtonFrame: [CGRect] = [
            CGRectMake(viewFrameInset, statusBarHeight + viewFrameInset + qLabelHeight + (viewFrameInset * 2), aLabelWidth, aLabelHeight),
            CGRectMake(viewFrameInset + aLabelWidth + (viewFrameInset * 2), statusBarHeight + viewFrameInset + qLabelHeight + (viewFrameInset * 2), aLabelWidth, aLabelHeight),
            CGRectMake(viewFrameInset, statusBarHeight + viewFrameInset + qLabelHeight + (viewFrameInset * 4) + aLabelHeight, aLabelWidth, aLabelHeight),
            CGRectMake(viewFrameInset + aLabelWidth + (viewFrameInset * 2), statusBarHeight + viewFrameInset + qLabelHeight + (viewFrameInset * 4) + aLabelHeight, aLabelWidth, aLabelHeight)
        ]
        
        // 버튼 생성
        for ii in 0...3 {
            aButton[ii] = UIButton(frame: aButtonFrame[ii])
            setDesignForButton(aButton[ii])
            self.view.addSubview(aButton[ii])
        }
        
        debugPrint("setLabels: stackView.bounds=\(stackView.bounds)")
        debugPrint("setLabels: stackView.frame=\(stackView.frame)")
        
        loadViewIfNeeded()
    }
    
    func setDesignForButton(aButton: UIButton) {
        //aLabel = self.view.center
//        aButton.setTitle("ANSWER", forState: .Normal)
        aButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        aButton.titleLabel?.font = aButton.titleLabel?.font.fontWithSize(80)
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
    
    // 채점
    func checkAnswer(sender:UIButton!) {
        // 이력 저장
        
        
        if sender.titleLabel?.text == String(correctAnswer) {
            debugPrint("Right!!")
            countCorrectAnswer += 1
            if countCorrectAnswer > 10 {
                gameOver = true
            }
            else {
                // 새로운 문제 수행
                makeQuestionLevel(currentLevel)
            }
        }
        else {
            debugPrint("Wrong!!")
            // 해당 보기에 똥 그림 올리기
            sender.backgroundColor = UIColor.redColor()
            
            // 틀릴 때 마다 점수 까기
        }
    }
    
    
    func aButtonTouchUpInside(sender:UIButton!) {
        sender.backgroundColor = UIColor.lightGrayColor()
        checkAnswer(sender)

    }

    
    func aButtonTouchDown(sender:UIButton!) {
        sender.backgroundColor = UIColor.orangeColor()

    }
    
    func cancelTouchUpInside(sender:UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
