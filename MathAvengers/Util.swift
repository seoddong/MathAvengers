import GameplayKit
import UIKit

class Util {
    
    /**
     Shuffle array. It can be by GameplayKit (GKRandomSource.sharedRandom).
     
     - parameter array: Any array
     
     - returns: Suffled array
     */
    func arrayShuffle(array: [AnyObject]) -> [AnyObject] {
        let array = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(array)
        return array
    }
    
    
    /**
     Print all supported fonts.
     */
    func printFonts() {
        for familyName in UIFont.familyNames() {
            print("familyName=\(familyName)")
            for fontname in UIFont.fontNamesForFamilyName(familyName) {
                print("fontname=\(fontname)")
            }
        }
    }
    
    
    /**
     Show alert message box.
     
     - parameter title:   Set title
     - parameter message: Set description message
     - parameter ok:      Set ok button
     - parameter cancel:  Set cancel button
     
     - returns: UIAlertController
     */
    func alert(title: String, message: String, ok: String, cancel: String?) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        if let cancel = cancel {
            
            let DestructiveAction = UIAlertAction(title: cancel, style: UIAlertActionStyle.Destructive) { (result : UIAlertAction) -> Void in
                //print("취소")
            }
            alertController.addAction(DestructiveAction)
        }
        
        let okAction = UIAlertAction(title: ok, style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
            //print("확인")
        }
        alertController.addAction(okAction)
        
        return alertController
    }
    
    /**
     Get all directory of the Path
     
     - parameter path: The path you want to know
     
     - returns: An array of directory in the path
     */
    func contentsOfDirectoryAtPath(path: String) -> [String]? {
        guard let paths = try? NSFileManager.defaultManager().contentsOfDirectoryAtPath(path) else { return nil}
        return paths.map { aContent in (path as NSString).stringByAppendingPathComponent(aContent)}
    }
    
    
    /**
     Remove all files at the path
     
     - parameter path: The path you want to delete all in
     */
    func removeRealmFilesAtPath(path: String) {
        do {
            let files = self.contentsOfDirectoryAtPath(path)!
            _ = files.map {
                if $0.rangeOfString("default.realm") != nil {
                    do {
                        try NSFileManager.defaultManager().removeItemAtPath($0)
                    }
                    catch let error as NSError {
                        debugPrint("error: \(error.localizedFailureReason)")
                    }
                }
            }
        }
    }
    
    /**
     Get bundle realm url
     
     - parameter name: realm name
     
     - returns: The path of .realm file
     */
    func bundleRealmURL(name: String) -> NSURL? {
        return NSBundle.mainBundle().URLForResource(name, withExtension: "realm")
    }
    
    
    func cloudPressed() {
        let filemgr = NSFileManager.defaultManager()
        
        var ubiquityURL = filemgr.URLForUbiquityContainerIdentifier(nil)
        guard ubiquityURL != nil else {
            debugPrint("Unable to access iCloud Account")
            debugPrint("Open the Settings app and enter your Apple ID into iCloud settings")
            return
        }
        
        ubiquityURL = ubiquityURL?.URLByAppendingPathComponent("Documents/default.realm")
        debugPrint("ubiquityURL=\(ubiquityURL)")
        
        // iCloud storage를 검색할 조건과 검색 범위를 지정
        let metaDataQuery = NSMetadataQuery()
        metaDataQuery.predicate = NSPredicate(format: "%K like 'default.realm'", NSMetadataItemFSNameKey)
        metaDataQuery.searchScopes = [NSMetadataQueryUbiquitousDocumentsScope]
        
        // 검색이 끝나면 결과를 알려줄 noti 설정
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainViewController.metadataQueryDidFinishGathering), name: NSMetadataQueryDidFinishGatheringNotification, object: metaDataQuery)
        
        let state = metaDataQuery.startQuery()
        debugPrint("state=\(state)")
        
        //        let dirPath = filemgr.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first
        //        // dirPath=[file:///Users/seoddong/Library/Developer/CoreSimulator/Devices/CAE86DB6-92BC-44D3-93D0-F5D4826B54D5/data/Containers/Data/Application/1AA46834-C0FC-43A5-8D41-F3BEA3B048BD/Documents/]
        //        if let path = dirPath {
        //            let documentURL = path.URLByAppendingPathComponent("default.realm")
        //            let maDoc = MADocument(fileURL: documentURL)
        //            maDoc.checkFileExist(documentURL)
        //        }
        //        else {
        //            debugPrint("There is no Document folder..")
        //        }
        
    }
    
}

// String Extension
let whitespaceAndNewlineChars: [Character] = ["\n", "\r", "\t", " "]
extension String {
    func rtrim() -> String {
        if isEmpty { return "" }
        var i = endIndex
        while i >= startIndex {
            i = i.predecessor()
            let c = self[i]
            if !whitespaceAndNewlineChars.contains(c) {
                break
            }
        }
        return self[startIndex...i]
    }
    
    func ltrim() -> String {
        if isEmpty { return "" }
        var i = startIndex
        while i < endIndex {
            let c = self[i]
            if !whitespaceAndNewlineChars.contains(c) {
                break
            }
            i = i.successor()
        }
        return self[i..<endIndex]
    }
    
    func trim() -> String {
        return ltrim().rtrim()
    }
   
    // Returns true if the string has at least one character in common with matchCharacters.
    func containsCharactersIn(matchCharacters: String) -> Bool {
        let characterSet = NSCharacterSet(charactersInString: matchCharacters)
        return self.rangeOfCharacterFromSet(characterSet) != nil
    }
    
    // Returns true if the string contains only characters found in matchCharacters.
    func containsOnlyCharactersIn(matchCharacters: String) -> Bool {
        let disallowedCharacterSet = NSCharacterSet(charactersInString: matchCharacters).invertedSet
        return self.rangeOfCharacterFromSet(disallowedCharacterSet) == nil
    }
    
    // Returns true if the string has no characters in common with matchCharacters.
    func doesNotContainCharactersIn(matchCharacters: String) -> Bool {
        let characterSet = NSCharacterSet(charactersInString: matchCharacters)
        return self.rangeOfCharacterFromSet(characterSet) == nil
    }
    
    // Returns true if the string represents a proper numeric value.
    // This method uses the device's current locale setting to determine
    // which decimal separator it will accept.
    func isNumeric() -> Bool
    {
        let scanner = NSScanner(string: self)
        
        // A newly-created scanner has no locale by default.
        // We'll set our scanner's locale to the user's locale
        // so that it recognizes the decimal separator that
        // the user expects (for example, in North America,
        // "." is the decimal separator, while in many parts
        // of Europe, "," is used).
        scanner.locale = NSLocale.currentLocale()
        
        return scanner.scanDecimal(nil) && scanner.atEnd
    }
    
}
