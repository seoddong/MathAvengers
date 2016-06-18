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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let target = segue.destinationViewController as! QuestionViewController
        target.calledLevel = selectedIndexPathRow + 1
        debugPrint("prepareForSegue: selectedTitle=\(selectedTitle)")
        target.calledTitle = selectedTitle
    }


}


extension MainViewController: UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labelArray.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedIndexPathRow = indexPath.row
        let cell = self.levelTableView.cellForRowAtIndexPath(indexPath) as! LevelTableViewCell
        selectedTitle = cell.cellLabel.text!
        debugPrint("didSelectRowAtIndexPath: selectedTitle=\(selectedTitle)")
        
    }
    
}


extension MainViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.levelTableView.dequeueReusableCellWithIdentifier("reuseCellIdentifier", forIndexPath: indexPath) as! LevelTableViewCell
        
        // 셀의 데이터와 이미지 설정 코드
        let row = indexPath.row
        cell.cellLabel.text = labelArray[row]
        cell.cellImageView.image = UIImage(named: imageNameArray[row])
        
        return cell
    }
}





