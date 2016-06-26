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
    
}
