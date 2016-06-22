//
//  ShowLogViewController.swift
//  MathAvengers
//
//  Created by SeoDongHee on 2016. 6. 22..
//  Copyright © 2016년 SeoDongHee. All rights reserved.
//

import UIKit
import RealmSwift

class ShowLogViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        let realms = Realms()
        let results = realms.retreiveTB_RESULTLOG()
        
        for result in results {
            debugPrint("\(result.playdt) \(result.question) \(result.answer) \(result.level) \(result.result) \(result.user) ")
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
