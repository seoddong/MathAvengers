import GameplayKit
import UIKit

class Util {
    func arrayShuffle(array: [AnyObject]) -> [AnyObject] {
        let array = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(array)
        return array
    }
    
    func printFonts() {
        for familyName in UIFont.familyNames() {
            print("familyName=\(familyName)")
            for fontname in UIFont.fontNamesForFamilyName(familyName) {
                print("fontname=\(fontname)")
            }
        }
    }
    
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
    
}
