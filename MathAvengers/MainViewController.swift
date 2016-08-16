//
//  MainViewController.swift
//  MathAvengers
//
//  Created by SeoDongHee on 2016. 6. 16..
//  Copyright © 2016년 SeoDongHee. All rights reserved.
//

import UIKit
import RealmSwift

class LevelTableViewCell: UITableViewCell {
    
    let cellImageView = UIImageView()
    let cellnumImageView = UIImageView()
    let cellLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // cellImageView
        cellImageView.translatesAutoresizingMaskIntoConstraints = false
        cellImageView.contentMode = .ScaleAspectFit
        self.contentView.addSubview(cellImageView)
        
        // cellnumImageView
        cellnumImageView.translatesAutoresizingMaskIntoConstraints = false
        cellnumImageView.contentMode = .ScaleAspectFit
        self.contentView.addSubview(cellnumImageView)
        
        
        cellLabel.translatesAutoresizingMaskIntoConstraints = false
        //cellLabel.backgroundColor = UIColor.yellowColor()
        cellLabel.font = UIFont(name: "Verdana", size: 40)
        self.contentView.addSubview(cellLabel)
        
        let margins = self.contentView.layoutMarginsGuide
        cellImageView.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor).active = true
        cellImageView.topAnchor.constraintEqualToAnchor(margins.topAnchor).active = true
        cellImageView.bottomAnchor.constraintEqualToAnchor(margins.bottomAnchor).active = true
        cellImageView.widthAnchor.constraintEqualToConstant(160).active = true
        
        NSLayoutConstraint(item: cellnumImageView, attribute: .Leading, relatedBy: .Equal, toItem: cellImageView, attribute: .TrailingMargin, multiplier: 1.0, constant: -10.0).active = true
        cellnumImageView.topAnchor.constraintEqualToAnchor(margins.topAnchor).active = true
        cellnumImageView.bottomAnchor.constraintEqualToAnchor(margins.bottomAnchor).active = true
        cellnumImageView.widthAnchor.constraintEqualToConstant(70).active = true
        
        cellLabel.topAnchor.constraintEqualToAnchor(margins.topAnchor).active = true
        cellLabel.bottomAnchor.constraintEqualToAnchor(margins.bottomAnchor).active = true
        NSLayoutConstraint(item: cellLabel, attribute: .Trailing, relatedBy: .Equal, toItem: self.contentView, attribute: .TrailingMargin, multiplier: 1.0, constant: 0.0).active = true
        NSLayoutConstraint(item: cellLabel, attribute: .Leading, relatedBy: .Equal, toItem: cellnumImageView, attribute: .TrailingMargin, multiplier: 1.0, constant: 20.0).active = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

class MainViewController: UIViewController {
    
    let tableView = UITableView()
    
    let reuseIdentifier = "reuseCellIdentifier"
    let levelSegueIdentifier = "levelSegueIdentifier"
    let showLogSegueIdentifier = "showLogSegueIdentifier"
    
    var selectedIndexPathRow = 0
    var selectedTitle = ""
    var results: Results<TB_LEVEL>!
    
    var ubiquityURL: NSURL!
    var metaDataQuery: NSMetadataQuery?

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let realms = Realms()
        results = realms.retreiveTB_LEVEL()
        
        setupUI()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    func showLog() {
        let targetView = ShowLogViewController()
        self.navigationController?.pushViewController(targetView, animated: true)
    }
    
    func cloudPressed() {
        let cloud = CloudViewController()
        self.navigationController?.pushViewController(cloud, animated: true)
        
    }

    
    // MARK: - setupUI
    func setupUI() {
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.automaticallyAdjustsScrollViewInsets = true
        
        self.title = "Math Avengers"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "View Records".localize(), style: .Plain, target: self, action: #selector(showLog))
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "cloud", style: .Plain, target: self, action: #selector(cloudPressed))
        
        // TableView 설정
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.registerClass(LevelTableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        
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
    

    // MARK: - Navigation
/*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let segueIdentifier = segue.identifier {
            
            switch segueIdentifier {
            case levelSegueIdentifier:
                let targetView = segue.destinationViewController as! QuestionViewController
                let selectedIndexPath = tableView.indexPathForSelectedRow
                let cell = tableView.cellForRowAtIndexPath(selectedIndexPath!) as! LevelTableViewCell
                targetView.calledTitle = cell.cellLabel.text!
                targetView.calledLevel = (selectedIndexPath?.row)! + 1
                break
                
            case showLogSegueIdentifier:
                _ = segue.destinationViewController as! ShowLogViewController
                break
                
            default:
                debugPrint("MainViewController.prepareForSegue")
                break
            }
        }

    }
*/


}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedIndexPath = tableView.indexPathForSelectedRow
        let cell = tableView.cellForRowAtIndexPath(selectedIndexPath!) as! LevelTableViewCell
        cell.contentView.backgroundColor = UIColor.whiteColor()
        cell.contentView.layer.borderColor = UIColor.orangeColor().CGColor
        cell.contentView.layer.borderWidth = 5
        cell.contentView.layer.cornerRadius = 10
        
        let targetView = QuestionViewController()
        targetView.calledTitle = cell.cellLabel.text!
        targetView.calledLevel = (selectedIndexPath?.row)! + 1
        self.navigationController?.pushViewController(targetView, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! LevelTableViewCell
        
        // 셀의 데이터와 이미지 설정 코드
        let row = indexPath.row
        cell.cellLabel.text = "\(results[row].levelDesc)".localize()
        cell.cellLabel.adjustsFontSizeToFitWidth = true
        let imageName = String(format: "%03d", results[row].level)
        cell.cellImageView.image = UIImage(named: imageName)
        //cell.cellnumImageView.image = UIImage(named: imageName)
        
        return cell
    }
}





