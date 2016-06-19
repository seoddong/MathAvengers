import GameplayKit
import UIKit

class Util {
    func arrayShuffle(array: [AnyObject]) -> [AnyObject] {
        let array = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(array)
        return array
    }
    
    
    
}
