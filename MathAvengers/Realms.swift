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
    
    func retreiveCurrentTB_USER() -> Results<TB_USER> {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "currentYN == %@", true)
        
        var results = try! realm.objects(TB_USER.self).filter(predicate)
        if results.count == 0 {
            results = try! realm.objects(TB_USER.self)
            if results.count == 0 {
                return results
            }
            else {
                try! realm.write({
                    // 첫 번째 사용자의 currentYN을 true로 변경
                    realm.create(TB_USER.self, value: ["userName": results[0].userName, "age": results[0].age, "regidt": NSDate(), "currentYN": true], update: true)
                    //이 함수를 다시 호출
                    results = try! realm.objects(TB_USER.self).filter(predicate)
                })
            }
        }
        
        return results
    }
    
    func retreiveTB_USERs() -> Results<TB_USER> {
        let realm = try! Realm()
        let results = try! realm.objects(TB_USER.self).sorted("regidt", ascending: false)
        return results
    }
    
    func updateTB_USER(userName: String, bestScore: Int) {
        let realm = try! Realm()
        
        let result = try! realm.objects(TB_USER.self).sorted("bestScore", ascending: false).first
        var bestScore = bestScore
        if let score = result?.bestScore {
            bestScore = bestScore > score ? bestScore : score
        }
        
        try! realm.write({
            realm.create(TB_USER.self, value: ["userName": userName, "lastPlaydt": NSDate(), "bestScore": bestScore], update: true)
        })
    }
    
    func updateStateTB_USER(userName: String) {
        let realm = try! Realm()
        
        let results = try! realm.objects(TB_USER.self).filter("currentYN = true")
        try! realm.write({
            for result in results {
                realm.create(TB_USER.self, value: ["userName": result.userName, "currentYN": false], update: true)
            }
            
            realm.create(TB_USER.self, value: ["userName": userName, "currentYN": true], update: true)
        })
        
    }
    
    
}

class TB_RESULTLOG: Object {
    dynamic var answer = ""
    dynamic var question = ""
    dynamic var level = ""
    dynamic var result = false
    dynamic var playdt = NSDate()
    dynamic var user = ""
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

class TB_USER: Object {
    dynamic var userName = ""
    dynamic var age = 0
    dynamic var regidt = NSDate()
    dynamic var currentYN = false
    dynamic var lastPlaydt = NSDate()
    dynamic var bestScore = 0
    
    override static func primaryKey() -> String? {
        return "userName"
    }
}


