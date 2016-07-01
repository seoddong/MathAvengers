//
//  MADocument.swift
//  MathAvengers
//
//  Created by SeoDongHee on 2016. 6. 30..
//  Copyright © 2016년 SeoDongHee. All rights reserved.
//

import UIKit

class MADocument: UIDocument {
    
    var userText: String? = "Some Sample Text"
    
    override func contentsForType(typeName: String) throws -> AnyObject {

        // default.realm을 읽어야 한다.
        let filemgr = NSFileManager.defaultManager()
        let dirPath = filemgr.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        debugPrint("filePath=\(dirPath)")
        let realmURL = dirPath[0].URLByAppendingPathComponent("default.realm")
        
        // NSFileWrapper를 만들기 위해 file을 NSData로 변환한다.
        if let content = NSData(contentsOfURL: realmURL) {
            
            let fileWrapper = NSFileWrapper(regularFileWithContents: content)
            debugPrint("contentsForType: fileWrapper=\(fileWrapper)")
            return fileWrapper
        }
        else {
            return NSData()
        }
    }
    
    override func loadFromContents(contents: AnyObject, ofType typeName: String?) throws {
        debugPrint("loadFromContents: typeName = \(typeName)")
        if let userContent = contents as? NSData {
            userText = NSString(bytes: contents.bytes,
                                length: userContent.length,
                                encoding: NSUTF8StringEncoding) as? String
        }
        
    }
    
    func saveToCloud(ubiquityURL: NSURL) {
        
        self.saveToURL(ubiquityURL, forSaveOperation: .ForOverwriting, completionHandler: {(success: Bool) -> Void in
            if success {
                print("Save overwrite OK")
            } else {
                print("Save overwrite failed")
            }
        })
    }
    
    func checkFileExist(documentURL: NSURL) {
        let filemgr = NSFileManager.defaultManager()
        if filemgr.fileExistsAtPath((documentURL.path)!) {
            self.openWithCompletionHandler({(success: Bool) -> Void in
                if success {
                    print("File open OK")
                    // 파일을 열었으니 뭔가 써야지..
                } else {
                    print("Failed to open file")
                }
            })
        } else {
            self.saveToURL(documentURL, forSaveOperation: .ForCreating, completionHandler: {(success: Bool) -> Void in
                if success {
                    print("File created OK")
                } else {
                    print("Failed to create file ")
                }
            })
        }
    }
    
}