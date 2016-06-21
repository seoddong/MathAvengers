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
    
}
