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
    var scoreLabel: UILabel!
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
        
        debugPrint("Q1: navigationBarHidden=\(self.navigationController?.navigationBarHidden)")
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
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func setGameover() {
        // summary 화면 호출
        performSegueWithIdentifier(segueIdentifier, sender: self)
    }
    
    func displayCollapsedTime(timer: NSTimer)
    {
        let passedTime = NSDate.timeIntervalSinceReferenceDate() - startTime
        timeRemaining = maxSec - passedTime
        if !gameOver {
            scoreLabel.text = String(format: "%.04f", timeRemaining)
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
            scoreLabel.text = String(format: "%.04f", 0.0)
        }
    }
    
    func setActions() {
        
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
            aButton[ii].enabled = true
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
                continue
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
            break
        default:
            createLevel1()
            break
        }

        // 답 배열 섞기
        let shuffledArray = util.arrayShuffle([0,1,2,3])
        
        // 답 세팅
        for ii in 0...3 {
            aButton[ii].setTitle(String(answerArray[shuffledArray[ii] as! Int]), forState: .Normal)
        }
        

    }
    
    func initUIs() {
        
        self.title = calledTitle
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "그만 하기", style: .Plain, target: self, action: #selector(leftBarButtonPressed))
        
        // score
        scoreLabel = UILabel()
        uidesign.setLabelLightGrayWithBorder(scoreLabel, fontSize: nil)
        scoreLabel.font = UIFont(name: "Menlo-Regular", size: 40)
        scoreLabel.heightAnchor.constraintEqualToConstant(80).active = true
        //scoreLabel.widthAnchor.constraintEqualToConstant(400).active = true
        
        
        // topStackView
        let topStackView = UIStackView()
        topStackView.spacing = 5
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        topStackView.axis = .Horizontal
        topStackView.distribution = .Fill
        topStackView.alignment = .Fill

        topStackView.addArrangedSubview(scoreLabel)
        
        // starImageView
        _ = starImageView.map {
                $0.image = UIImage(named: "star")
                $0.heightAnchor.constraintEqualToConstant(80).active = true
                $0.widthAnchor.constraintEqualToConstant(80).active = true
                topStackView.addArrangedSubview($0)
        }
    

        // 문제 Label 생성
        qLabel = UILabel()
        qLabel.text = "TEST"
        uidesign.setLabelLightGrayWithBorder(qLabel, fontSize: 120)

        // 버튼 생성
        for ii in 0...3 {
            uidesign.setButtonLightGrayWithBorder(aButton[ii], fontSize: 80)
            aButton[ii].heightAnchor.constraintEqualToConstant(150).active = true
        }
        var buttonStackView = [UIStackView(), UIStackView()]
        for ii in 0...1 {
            buttonStackView[ii].spacing = 5
            buttonStackView[ii].translatesAutoresizingMaskIntoConstraints = false
            buttonStackView[ii].axis = .Horizontal
            buttonStackView[ii].distribution = .FillEqually
            buttonStackView[ii].alignment = .Fill
        }
        buttonStackView[0].addArrangedSubview(aButton[0])
        buttonStackView[0].addArrangedSubview(aButton[1])
        buttonStackView[1].addArrangedSubview(aButton[2])
        buttonStackView[1].addArrangedSubview(aButton[3])
        
        // totalStackView
        let totalStackView = UIStackView()
        totalStackView.spacing = 5
        totalStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(totalStackView)
        let viewsDictionary = ["stackView": totalStackView]
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[stackView]-20-|", options: .AlignAllCenterX, metrics: nil, views: viewsDictionary))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-84-[stackView]-20-|", options: .AlignAllCenterY, metrics: nil, views: viewsDictionary))
        totalStackView.axis = .Vertical
        totalStackView.distribution = .Fill
        totalStackView.alignment = .Fill
        totalStackView.addArrangedSubview(topStackView)
        totalStackView.addArrangedSubview(qLabel)
        totalStackView.addArrangedSubview(buttonStackView[0])
        totalStackView.addArrangedSubview(buttonStackView[1])
        

        
        self.view.addSubview(totalStackView)
        
        loadViewIfNeeded()
    }
    
    // 문제 풀이 이력 저장
    func saveRecord(answer: String, result: Bool) {
        let question = qLabel.text!
        let level = calledTitle
        let playdt = NSDate()
        debugPrint("\(playdt) \(question) \(answer) \(result)")
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
            
            // 이력 저장
            saveRecord(answer!, result: result)
            
            countCorrectAnswer += 1
            if countCorrectAnswer >= 10 {
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
            
            // 이력 저장
            saveRecord(answer!, result: result)
            
            countIncorrectAnswer += 1
            if countIncorrectAnswer >= totalLife {
                // totalLife만큼 틀려서 게임 오버
                gameOver = true
                setGameover()
            }
            else {
                // star_sad
                starImageView[countIncorrectAnswer-1].image = UIImage(named: "star_sad")
                
                sender.backgroundColor = UIColor.redColor()
                
                // 틀릴 때 마다 점수 까기
                maxSec -= penaltyTime
            }
        }
        
    }
    
    
    func aButtonTouchUpInside(sender:UIButton!) {
        sender.backgroundColor = UIColor.lightGrayColor()
        sender.enabled = false
        checkAnswer(sender)

    }

    
    func aButtonTouchDown(sender:UIButton!) {
        sender.backgroundColor = UIColor.orangeColor()

    }
    
    func leftBarButtonPressed() {
        self.navigationController?.popViewControllerAnimated(true)
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
