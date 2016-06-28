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
        let jsonFilePath = NSBundle.mainBundle().pathForResource("TB_LEVEL", ofType: "json")
        
        do
        {
            let jsonData = try NSData(contentsOfFile: jsonFilePath!, options: NSDataReadingOptions(rawValue: 0))
            let json = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions()) as! NSArray

            
            let realm = try Realm()
            try! realm.write
            {
                for each in json
                {
                    realm.create(TB_LEVEL.self, value: [each["level"] as! Int, each["levelDesc"] as! String, each["imageURL"] as! String])
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
}