//
//  ShowLogViewController.swift
//  MathAvengers
//
//  Created by SeoDongHee on 2016. 6. 22..
//  Copyright © 2016년 SeoDongHee. All rights reserved.
//

import UIKit
import RealmSwift

class Cell: UITableViewCell {
    var result = false
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: .Value1, reuseIdentifier: reuseIdentifier)
        
        self.textLabel?.font = UIFont(name: "Verdana", size: 30)
        self.detailTextLabel?.font = UIFont(name: "Verdana", size: 15)
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
}

class ShowLogViewController: UIViewController {
    
    var tableView: UITableView!
    var cellIdentifier = "cellIdentifier"
    
    var results: Results<TB_RESULTLOG>!
    var notificationToken: NotificationToken?
    var prevCountResults = 0
    
    let userName = NSUserDefaults.standardUserDefaults().objectForKey("userName") as! String
    var filterDate = NSDate()
    let dateFormatter = NSDateFormatter()
    
    let yourAnswer = "선택한 답".localize()
    let right = "맞음".localize()
    let wrong = "틀림".localize()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupUI()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        rightBarButtonPressed()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - setupUI
    func setupUI() {
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.title = "Log".localize()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search more".localize(), style: .Plain, target: self, action: #selector(rightBarButtonPressed))
        self.automaticallyAdjustsScrollViewInsets = true
        
        tableView = UITableView(frame: CGRectMake(0, 0, 200, 200), style: .Plain)
        tableView.registerClass(Cell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // 아래 footerView를 만든 이유는 테이블뷰의 빈칸이 화면에 보이지 않도록 하기 위함임
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clearColor()
        tableView.tableFooterView = footerView
        
        // 뷰 추가
        view.addSubview(tableView)
        
        // 뷰 Layout 설정
        let viewsDictionary = ["tableView": tableView]
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[tableView]-|", options: .AlignAllCenterY, metrics: nil, views: viewsDictionary))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[tableView]-|", options: .AlignAllCenterX, metrics: nil, views: viewsDictionary))
    }
    
    // MARK: - Actions
    func rightBarButtonPressed() {
        
        filterDate = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: -1, toDate: filterDate, options:NSCalendarOptions(rawValue: 0))!
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let colDate = dateFormatter.stringFromDate(filterDate)
        filterDate = dateFormatter.dateFromString(colDate)!
        
        
        let realms = Realms()
        let predicate = NSPredicate(format: "userName == %@ AND playdt >= %@", userName, filterDate)
        results = realms.retreiveTB_RESULTLOG(predicate)
        let countResults = results.count
        if prevCountResults != countResults {
            
            if prevCountResults == 0 {
                prevCountResults = countResults
            }
            else {
                var insertions: [Int] = []
                for ii in prevCountResults..<countResults {
                    insertions.append(ii)
                }
                tableView.beginUpdates()
                tableView.insertRowsAtIndexPaths(insertions.map { NSIndexPath(forRow: $0, inSection: 0) }, withRowAnimation: .Automatic)
                tableView.endUpdates()
                prevCountResults = countResults
            }
        }
        else {
            let util = Util()
            let okAction = UIAlertAction(title: "OK".localize(), style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                self.navigationController?.popViewControllerAnimated(true)
            }
            self.presentViewController(util.alert("Info".localize(), message: "No more data".localize(), ok: "OK".localize(), cancel: nil, okAction: okAction, cancelAction: nil), animated: true, completion: nil)
        }
        
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

// MARK: - UITableViewDelegate
extension ShowLogViewController: UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let cell = cell as! Cell
        if !cell.result {
            cell.backgroundColor = UIColor.orangeColor()
        }
        else {
            cell.backgroundColor = UIColor.whiteColor()
        }
    }
}

// MARK: - UITableViewDataSource
extension ShowLogViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! Cell
        
        let record = results[indexPath.row]
        
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
        
        cell.textLabel?.text = "\(record.question)      " + yourAnswer + ": \(record.answer)"
        cell.detailTextLabel?.text = "\(String(dateFormatter.stringFromDate(record.playdt))) - \(record.result ? right : wrong)"
        cell.result = record.result

        return cell
    }
    
}






