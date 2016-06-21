//
//  QuestionViewController.swift
//  MathAvengers
//
//  Created by SeoDongHee on 2016. 6. 16..
//  Copyright © 2016년 SeoDongHee. All rights reserved.
//

import UIKit
import RealmSwift

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
    let uidesign = UIDesign()
    
    // 호출됨
    var calledTitle = ""
    var calledLevel = 0
    
    // 채점, 이력 관리
    var correctAnswer: UInt32 = 0
    var answerArray: [UInt32] = []
    var countCorrectAnswer = 0
    var countIncorrectAnswer = 0
    var currentLevel = 0
    let totalLife = 3
    let penaltyTime: NSTimeInterval = 10
    var gameOver = false
    var startTime = NSDate.timeIntervalSinceReferenceDate()
    var timeRemaining: NSTimeInterval  = 0
    var maxSec: NSTimeInterval = 100
    
    // segue
    let segueIdentifier = "summarySegueIdentifier"
    
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
    
    func setGameover() {
        // summary 화면 호출
        performSegueWithIdentifier(segueIdentifier, sender: self)
    }
    
    func reduceTimeRemaining() {
        maxSec -= penaltyTime
    }
    
    func displayCollapsedTime(timer: NSTimer)
    {
        let passedTime = NSDate.timeIntervalSinceReferenceDate() - startTime
        timeRemaining = maxSec - passedTime
        if !gameOver {
            scoreLabel.text = String(format: "%.03f", timeRemaining)
            if timeRemaining <= 0 {
                // 100초 초과로 게임 종료
                gameOver = true
                timer.invalidate()
                setGameover()
            }
        }
        else{
            timer.invalidate()
            //Force the label to 0.0000000 at the end
            scoreLabel.text = String(format: "%.03f", 0.0)
        }
    }
    
    func setActions() {
        
        cancelButton.addTarget(self, action: #selector(self.cancelTouchUpInside(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        for ii in 0...3 {
            // TouchUpInside
            aButton[ii].addTarget(self, action: #selector(self.aButtonTouchUpInside(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            // 버튼을 눌렀을 때
            aButton[ii].addTarget(self, action: #selector(self.aButtonTouchDown(_:)), forControlEvents: UIControlEvents.TouchDown)
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
        uidesign.setButtonLightGrayWithBorder(cancelButton, fontSize: 80)
        cancelButton.setTitle("X", forState: .Normal)
        cancelButton.widthAnchor.constraintEqualToConstant(100).active = true
        
        titleLabel = UILabel()
        uidesign.setLabelLightGrayWithBorder(titleLabel, fontSize: 40)
        titleLabel.text = calledTitle
        
        scoreLabel = UILabel()
        uidesign.setLabelLightGrayWithBorder(scoreLabel, fontSize: nil)
        scoreLabel.font = UIFont(name: "Menlo-Regular", size: 40)
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
        uidesign.setLabelLightGrayWithBorder(qLabel, fontSize: 120)
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
            uidesign.setButtonLightGrayWithBorder(aButton[ii], fontSize: 80)
            self.view.addSubview(aButton[ii])
        }
        
        debugPrint("setLabels: stackView.bounds=\(stackView.bounds)")
        debugPrint("setLabels: stackView.frame=\(stackView.frame)")
        
        loadViewIfNeeded()
    }
    
    // 문제 풀이 이력 저장
    func saveRecord(answer: String, result: Bool) {
        let question = qLabel.text!
        let level = titleLabel.text!
        let playdt = NSDate()
        let realm = try! Realm()
        realm.beginWrite()
        realm.create(TB_RESULTLOG.self, value: ["answer": answer, "question": question, "level": level, "result": result, "playdt": playdt, "user": "songahbie"])
        try! realm.commitWrite()
    }
    
    
    // 채점
    func checkAnswer(sender:UIButton!) {
        var result = false
        let answer = sender.titleLabel?.text
        if answer == String(correctAnswer) {
            result = true
            countCorrectAnswer += 1
            if countCorrectAnswer > 10 {
                // 모든 문제 다 풀음
                gameOver = true
                setGameover()
            }
            else {
                // 새로운 문제 수행
                makeQuestionLevel(currentLevel)
            }
        }
        else {
            result = false
            countIncorrectAnswer += 1
            if countIncorrectAnswer >= totalLife {
                // totalLife만큼 틀려서 게임 오버
                gameOver = true
                setGameover()
            }
            // 해당 보기에 똥 그림 올리기
            sender.backgroundColor = UIColor.redColor()
            
            // 틀릴 때 마다 점수 까기
            reduceTimeRemaining()
        }
        
        // 이력 저장
        saveRecord(answer!, result: result)
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
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == segueIdentifier) {
            let targetView = segue.destinationViewController as! SummaryViewController
            targetView.finalScore = self.timeRemaining
            targetView.countIncorrectAnswer = self.totalLife - self.countIncorrectAnswer
            targetView.calledTitle = self.calledTitle
        }
    }


}
