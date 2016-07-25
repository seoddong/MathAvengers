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
    var correctAnswerArray: [UInt32] = []
    var selectedAnswerArray: [UInt32] = []
    var countCorrectAnswer = 0
    var countIncorrectAnswer = 0
    var currentLevel = 0
    let totalLife = 3
    let penaltyTime: NSTimeInterval = 10
    var gameOver = false
    var startTime = NSDate.timeIntervalSinceReferenceDate()
    var timeRemaining: NSTimeInterval  = 0
    var maxSec: NSTimeInterval = 100
    
    let userName = NSUserDefaults.standardUserDefaults().objectForKey("userName") as! String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSUserDefaults.standardUserDefaults().setInteger(calledLevel, forKey: "level")
        NSUserDefaults.standardUserDefaults().setObject(calledTitle, forKey: "levelTitle")
        
        setupUI()
        
        setActions()
        
        if calledLevel > 0 {
            currentLevel = calledLevel
            gameOver = false
            makeQuestionLevel()
            
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
        let targetView = SummaryViewController()
        targetView.finalScore = self.timeRemaining
        targetView.countLife = self.totalLife - self.countIncorrectAnswer
        targetView.calledTitle = self.calledTitle
        self.navigationController?.pushViewController(targetView, animated: true)
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
    
    func initSettings() {
        // 보기 초기화
        answerArray.removeAll()
        
        // 보기 버튼 초기화
        for ii in 0...3 {
            aButton[ii].backgroundColor = UIColor.lightGrayColor()
            aButton[ii].enabled = true
        }
        
    }
    
    /**
     결과가 10 미만인 더하기
     */
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
        
        // 이미 정답을 넣어놓았으므로 기타 보기 3개만 더 추출
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
    
    /**
     합이 10이 되는 두 수 찾기 - 1
     ### 문제
     10 미만의 네 수를 랜덤하게 추출하되 그 중 두 개의 수만 반드시 합이 10을 구성해야 한다.
     
     ### 풀이
     1. 랜덤하게 세 수를 뽑는다. 중복없이 뽑아야 하며 답이 되는 두 수(10의 보수가 되는 두 수)가 있어서도 안 된다.
     2. 세 수 중 랜덤하게 하나의 수를 선택하고 이 수에 대한 10의 보수를 구한다.
     4. 위 네 개의 숫자들의 순서를 다시 랜덤하게 나열한다.
     */
    func createLevel2() {
        
        let question = "? + ? = 10"
        
        // 보기 배열 생성
        // 같은 보기가 나오면 안 된다.
        var ii = 0
        while (true) {
            // 1. 랜덤한 세 수를 뽑아내면 루프 탈출
            if ii >= 3 {
                break
            }
            
            let answer = arc4random_uniform(9)
            if answerArray.contains({$0 == answer}) {
                // 이미 같은 보기가 있으므로 loop를 한 번 더 돈다.
                continue
            }
            else if ii == 1 && answerArray[0] + answer == 10 {
                // 답이 되는 두 수가 만들어지면 안되므로 한 번 더 돈다.
                continue
            }
            else if ii == 2 && (answerArray[0] + answer == 10 || answerArray[1] + answer == 10) {
                // 답이 되는 두 수가 만들어지면 안되므로 한 번 더 돈다.
                continue
            }
            else {
                answerArray.append(answer)
                ii += 1
            }
        }
        // 2. 세 수 중 랜덤하게 하나의 수를 선택하고 이 수에 대한 10의 보수를 구한다.
        // 사실 어차피 세 숫자가 다 랜덤하게 나왔으므로 걍 첫 번째 보기에 대한 보수를 구한다.
        answerArray.append(10 - answerArray[2])
        correctAnswerArray.appendContentsOf(answerArray[2...3])
        
        // 문제 생성
        qLabel.text = question
        
        
    }
    
    /**
     한 자리 수 + 한 자리 수 1
     */
    func createLevel3() {
        
        // 문제 생성
        let p1 = arc4random_uniform(9)
        let p2 = arc4random_uniform(9)
        qLabel.text = "\(p1) + \(p2) = ?"
        correctAnswer = p1 + p2
        
        // 보기 배열 생성
        // 같은 보기가 나오면 안 된다.
        var ii = 0
        answerArray.append(correctAnswer)
        
        // 이미 정답을 넣어놓았으므로 기타 보기 3개만 더 추출
        while (true) {
            if ii >= 3 {
                break
            }
            let answer = arc4random_uniform(18)
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
    
    
    /**
     한 자리 수 + 한 자리 수 2
     결과는 10 ~ 18 사이가 나오는 문제만 출제
     */
    func createLevel4() {
        
        // 답 생성 10 ~ 18
        correctAnswer = arc4random_uniform(8) + 10
        
        var diff: UInt32!
        if correctAnswer > 10 {
            // 각 항은 1 ~ 9만 올 수 있다
            diff = 9 - (correctAnswer - 10)
        }
        else {
            diff = 0
        }
        
        // 문제 생성
        let p1 = arc4random_uniform(8 - diff) + diff // 2 ~ 9
        let p2 = correctAnswer - p1
        qLabel.text = "\(p1) + \(p2) = ?"
        
        // 보기 배열 생성
        // 같은 보기가 나오면 안 된다.
        var ii = 0
        answerArray.append(correctAnswer)
        
        // 이미 정답을 넣어놓았으므로 기타 보기 3개만 더 추출
        while (true) {
            if ii >= 3 {
                break
            }
            let answer = arc4random_uniform(18)
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
    
    
    func makeQuestionLevel() {
        // 레벨 1: 합이 10 이하의 덧셈 문제
        
        initSettings()
        
        switch currentLevel {
        case 1:
            createLevel1()
            break
        case 2:
            createLevel2()
            break
        case 3:
            createLevel3()
            break
        case 4:
            createLevel4()
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
    
    // 문제 풀이 이력 저장
    func saveRecord(answer: String, result: Bool) {
        let question = qLabel.text!
        let level = calledTitle
        let playdt = NSDate()
        debugPrint("\(playdt) \(question) \(answer) \(result)")
        let realm = try! Realm()
        realm.beginWrite()
        realm.create(TB_RESULTLOG.self, value: ["answer": answer, "question": question, "level": level, "result": result, "playdt": playdt, "userName": userName])
        try! realm.commitWrite()
    }
    
    func correctAnswerProcess(answer: String) {
        // 이력 저장
        saveRecord(answer, result: true)
        
        countCorrectAnswer += 1
        if countCorrectAnswer >= 10 {
            // 모든 문제 다 풀음
            gameOver = true
            setGameover()
        }
        else {
            // 새로운 문제 수행
            makeQuestionLevel()
        }

    }
    
    func incorrectAnswerProcess(answer: String) {
        // 이력 저장
        saveRecord(answer, result: false)
        
        countIncorrectAnswer += 1
        if countIncorrectAnswer >= totalLife {
            // totalLife만큼 틀려서 게임 오버
            gameOver = true
            setGameover()
        }
        else {
            // star_sad
            starImageView[countIncorrectAnswer-1].image = UIImage(named: "star_sad")
            // 틀릴 때 마다 점수 까기
            maxSec -= penaltyTime
        }
    }
    
    
    // 채점
    func checkAnswer(sender:UIButton!) {
        switch currentLevel {
        case 1, 3, 4:
            let answer = sender.titleLabel?.text
            
            if answer == String(correctAnswer) {
                correctAnswerProcess(answer!)
            }
            else {
                sender.backgroundColor = UIColor.redColor()
                incorrectAnswerProcess(answer!)
            }
            break
        case 2:
            selectedAnswerArray.append(UInt32((sender.titleLabel?.text)!)!)
            // 답을 하나만 선택한 경우에는 두 번째 답을 기다린다.
            if selectedAnswerArray.count < 2 {
                sender.backgroundColor = UIColor.orangeColor()
                break
            }
            else {
                let sum = selectedAnswerArray.reduce(0, combine: { $0 + $1 })
                debugPrint("sum = \(sum)")
                let answer = "\(selectedAnswerArray[0...1])"
                if sum == 10 {
                    // 정답 프로세스
                    correctAnswerProcess(answer)
                }
                else {
                    // 오답 프로세스
                    incorrectAnswerProcess(answer)
                    
                    // 답을 두 개 선택하는 경우에는 그냥 다음 문제로 넘어간다.
                    makeQuestionLevel()
                }
                // 채점이 완료되면 selectedAnswerArray를 비운다.
                selectedAnswerArray.removeAll()
            }
            
            break
        default:
            break
        }
        
    }
    
    // MARK: - setupUI
    func setupUI() {
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        // Navi
        self.title = calledTitle
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "그만 하기", style: .Plain, target: self, action: #selector(leftBarButtonPressed))
        
        // score
        scoreLabel = UILabel()
        uidesign.setLabelBubbleGreenSmallWithBorder(scoreLabel, fontSize: nil)
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
        qLabel.lineBreakMode = .ByWordWrapping
        qLabel.numberOfLines = 0
        uidesign.setLabelBubbleGreenWithBorder(qLabel, fontSize: 120)

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
    
    // MARK: - Actions
    
    func setActions() {
        
        for ii in 0...3 {
            // TouchUpInside
            aButton[ii].addTarget(self, action: #selector(self.aButtonTouchUpInside(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            // 버튼을 눌렀을 때
            aButton[ii].addTarget(self, action: #selector(self.aButtonTouchDown(_:)), forControlEvents: UIControlEvents.TouchDown)
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
/*
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
*/

}
