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

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI() {
        
        //Navi Bar
        self.title = "Math Avengers - Settings"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "가져오기", style: .Plain, target: self, action: #selector(self.leftBarButtonPressed))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "내보내기", style: .Plain, target: self, action: #selector(self.rightBarButtonPressed))
        
        let nameView = UIView()
        views.append(nameView)
        nameView.backgroundColor = UIColor.yellowColor()
        nameView.layer.cornerRadius = 50
        nameView.layer.borderWidth = 3
        nameView.layer.borderColor = UIColor.blackColor().CGColor
        nameView.translatesAutoresizingMaskIntoConstraints = false
        super.view.addSubview(nameView)

        let viewsDictionary = ["nameView": nameView]
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[nameView]-20-|", options: .AlignAllCenterY, metrics: nil, views: viewsDictionary))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-\((self.navigationController?.navigationBar.frame.size.height)! + 40)-[nameView]-20-|", options: .AlignAllCenterX, metrics: nil, views: viewsDictionary))
        nameView.slideInFromLeft()
    }
    
    func leftBarButtonPressed() {
        let nameView = UIView()
        views.append(nameView)
        nameView.backgroundColor = UIColor(red: CGFloat(views.count)/10, green: CGFloat(views.count)/10, blue: CGFloat(views.count)/10, alpha: 1)
        nameView.layer.cornerRadius = 50
        nameView.layer.borderWidth = 3
        nameView.layer.borderColor = UIColor.blackColor().CGColor
        nameView.translatesAutoresizingMaskIntoConstraints = false
        super.view.addSubview(nameView)
        
        let viewsDictionary = ["nameView": nameView]
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[nameView]-20-|", options: .AlignAllCenterY, metrics: nil, views: viewsDictionary))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-\((self.navigationController?.navigationBar.frame.size.height)! + 40)-[nameView]-20-|", options: .AlignAllCenterX, metrics: nil, views: viewsDictionary))
        nameView.slideInFromLeft()
    }
    
    func rightBarButtonPressed() {
        views.last?.fadeOut()
        views.removeLast()
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
