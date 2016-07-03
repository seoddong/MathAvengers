//
//  GlobalSettings.swift
//  MathAvengers
//
//  Created by SeoDongHee on 2016. 7. 2..
//  Copyright © 2016년 SeoDongHee. All rights reserved.
//

struct GlobalSettings {
    
    static var cloudSaveYN: Bool {
        get {
            return self.cloudSaveYN
        }
        set (state) {
            self.cloudSaveYN = state
        }
    }
    
    static var user: String {
        get {
            return self.user
        }
        set (name) {
            self.user = name
        }
    }
    
}