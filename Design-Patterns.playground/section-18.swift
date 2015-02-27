typealias Memento = Dictionary<NSObject, AnyObject>

let DPMementoKeyChapter = "com.valve.halflife.chapter"
let DPMementoKeyWeapon = "com.valve.halflife.weapon"
let DPMementoGameState = "com.valve.halflife.state"

/**
* Originator
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

/**
* Caretaker
*/
class CheckPoint {
    class func saveState(memento: Memento, keyName: String = DPMementoGameState) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(memento, forKey: keyName)
        defaults.synchronize()
    }

    class func restorePreviousState(keyName: String = DPMementoGameState) -> Memento {
        let defaults = NSUserDefaults.standardUserDefaults()

        return defaults.objectForKey(keyName) as? Memento ?? Memento()
    }
}