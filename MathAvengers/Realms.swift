//
//  Realms.swift
//  MathAvengers
//
//  Created by SeoDongHee on 2016. 6. 21..
//  Copyright © 2016년 SeoDongHee. All rights reserved.
//

import Foundation
import RealmSwift

class Realms: Object {
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}

class TB_RESULTLOG: Object {
    dynamic var answer = ""
    dynamic var question = ""
    dynamic var level = ""
    dynamic var result = false
    dynamic var playdt = NSDate()
    dynamic var user = "songahbie"
}