//
//  AppDelegate.swift
//  MathAvengers
//
//  Created by SeoDongHee on 2016. 6. 16..
//  Copyright © 2016년 SeoDongHee. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "level")
        // 앱 설치 시 JSON 파일을 읽어 초기 데이터를 Realm에 세팅한다.
        if !didFinishLaunchingOnce() {

            let realms = Realms()
            if case let cnt = realms.countTB_LEVEL() where cnt == 0 {
                let json = ImportJSON()
                json.initTB_LEVEL(nil)
                json.initTB_SETTINGS(nil)

            }
        }
        
        let json = ImportJSON()
        json.checkVersion()
        
        return true
    }

    
    func didFinishLaunchingOnce() -> Bool
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if defaults.stringForKey("hasAppBeenLaunchedBefore") != nil {
            print(" N-th time app launched ")
            return true
        }
        else {
            print(" First time app launched ")
            defaults.setBool(true, forKey: "hasAppBeenLaunchedBefore")
            return false
        }
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }


}

