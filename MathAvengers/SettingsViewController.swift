//
//  SettingsViewController.swift
//  MathAvengers
//
//  Created by SeoDongHee on 2016. 7. 1..
//  Copyright © 2016년 SeoDongHee. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var views: [UIView] = []
    let uidesign = UIDesign()
    let util = Util()
    var distribution = 0
    var keyboardYN = false
    var rectKeyboard: CGRect!
    
    var nameField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // keyboard 이벤트 등록
        self.performSelector(#selector(registerKeyboardEvent))

        setupUI()
    }
    
    override func viewDidDisappear(animated: Bool) {
        // keyboard 이벤트 등록 해제
        self.performSelector(#selector(unregisterKeyboardEvent))
    }
    
    // 텍스트필드말고 다른 곳 터치하면 키보드를 가리도록 한다.
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        nameField.endEditing(true)
    }
    
    // 키보드가 떠오를 때 발생하는 이벤트 처리
    func keyboardWillShow(notification: NSNotification) {
        debugPrint("keyboard will show")
        keyboardYN = true
        let userInfo = notification.userInfo!
        var rectView = self.view.frame
        rectKeyboard = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        //rectKeyboard  = self.nameField.convertRect(rectKeyboard, fromView:nil)
        rectView.origin.y -= rectKeyboard.size.height
        
        UIView.animateWithDuration(5, animations: {
            self.view.frame = rectView
            self.view.layoutIfNeeded()
        })
    }
    
    // 키보드가 사라질 때 발생하는 이벤트 처리
    func keyboardWillHide(notification: NSNotification) {
        debugPrint("keyboard will hide")
        keyboardYN = false
        let userInfo = notification.userInfo!
        var rectView = self.view.frame
        rectKeyboard = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        //rectKeyboard  = self.nameField.convertRect(rectKeyboard, fromView:nil)
        rectView.origin.y += rectKeyboard.size.height
        
        UIView.animateWithDuration(1, animations: {
            self.view.frame = rectView
            self.view.layoutIfNeeded()
        })
    }
    
    func viewUpDownbyKeyboard() {
        if let rectkeyboard = rectKeyboard {
            
            var rectView = self.view.frame
            if keyboardYN {
                // 키보드가 보여지고 있다면
                rectView.origin.y -= rectkeyboard.size.height
            }
            else {
                // 키보드가 사라지고 있다면
                rectView.origin.y += rectkeyboard.size.height
            }
            UIView.animateWithDuration(1, animations: {
                self.view.frame = rectView
                self.view.layoutIfNeeded()
            })
        }
    }
    
    // 위 두 가지 키보드 이벤트를 이벤트로 등록
    func registerKeyboardEvent() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // 위 두 가지 키보드 이벤트를 이벤트에서 해제
    func unregisterKeyboardEvent() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func setupUI() {
        
        //Navi Bar
        self.title = "Math Avengers - Settings"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "이전 단계로", style: .Plain, target: self, action: #selector(self.leftBarButtonPressed))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "다음 단계로", style: .Plain, target: self, action: #selector(self.nextButtonPressed))
        
        nextButtonPressed()
    }
    
    func leftBarButtonPressed() {
        let viewsIndex = views.count - 1
        switch viewsIndex {
        case 0:
            GlobalSettings.user = ""
            self.navigationController?.popToRootViewControllerAnimated(true)
            break
        default:
            backButtonPressed()
            break
        }
    }
    
    func nextButtonPressed() {
        let viewsIndex = views.count - 1
        switch viewsIndex {
        case 0:
            if let name = nameField.text {
                if name != "" {
                    GlobalSettings.user = name
                }
                else {
                    self.presentViewController(util.alert("앗!", message: "이름을 입력하지 않으셨네요~", ok: "네, 입력할게요", cancel: nil), animated: true, completion: nil)
                    nameField.becomeFirstResponder()
                    return
                }
            }
            else {
                self.presentViewController(util.alert("앗!!", message: "이름을 입력하지 않으셨네요~", ok: "네~ 입력할게요", cancel: nil), animated: true, completion: nil)
                nameField.becomeFirstResponder()
                return
            }
            break
        default:
            break
        }
        
        let nameView = UIView()
        views.append(nameView)
        uidesign.setViewLayout(nameView, color: nil)

        nameView.translatesAutoresizingMaskIntoConstraints = false
        super.view.addSubview(nameView)
        
        let viewsDictionary = ["nameView": nameView]
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[nameView]-20-|",
            options: .AlignAllCenterX, metrics: nil, views: viewsDictionary))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-\((self.navigationController?.navigationBar.frame.size.height)! + 40)-[nameView]-20-|", options: .AlignAllCenterY, metrics: nil, views: viewsDictionary))
        nameView.slideInFromLeft(1, completionDelegate: self)
        
        self.setComponent(self.views.count - 1)

        if views.count > 1 {
            views[views.count - 2].fadeOut()
        }
    }
    
    func backButtonPressed() {
        
        if views.count > 1 {
            views.last?.fadeOut()
            views.removeLast()
            views.last?.fadeIn()
        }
        
    }
    
    func setComponent(seq: Int) -> Void {
        switch seq {
        case 0:
            
            let headerImage = UIImageView(image: UIImage(named: "name"))
            headerImage.translatesAutoresizingMaskIntoConstraints = false
            headerImage.contentMode = .ScaleAspectFit
            
            let nameLabel = UILabel()
            //nameLabel.backgroundColor = UIColor.lightGrayColor()
            nameLabel.font = UIFont(name: "Verdana", size: 40)
            nameLabel.text = "이름을 적어주세요"
            nameLabel.textAlignment = .Center
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            nameLabel.heightAnchor.constraintEqualToConstant(200).active = true
            
            nameField.delegate = self
            nameField.font = UIFont(name: "Verdana", size: 40)
            nameField.textAlignment = .Center
            nameField.layer.cornerRadius = 10
            nameField.layer.borderColor = UIColor.blackColor().CGColor
            nameField.layer.borderWidth = 1
            nameField.translatesAutoresizingMaskIntoConstraints = false
            nameField.heightAnchor.constraintEqualToConstant(100).active = true
            
            let nextImage = UIImageView(image: UIImage(named: "next"))
            nextImage.translatesAutoresizingMaskIntoConstraints = false
            nextImage.contentMode = .ScaleAspectFit
            let nextPressed = UITapGestureRecognizer(target: self, action: #selector(nextButtonPressed))
            nextImage.userInteractionEnabled = true
            nextImage.addGestureRecognizer(nextPressed)
            
            
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .Vertical
            stackView.distribution = .EqualCentering
            stackView.alignment = .Fill
            stackView.spacing = 20
            
            stackView.addArrangedSubview(headerImage)
            stackView.addArrangedSubview(nameLabel)
            stackView.addArrangedSubview(nameField)
            stackView.addArrangedSubview(nextImage)
            views[seq].addSubview(stackView)

            
            let viewsDictionary = ["stackView": stackView]
            views[seq].addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[stackView]-20-|",
                options: .AlignAllCenterX, metrics: nil, views: viewsDictionary))
            views[seq].addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[stackView]-20-|",
                options: .AlignAllCenterY, metrics: nil, views: viewsDictionary))
            
            //nameField.becomeFirstResponder()

            break
        default:
            break
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

extension SettingsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.nextButtonPressed()
        return true
    }
}
