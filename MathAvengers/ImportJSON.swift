//
//  ImportJSON.swift
//  MathAvengers
//
//  Created by SeoDongHee on 2016. 6. 26..
//  Copyright © 2016년 SeoDongHee. All rights reserved.
//

import Foundation
import RealmSwift

class ImportJSON {
    init () {
        
//        initTB_LEVEL()
//        initTB_SETTINGS()
        
    }
    
    func initTB_SETTINGS(data: NSData?) {
        let jsonFilePath = NSBundle.mainBundle().pathForResource("TB_SETTINGS", ofType: "json")
        debugPrint("jsonFilePath=\(jsonFilePath)")
        do
        {
            var jsonData: NSData!
            if let webData = data {
                jsonData = webData
            }
            else {
                jsonData = try NSData(contentsOfFile: jsonFilePath!, options: NSDataReadingOptions(rawValue: 0))
            }
            let json = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions()) as! NSArray
            
            
            let realm = try Realm()
            try! realm.write
                {
                    for each in json
                    {
                        realm.create(TB_SETTINGS.self, value: [each["seq"] as! Int, each["section"] as! String, each["cellType"] as! String, each["labelText"] as! String])
                    }
                    
            }
            
            let results = try realm.objects(TB_SETTINGS.self)
            for result in results
            {
                debugPrint("[\(result.seq)]\t[\(result.section)]\t[\(result.cellType)]")
            }
            
            
        }
        catch let error as NSError
        {
            debugPrint("error: \(error)")
        }
        
    }
    
    func initTB_LEVEL(data: NSData?) {
        let jsonFilePath = NSBundle.mainBundle().pathForResource("TB_LEVEL", ofType: "json")
        debugPrint("jsonFilePath=\(jsonFilePath)")
        do
        {
            var jsonData: NSData!
            if let webData = data {
                jsonData = webData
            }
            else {
                jsonData = try NSData(contentsOfFile: jsonFilePath!, options: NSDataReadingOptions(rawValue: 0))
            }
            let json = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions()) as! NSArray
            
            
            let realm = try Realm()
            try! realm.write
                {
                    for each in json
                    {
                        realm.create(TB_LEVEL.self, value: [each["level"] as! Int, each["levelDesc"] as! String, each["imageURL"] as! String], update: true)
                    }
                    
            }
            
            let results = try realm.objects(TB_LEVEL.self)
            for result in results
            {
                debugPrint("[\(result.level)]\t[\(result.levelDesc)]\t[\(result.imageURL)]")
            }
            
            
        }
        catch let error as NSError
        {
            debugPrint("error: \(error)")
        }

    }
    
    
    
    func checkVersion() {
        var dataVer = NSUserDefaults.standardUserDefaults().floatForKey("dataVer")
        if dataVer == 0.0 {
            NSUserDefaults.standardUserDefaults().setFloat(1.0, forKey: "dataVer")
            dataVer = NSUserDefaults.standardUserDefaults().floatForKey("dataVer")
        }
        var webVer: Float = 0
        let verURL = NSURL(string: "http://seoddong.myaxler.com/songahbie/MathAvengers/mathavengers_ver.txt")!
        let task = NSURLSession.sharedSession().dataTaskWithURL(verURL) { (data, response, error) -> Void in
            debugPrint("web task completed.. ")
            if let urlContent = data {
                let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
                debugPrint(webContent)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    webVer = Float(String(webContent!))!
                    if webVer > dataVer {
                        dataVer = webVer
                        // 내부 json이 아닌 web 상의 json을 읽는다.
                        debugPrint(dataVer)
                        var webData = self.downloadJSONFromWeb(NSURL(string: "http://seoddong.myaxler.com/songahbie/MathAvengers/TB_LEVEL.json")!)
                        self.initTB_LEVEL(webData)
                        webData = self.downloadJSONFromWeb(NSURL(string: "http://seoddong.myaxler.com/songahbie/MathAvengers/TB_SETTINGS.json")!)
                        self.initTB_SETTINGS(webData)
                    }
                    else {
                        self.initTB_LEVEL(nil)
                        self.initTB_SETTINGS(nil)
                    }
                })
            }
            else {
                // 네트워크 연결이 되지 않던가 뭐..
                debugPrint("web error = [\(error?.localizedDescription)]")
            }
        }
        task.resume()
    }
    
    func downloadJSONFromWeb(url: NSURL) -> NSData? {
        var urlData: NSData?
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
            debugPrint("download web task completed.. ")
            if let webData = data {
                urlData = webData
            }
            else {
                // 네트워크 연결이 되지 않던가 뭐..
                debugPrint("web error = [\(error?.localizedDescription)]")
            }
        }
        task.resume()
        return urlData
    }
    
    
    
}