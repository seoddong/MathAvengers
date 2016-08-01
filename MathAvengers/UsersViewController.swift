//
//  UsersViewController.swift
//  MathAvengers
//
//  Created by SeoDongHee on 2016. 7. 16..
//  Copyright © 2016년 SeoDongHee. All rights reserved.
//

import UIKit
import RealmSwift

class UsersCell: UITableViewCell {
    var userName = ""
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Value1, reuseIdentifier: reuseIdentifier)
        
        self.textLabel?.font = UIFont(name: "Verdana", size: 30)
        self.detailTextLabel?.font = UIFont(name: "Verdana", size: 15)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class UsersViewController: UIViewController {
    
    let realms = Realms()
    var results: Results<TB_USER>!
    let tableView = UITableView()
    let userName = NSUserDefaults.standardUserDefaults().objectForKey("userName") as! String
    let reuseIdentifier = "reuseIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        

        setupUI()
        
        // data 준비
        results = realms.retreiveTB_USERs()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupUI() {
        
        view.backgroundColor = UIColor.whiteColor()
        
        //  Navi Bar
        self.title = "Users".localize()

        // tablbeView
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.registerClass(UsersCell.self, forCellReuseIdentifier: "reuseIdentifier")
        
        // 아래 footerView를 만든 이유는 테이블뷰의 빈칸이 화면에 보이지 않도록 하기 위함임
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clearColor()
        tableView.tableFooterView = footerView
        
        // Layout
        view.addSubview(tableView)
        let margins = self.view.layoutMarginsGuide
        tableView.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor).active = true
        tableView.trailingAnchor.constraintEqualToAnchor(margins.trailingAnchor).active = true
        tableView.topAnchor.constraintEqualToAnchor(margins.topAnchor).active = true
        tableView.bottomAnchor.constraintEqualToAnchor(margins.bottomAnchor).active = true
        
        
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


extension UsersViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! UsersCell
        let result = results[indexPath.row]
        cell.userName = result.userName
        cell.textLabel?.text = "\(result.userName)"
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
        
        if result.bestScore == 0 {
            cell.detailTextLabel?.text = "\(String(dateFormatter.stringFromDate(result.lastPlaydt)))"
        } else {
            cell.detailTextLabel?.text = "Best Records".localize() + ": \(result.bestScore) - \(String(dateFormatter.stringFromDate(result.lastPlaydt)))"
        }
        return cell
    }
}

extension UsersViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let cell = cell as! UsersCell
        if cell.userName == userName {
            cell.textLabel?.textColor = UIColor.redColor()
        }
        else {
            cell.textLabel?.textColor = UIColor.blackColor()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! UsersCell
        // 선택한 셀의 user의 currentYN = true로 설정
        realms.updateStateTB_USER(cell.userName)
        
        // Intro 화면으로 보냄
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}
