//
//  Realms.swift
//  MathAvengers
//
//  Created by SeoDongHee on 2016. 6. 21..
//  Copyright © 2016년 SeoDongHee. All rights reserved.
//

import Foundation
import RealmSwift

class Realms {
    
    func retreiveTB_RESULTLOG(predicate: NSPredicate) -> Results<TB_RESULTLOG> {
        let realm = try! Realm()
        let results = try! realm.objects(TB_RESULTLOG.self).filter(predicate).sorted("playdt", ascending: false)
        
        return results
    }
}

class TB_RESULTLOG: Object {
    dynamic var answer = ""
    dynamic var question = ""
    dynamic var level = ""
    dynamic var result = false
    dynamic var playdt = NSDate()
    dynamic var user = "songahbie"
}