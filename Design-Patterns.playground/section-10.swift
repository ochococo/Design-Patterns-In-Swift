typealias Memento = Dictionary<NSObject, AnyObject>

/**
* Originator
*/
class GameState {
    var gameLevel: Int = 1
    var playerScore: Int = 0

    func saveToMemeto() -> Memento {
        return ["gameLevel": gameLevel, "playerScore": playerScore] 
    }

    func restoreFromMemeto(memento: Memento) {
        gameLevel = memento["gameLevel"]! as Int
        playerScore = memento["playerScore"]! as Int
    }
}

/**
* Caretaker
*/
class CheckPoint {
    class func saveState(memento: Memento, keyName: String = "gameState") {
        let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(memento, forKey: keyName)
        defaults.synchronize()
    }

    class func restorePreviousState(keyName: String = "gameState") -> Memento {
        let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()

        return defaults.objectForKey(keyName) as Memento
    }
}