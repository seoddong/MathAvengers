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
    
    func countTB_LEVEL() -> Int {
        let realm = try! Realm()
        let results = try! realm.objects(TB_LEVEL.self)
        
        return results.count
    }
    
    func retreiveTB_LEVEL() -> Results<TB_LEVEL> {
        let realm = try! Realm()
        let results = try! realm.objects(TB_LEVEL.self).sorted("level")

        
        return results
    }
    
    func countTB_SETTINS() -> Int {
        let realm = try! Realm()
        let results = try! realm.objects(TB_SETTINGS.self)
        
        return results.count
    }
    
    func retreiveTB_SETTINGS() -> Results<TB_SETTINGS> {
        let realm = try! Realm()
        let results = try! realm.objects(TB_SETTINGS.self).sorted("seq")
        
        
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

class TB_LEVEL: Object {
    dynamic var level = 0
    dynamic var levelDesc = ""
    dynamic var imageURL = ""

}

class TB_SETTINGS: Object {
    dynamic var seq = 0
    dynamic var section = ""
    dynamic var cellType = ""
    dynamic var desc = ""
}




