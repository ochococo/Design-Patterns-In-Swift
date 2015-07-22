/*:
💾 Memento
----------

The memento pattern is used to capture the current state of an object and store it in such a manner that it can be restored at a later time without breaking the rules of encapsulation.

### Example
*/
typealias Memento = Dictionary<NSObject, AnyObject>

let DPMementoKeyChapter = "com.valve.halflife.chapter"
let DPMementoKeyWeapon = "com.valve.halflife.weapon"
let DPMementoGameState = "com.valve.halflife.state"
/*:
Originator
*/
class GameState {
    var chapter: String = ""
    var weapon: String = ""

    func toMemento() -> Memento {
        return [ DPMementoKeyChapter:chapter, DPMementoKeyWeapon:weapon ]
    }

    func restoreFromMemento(memento: Memento) {
        chapter = memento[DPMementoKeyChapter] as? String ?? "n/a"
        weapon = memento[DPMementoKeyWeapon] as? String ?? "n/a"
    }
}
/*:
Caretaker
*/
class CheckPoint {
    class func saveState(memento: Memento, keyName: String = DPMementoGameState) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(memento, forKey: keyName)
        defaults.synchronize()
    }

    class func restorePreviousState(keyName keyName: String = DPMementoGameState) -> Memento {
        let defaults = NSUserDefaults.standardUserDefaults()

        return defaults.objectForKey(keyName) as? Memento ?? Memento()
    }
}
/*:
 ### Usage
*/
var gameState = GameState()
gameState.restoreFromMemento(CheckPoint.restorePreviousState())

gameState.chapter = "Black Mesa Inbound"
gameState.weapon = "Crowbar"
CheckPoint.saveState(gameState.toMemento())

gameState.chapter = "Anomalous Materials"
gameState.weapon = "Glock 17"
gameState.restoreFromMemento(CheckPoint.restorePreviousState())

gameState.chapter = "Unforeseen Consequences"
gameState.weapon = "MP5"
CheckPoint.saveState(gameState.toMemento(), keyName: "gameState2")

gameState.chapter = "Office Complex"
gameState.weapon = "Crossbow"
CheckPoint.saveState(gameState.toMemento())

gameState.restoreFromMemento(CheckPoint.restorePreviousState(keyName: "gameState2"))

