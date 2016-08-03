//
//  CloudViewController.swift
//  MathAvengers
//
//  Created by SeoDongHee on 2016. 7. 20..
//  Copyright © 2016년 SeoDongHee. All rights reserved.
//

/* 2 */
import UIKit

class CloudViewController: UIViewController {
    
    let statusLabel = UILabel()
    
    let metadataQuery = NSMetadataQuery()
    let fileManager = NSFileManager()
    var cloudDocumentsDirectory: NSURL?
    
    enum commandType: Int {
        case download = 0, store, retrieve, storeWithReturn, downloadWithReturn, storeToRoot
    }
    var command: commandType?
    let filename = "default.realm"
    
    func initialize() {
        
        // 클라우드 기본 디렉토리 정보 획득
        let cloudBaseURL = fileManager.URLForUbiquityContainerIdentifier(nil)
        guard cloudBaseURL != nil else {
            debugPrint("Unable to access iCloud Account")
            debugPrint("Open the Settings app and enter your Apple ID into iCloud settings")
            return
        }
        cloudDocumentsDirectory = cloudBaseURL?.URLByAppendingPathComponent("Documents")
        
    }
    
    override func viewDidLoad() {
        initialize()
        setupUI()
        
        
        // download와 store 시에 스마트하게 처리할 수 있는 방안이 떠오르질 않는다. 일단 임시로 아래와 같이 코드를 작성함
        // 이렇게 하는 이유는 startQuery의 결과를 두 가지 용도로 사용하기 때문이다.
        // 파라미터로 파일명을 받으면 해당 파일을 다운받지만 파일명이 없으면 그냥 파일 목록을 조회하려 함이다.
        switch self.command! {
        case commandType.download:
            // download
            downloadFile(filename)
            break
        case commandType.store:
            // store file
            storeFile(filename)
            break
        case commandType.retrieve:
            startQuery(nil)
            break
        case commandType.downloadWithReturn:
            // download
            downloadFile(filename)
            self.navigationController?.popViewControllerAnimated(true)
            break
        case commandType.storeWithReturn:
            // store file
            storeFile(filename)
            self.navigationController?.popViewControllerAnimated(true)
            break
        case commandType.storeToRoot:
            // store file
            storeFile(filename)
            self.navigationController?.popToRootViewControllerAnimated(true)
            break
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - setupUI
    func setupUI() {
        self.view.backgroundColor = UIColor.whiteColor()
        
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.backgroundColor = UIColor.whiteColor()
        statusLabel.textAlignment = .Center
        statusLabel.lineBreakMode = .ByWordWrapping
        statusLabel.numberOfLines = 0
        statusLabel.font = UIFont(name: "Verdana", size: 40)
        
        self.view.addSubview(statusLabel)
        
        statusLabel.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor).active = true
        statusLabel.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor).active = true
        
        
        
    }
    
    // MARK: - Actions
    func downloadFile(fileName: String) {
        debugPrint("Downloading a cloud file in the local directory...")
        if let directory = cloudDocumentsDirectory{
            let destinationUrl = directory.URLByAppendingPathComponent(fileName)
            
            // filename이 있으면 download한다.
            if fileManager.fileExistsAtPath(destinationUrl.path!) {
                do{
                    // local file URL
                    let dirPath = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first
                    var localURL: NSURL?
                    if let path = dirPath {
                        localURL = path.URLByAppendingPathComponent(fileName)
                    }
                    // local에 이미 파일이 있다면..
                    if fileManager.fileExistsAtPath(localURL!.path!) {
                        // remove local file
                        try fileManager.removeItemAtURL(localURL!)
                    }
                    
                    try fileManager.copyItemAtURL(destinationUrl, toURL: localURL!)
                    debugPrint("Successfully copied the cloud file to the local...")
                    statusLabel.text = "Download is OK".localize()
                    
                    
                    // 클라우드 데이터를 가져왔을 때 level 데이터가 틀어질 수 있으므로 level 데이터만 json에서 다시 가져온다.
                    let json = ImportJSON()
                    json.checkVersion()

                }
                catch let err as NSError{
                    //error handling
                    debugPrint("err = \(err.localizedDescription)")
                    statusLabel.text = "Download id Failed..".localize()
                }
            }
        }
    }
    
    func storeFile(fileName: String) -> Bool {
        debugPrint("Storing a file in the cloud directory...")

        if let directory = cloudDocumentsDirectory{
            
            let destinationUrl = directory.URLByAppendingPathComponent(fileName)
            
            let dirPath = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first
            if let path = dirPath {
                let localURL = path.URLByAppendingPathComponent(fileName)
                debugPrint("Now moving this file into the cloud...")
                
                // local file을 클라우드에 저장
                if !doesDocumentsDirectoryExist(directory) {
                    // 없으면 폴더를 만들어야지
                    var directoryCreationError: NSError?
                    do {
                        try fileManager.createDirectoryAtPath(directory.path!,
                                                              withIntermediateDirectories:true,
                                                              attributes:nil)
                        debugPrint("Successfully created the folder")
                        
                    } catch let error1 as NSError {
                        directoryCreationError = error1
                        if let error = directoryCreationError{
                            debugPrint("Failed to create the folder with error = \(error)")
                        }
                    }
                }
                
                
                var savingError: NSError?
                do {
                    // 같은 파일이 있는지 확인
                    if fileManager.fileExistsAtPath(destinationUrl.path!) {
                        // 있으면 파일 제거
                        debugPrint("remove target file in the cloud...")
                        try fileManager.removeItemAtURL(destinationUrl)
                    }

                    try fileManager.copyItemAtURL(localURL, toURL: destinationUrl)
                    debugPrint("Successfully copied the file to the cloud...")
                    statusLabel.text = "Saving is OK".localize()
                    return true
                } catch let error1 as NSError {
                    savingError = error1
                    if let error = savingError {
                        debugPrint("Failed to move the file to the cloud = \(error)")
                        statusLabel.text = "Saving is Failed..".localize()
                    }
                }
            }
            else {
                debugPrint("There is no Document folder..")
            }
            
        } else {
            debugPrint("The directory was nil: \(cloudDocumentsDirectory)")
        }
        return false
    }
    
    func doesDocumentsDirectoryExist(targetDirectory: NSURL?) -> Bool{
        var isDirectory = false as ObjCBool
        
        if let directory = targetDirectory {

            if fileManager.fileExistsAtPath(directory.path!, isDirectory: &isDirectory){
                if isDirectory{
                    return true
                }
            }
        }
        
        return false
    }

    
    // MARK: - metadataQuery
    func startQuery(fileName: String?){
        debugPrint("Starting the query now...")
        
        metadataQuery.searchScopes = [NSMetadataQueryUbiquitousDocumentsScope]
        if let filename = fileName {
            let predicate = NSPredicate(format: "%K like %@",
                                        NSMetadataItemFSNameKey,
                                        filename)
            
            metadataQuery.predicate = predicate
        }
        
        debugPrint("Listening for notifications...")
        /* Listen for a notification that gets fired when the metadata query
         has finished finding the items we were looking for */
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(handleMetadataQueryFinished),
                                                         name: NSMetadataQueryDidFinishGatheringNotification,
                                                         object: nil)
        

        if metadataQuery.startQuery(){
            debugPrint("Successfully started the query.")
        } else {
            debugPrint("Failed to start the query.")
        }
    }
    
    
    /**
     클라우드의 documents 폴더 내용 검색
     
     - parameter notification: notification
     */
    func handleMetadataQueryFinished(notification: NSNotification){
        
        debugPrint("Search finished");

        let query = notification.object as! NSMetadataQuery
        query.disableUpdates()
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSMetadataQueryDidFinishGatheringNotification, object: query)
        query.stopQuery()
        
        let results = query.results
        if results.count == 0 {
            statusLabel.text = "No files in iCloud.".localize()
            return
        }

        
        for item in results as! [NSMetadataItem]{
            
            let itemName = item.valueForAttribute(NSMetadataItemFSNameKey) as! String
            let itemUrl = item.valueForAttribute(NSMetadataItemURLKey) as! NSURL
            let itemSize = item.valueForAttribute(NSMetadataItemFSSizeKey) as! Int
            let itemContentChangeDate = item.valueForAttribute(NSMetadataItemFSContentChangeDateKey) as! NSDate
            let itemCreationDate = item.valueForAttribute(NSMetadataItemFSCreationDateKey) as! NSDate
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
            
            
            debugPrint("Item name = \(itemName)")
            debugPrint("Item url = \(itemUrl)")
            debugPrint("Item size = \(itemSize)")
            debugPrint("Item MDate = \(String(dateFormatter.stringFromDate(itemContentChangeDate)))")
            debugPrint("Item CDate = \(String(dateFormatter.stringFromDate(itemCreationDate)))")
            
            statusLabel.text! += "\(itemName)\n"

        }
        
    }

    
}