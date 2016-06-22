//
//  MainViewController.swift
//  MathAvengers
//
//  Created by SeoDongHee on 2016. 6. 16..
//  Copyright © 2016년 SeoDongHee. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var levelTableView: UITableView!
    
    let reuseIdentifier = "reuseCellIdentifier"
    let levelSegueIdentifier = "levelSegueIdentifier"
    let showLogSegueIdentifier = "showLogSegueIdentifier"
    
    var labelArray: [String] = []
    var imageNameArray: [String] = []
    var webAddress: [String] = []
    
    var selectedIndexPathRow = 0
    var selectedTitle = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        levelTableView.delegate = self
        levelTableView.dataSource = self

        labelArray = ["사슴", "개", "사자", "백호랑이", "코끼리"]
        webAddress = ["http://en.wikipedia.org/wiki/Buckingham_Palace",
                      "http://en.wikipedia.org/wiki/Eiffel_Tower",
                      "http://en.wikipedia.org/wiki/Grand_Canyon",
                      "http://en.wikipedia.org/wiki/Windsor_Castle",
                      "http://en.wikipedia.org/wiki/Empire_State_Building"]
        imageNameArray = ["001", "002", "003", "004", "005"]
        
        setupUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        debugPrint("M1: navigationBarHidden=\(self.navigationController?.navigationBarHidden)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.title = "Math Avengers"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "기록 보기", style: .Plain, target: self, action: #selector(showLog))
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(add))
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
                let targetView = segue.destinationViewController as! ShowLogViewController
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labelArray.count
    }
    
}


extension MainViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.levelTableView.dequeueReusableCellWithIdentifier("reuseCellIdentifier", forIndexPath: indexPath) as! LevelTableViewCell
        
        // 셀의 데이터와 이미지 설정 코드
        let row = indexPath.row
        cell.cellLabel.text = "\(row + 1). \(labelArray[row])"
        cell.cellImageView.image = UIImage(named: imageNameArray[row])
        
        return cell
    }
}





