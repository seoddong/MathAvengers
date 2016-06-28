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
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(add))
        
        // 아래 footerView를 만든 이유는 테이블뷰의 빈칸이 화면에 보이지 않도록 하기 위함임
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clearColor()
        levelTableView.tableFooterView = footerView
    }
    
    func showLog() {
        performSegueWithIdentifier(showLogSegueIdentifier, sender: self)
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
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
}


extension MainViewController: UITableViewDataSource {
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





