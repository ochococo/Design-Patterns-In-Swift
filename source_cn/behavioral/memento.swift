/*:
 备忘录（Memento）
 --------------
 在不破坏封装性的前提下，捕获一个对象的内部状态，并在该对象之外保存这个状态。这样就可以将该对象恢复到原先保存的状态
 ### 示例：
 */
typealias Memento = NSDictionary
/*:
 发起人（Originator）
 */
protocol MementoConvertible {
    var memento: Memento { get }
    init?(memento: Memento)
}

struct GameState: MementoConvertible {
    
    private struct Keys {
        static let chapter = "com.valve.halflife.chapter"
        static let weapon = "com.valve.halflife.weapon"
    }
    
    var chapter: String
    var weapon: String
    
    init(chapter: String, weapon: String) {
        self.chapter = chapter
        self.weapon = chapter
    }
    
    init?(memento: Memento) {
        guard let mementoChapter = memento[Keys.chapter] as? String,
            let mementoWeapon = memento[Keys.weapon] as? String else {
                return nil
        }
        
        self.chapter = mementoChapter
        self.weapon = mementoWeapon
    }
    
    var memento: Memento {
        return [Keys.chapter: chapter,
                Keys.weapon: weapon]
    }
}
/*:
 管理者（Caretaker）
 */
enum CheckPoint {
    static func save(_ state: MementoConvertible, saveName: String) {
        let defaults = UserDefaults.standard
        defaults.set(state.memento, forKey: saveName)
        defaults.synchronize()
    }
    
    static func restore(saveName: String) -> Memento? {
        let defaults = UserDefaults.standard
        return defaults.object(forKey: saveName) as? Memento
    }
}
/*:
 ### 用法：
 */
var gameState = GameState(chapter: "Black Mesa Inbound", weapon: "Crowbar")

gameState.chapter = "Anomalous Materials"
gameState.weapon = "Glock 17"
CheckPoint.save(gameState, saveName: "gameState1")

gameState.chapter = "Unforeseen Consequences"
gameState.weapon = "MP5"
CheckPoint.save(gameState, saveName: "gameState2")

gameState.chapter = "Office Complex"
gameState.weapon = "Crossbow"
CheckPoint.save(gameState, saveName: "gameState3")

if let memento = CheckPoint.restore(saveName: "gameState1") {
    let finalState = GameState(memento: memento)
    dump(finalState)
}
