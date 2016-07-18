//
//  MainViewController.swift
//  MathAvengers
//
//  Created by SeoDongHee on 2016. 6. 16..
//  Copyright © 2016년 SeoDongHee. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {
    
    @IBOutlet weak var levelTableView: UITableView!
    
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

        levelTableView.delegate = self
        levelTableView.dataSource = self
        
        let realms = Realms()
        results = realms.retreiveTB_LEVEL()
        
        setupUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.automaticallyAdjustsScrollViewInsets = true
        
        self.title = "Math Avengers"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "기록 보기", style: .Plain, target: self, action: #selector(showLog))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "cloud", style: .Plain, target: self, action: #selector(cloudPressed))
        
        // 아래 footerView를 만든 이유는 테이블뷰의 빈칸이 화면에 보이지 않도록 하기 위함임
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clearColor()
        levelTableView.tableFooterView = footerView
    }
    
    func showLog() {
        performSegueWithIdentifier(showLogSegueIdentifier, sender: self)
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
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let segueIdentifier = segue.identifier {
            
            switch segueIdentifier {
            case levelSegueIdentifier:
                let targetView = segue.destinationViewController as! QuestionViewController
                let selectedIndexPath = levelTableView.indexPathForSelectedRow
                let cell = levelTableView.cellForRowAtIndexPath(selectedIndexPath!) as! LevelTableViewCell
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



}


extension MainViewController: UITableViewDelegate {
    //
}


extension MainViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.levelTableView.dequeueReusableCellWithIdentifier("reuseCellIdentifier", forIndexPath: indexPath) as! LevelTableViewCell
        
        // 셀의 데이터와 이미지 설정 코드
        let row = indexPath.row
        cell.cellLabel.text = "\(results[row].levelDesc)"
        let imageName = String(format: "%03d", results[row].level)
        debugPrint("imageName=[\(imageName)]")
        cell.cellImageView.image = UIImage(named: imageName)
        
        return cell
    }
}





