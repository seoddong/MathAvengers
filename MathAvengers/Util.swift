import GameplayKit
import UIKit

func arrayShuffle(array: [AnyObject]) -> [AnyObject] {
    let array = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(array)
    return array
}
