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
    let cellLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // cellImageView
        cellImageView.translatesAutoresizingMaskIntoConstraints = false
        cellImageView.contentMode = .ScaleAspectFit
        self.contentView.addSubview(cellImageView)
        
        
        cellLabel.translatesAutoresizingMaskIntoConstraints = false
        //cellLabel.backgroundColor = UIColor.yellowColor()
        cellLabel.font = UIFont(name: "Verdana", size: 40)
        self.contentView.addSubview(cellLabel)
        
        let margins = self.contentView.layoutMarginsGuide
        cellImageView.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor).active = true
        cellImageView.topAnchor.constraintEqualToAnchor(margins.topAnchor).active = true
        cellImageView.bottomAnchor.constraintEqualToAnchor(margins.bottomAnchor).active = true
        cellImageView.widthAnchor.constraintEqualToConstant(160).active = true

        cellLabel.topAnchor.constraintEqualToAnchor(margins.topAnchor).active = true
        cellLabel.bottomAnchor.constraintEqualToAnchor(margins.bottomAnchor).active = true
        NSLayoutConstraint(item: cellLabel, attribute: .Trailing, relatedBy: .Equal, toItem: self.contentView, attribute: .TrailingMargin, multiplier: 1.0, constant: 0.0).active = true
        NSLayoutConstraint(item: cellLabel, attribute: .Leading, relatedBy: .Equal, toItem: cellImageView, attribute: .TrailingMargin, multiplier: 1.0, constant: 20.0).active = true
        
        
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
    
    
    func metadataQueryDidFinishGathering(notification: NSNotification) -> Void {
        // 일단 결과를 받았으니 더 이상의 쿼리 진행은 막고 noti도 그만 받는 거로 설정한다.
        let query = notification.object as! NSMetadataQuery
        query.disableUpdates()
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSMetadataQueryDidFinishGatheringNotification, object: query)
        query.stopQuery()
        
        let results = query.results
        if query.resultCount == 1 {
            let resultURL = results[0].valueForAttribute(NSMetadataItemURLKey) as! NSURL
            let maDoc = MADocument(fileURL: resultURL)
            maDoc.openWithCompletionHandler({ (success: Bool) -> Void in
                if success {
                    debugPrint("iCloud file open OK")
                    
                } else {
                    debugPrint("iCloud file open failed")
                }
            })
        }
        else if query.resultCount > 1 {
            debugPrint("query.results = \(results)")
        }
        else {
            // iCloud에 파일이 없으므로 파일을 카피해 놓는다
            let maDoc = MADocument(fileURL: ubiquityURL)
            
            maDoc.saveToURL(ubiquityURL, forSaveOperation: .ForCreating, completionHandler: {(success: Bool) -> Void in
                if success {
                    print("iCloud create OK")
                } else {
                    print("iCloud create failed")
                }
            })
        }
    }
    
    
    // MARK: - Actions
    func showLog() {
        let targetView = ShowLogViewController()
        self.navigationController?.pushViewController(targetView, animated: true)
    }
    
    func cloudPressed() {
        let filemgr = NSFileManager.defaultManager()
        
        ubiquityURL = filemgr.URLForUbiquityContainerIdentifier(nil)
        guard ubiquityURL != nil else {
            debugPrint("Unable to access iCloud Account")
            debugPrint("Open the Settings app and enter your Apple ID into iCloud settings")
            return
        }
        
        ubiquityURL = ubiquityURL?.URLByAppendingPathComponent("Documents/default.realm")
        debugPrint("ubiquityURL=\(ubiquityURL)")
        
        // iCloud storage를 검색할 조건과 검색 범위를 지정
        metaDataQuery = NSMetadataQuery()
        metaDataQuery?.predicate = NSPredicate(format: "%K like 'default.realm'", NSMetadataItemFSNameKey)
        metaDataQuery?.searchScopes = [NSMetadataQueryUbiquitousDocumentsScope]
        
        // 검색이 끝나면 결과를 알려줄 noti 설정
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainViewController.metadataQueryDidFinishGathering), name: NSMetadataQueryDidFinishGatheringNotification, object: metaDataQuery)
        
        let state = metaDataQuery?.startQuery()
        debugPrint("state=\(state)")
        
        //        let dirPath = filemgr.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first
        //        // dirPath=[file:///Users/seoddong/Library/Developer/CoreSimulator/Devices/CAE86DB6-92BC-44D3-93D0-F5D4826B54D5/data/Containers/Data/Application/1AA46834-C0FC-43A5-8D41-F3BEA3B048BD/Documents/]
        //        if let path = dirPath {
        //            let documentURL = path.URLByAppendingPathComponent("default.realm")
        //            let maDoc = MADocument(fileURL: documentURL)
        //            maDoc.checkFileExist(documentURL)
        //        }
        //        else {
        //            debugPrint("There is no Document folder..")
        //        }
        
    }

    
    // MARK: - setupUI
    func setupUI() {
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.automaticallyAdjustsScrollViewInsets = true
        
        self.title = "Math Avengers"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "기록 보기", style: .Plain, target: self, action: #selector(showLog))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "cloud", style: .Plain, target: self, action: #selector(cloudPressed))
        
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
        let targetView = QuestionViewController()
        let selectedIndexPath = tableView.indexPathForSelectedRow
        let cell = tableView.cellForRowAtIndexPath(selectedIndexPath!) as! LevelTableViewCell
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
        cell.cellLabel.text = "\(results[row].levelDesc)"
        let imageName = String(format: "%03d", results[row].level)
        debugPrint("imageName=[\(imageName)]")
        cell.cellImageView.image = UIImage(named: imageName)
        
        return cell
    }
}





