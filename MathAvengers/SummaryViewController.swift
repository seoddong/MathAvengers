//
//  SummaryViewController.swift
//  MathAvengers
//
//  Created by SeoDongHee on 2016. 6. 20..
//  Copyright © 2016년 SeoDongHee. All rights reserved.
//

import UIKit
import RealmSwift

class SummaryViewController: UIViewController {
    
    var finalScore: NSTimeInterval = 0
    var countIncorrectAnswer = 0
    var calledTitle = ""
    var message = ["이런~ 다음엔 좀 더 잘 할 수 있을 거에요.", "음~ 잘 했어요~", "오~ 이 정도면 훌륭해요!!", "와우! 최고로 잘 했어요!"]
    
    var stackView: UIStackView!
    var levelLable: UILabel!
    var scoreLable: UILabel!
    var messageLable: UILabel!
    var backButton: UIButton!
    var showLogButton: UIButton!
    var imageView: UIImageView!
    
    let uidesign = UIDesign()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        stackView = UIStackView(frame: view.bounds)
        stackView.translatesAutoresizingMaskIntoConstraints = true
        stackView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        backButton = UIButton()
        backButton.setTitle("닫기", forState: .Normal)
        uidesign.setButtonLightGrayWithBorder(backButton, fontSize: 80)
        
        levelLable = UILabel()
        levelLable.text = "도전 단계: \(calledTitle)"
        uidesign.setLabelLightGrayWithBorder(levelLable, fontSize: 40)
        levelLable.heightAnchor.constraintEqualToConstant(80).active = true
        
        scoreLable = UILabel()
        scoreLable.text = "최종 점수: \(String(finalScore))"
        uidesign.setLabelLightGrayWithBorder(scoreLable, fontSize: 40)
        scoreLable.heightAnchor.constraintEqualToConstant(80).active = true
        
        messageLable = UILabel()
        messageLable.text = message[countIncorrectAnswer]
        uidesign.setLabelLightGrayWithBorder(messageLable, fontSize: 40)
        messageLable.heightAnchor.constraintEqualToConstant(200).active = true
        
        showLogButton = UIButton()
        showLogButton.setTitle("내가 푼 문제 보기", forState: .Normal)
        uidesign.setButtonLightGrayWithBorder(showLogButton, fontSize: 40)
        
        imageView = UIImageView(image: UIImage(named: "010"))
        //imageView.frame.size = CGSizeMake(imageView.frame.width, imageView.frame.height / 2)
        imageView.heightAnchor.constraintEqualToConstant(400).active = true
        
        
        stackView.addArrangedSubview(backButton)
        stackView.addArrangedSubview(levelLable)
        stackView.addArrangedSubview(scoreLable)
        stackView.addArrangedSubview(messageLable)
        stackView.addArrangedSubview(showLogButton)
        stackView.addArrangedSubview(imageView)
        
        stackView.axis = .Vertical
        stackView.distribution = .EqualSpacing
        stackView.alignment = .Fill
        //stackView.spacing = 30
        stackView.layoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsetsMake(40, 20, 20, 20)
        self.view.addSubview(stackView)
        
        setActions()
    }
    
    func setActions() {
        
        showLogButton.addTarget(self, action: #selector(self.showLogTouchUpInside(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    func showLogTouchUpInside(sender: UIButton) {
        sender.backgroundColor = UIColor.orangeColor()
        
        let realm = try! Realm()
        let results = try! realm.objects(TB_RESULTLOG.self).sorted("playdt")
        
        for result in results {
            debugPrint("\(result.playdt) \(result.question) \(result.answer) \(result.level) \(result.result) \(result.user) ")
        }
        
        var notificationToken: NotificationToken?
        
        notificationToken = results.addNotificationBlock { (changes: RealmCollectionChange) in
            switch changes {
            case .Initial:
                debugPrint("changes.Initial")
                break
            case .Update(_, let deletions, let insertions, let modifications):
                debugPrint("Update")
                break
            case .Error(let err):
                debugPrint("err: \(err.localizedFailureReason)")
                break
            }
            
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
