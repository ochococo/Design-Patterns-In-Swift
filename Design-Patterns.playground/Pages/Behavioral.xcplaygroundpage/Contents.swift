//: [行为型模式] |
//: [创建型模式](Creational) |
//: [结构型模式](Structural)
/*:
 行为型模式
 ========
 
 >在软件工程中， 行为型模式为设计模式的一种类型，用来识别对象之间的常用交流模式并加以实现。如此，可在进行这些交流活动时增强弹性。
 >
 >**来源：** [维基百科](https://zh.wikipedia.org/wiki/%E8%A1%8C%E7%82%BA%E5%9E%8B%E6%A8%A1%E5%BC%8F)
 */
import Swift
import Foundation
/*:
 责任链（Chain Of Responsibility）
 ------------------------------
 
 责任链模式在面向对象程式设计里是一种软件设计模式，它包含了一些命令对象和一系列的处理对象。每一个处理对象决定它能处理哪些命令对象，它也知道如何将它不能处理的命令对象传递给该链中的下一个处理对象。
 
 ### 示例：
 */
final class MoneyPile {
    
    let value: Int
    var quantity: Int
    var nextPile: MoneyPile?
    
    init(value: Int, quantity: Int, nextPile: MoneyPile?) {
        self.value = value
        self.quantity = quantity
        self.nextPile = nextPile
    }
    
    func canWithdraw(amount: Int) -> Bool {
        
        var amount = amount
        
        func canTakeSomeBill(want: Int) -> Bool {
            return (want / self.value) > 0
        }
        
        var quantity = self.quantity
        
        while canTakeSomeBill(want: amount) {
            
            if quantity == 0 {
                break
            }
            
            amount -= self.value
            quantity -= 1
        }
        
        guard amount > 0 else {
            return true
        }
        
        if let next = self.nextPile {
            return next.canWithdraw(amount: amount)
        }
        
        return false
    }
}

final class ATM {
    private var hundred: MoneyPile
    private var fifty: MoneyPile
    private var twenty: MoneyPile
    private var ten: MoneyPile
    
    private var startPile: MoneyPile {
        return self.hundred
    }
    
    init(hundred: MoneyPile,
         fifty: MoneyPile,
         twenty: MoneyPile,
         ten: MoneyPile) {
        
        self.hundred = hundred
        self.fifty = fifty
        self.twenty = twenty
        self.ten = ten
    }
    
    func canWithdraw(amount: Int) -> String {
        return "能否取现：\(self.startPile.canWithdraw(amount: amount))"
    }
}
/*:
 ### 用法：
 */
// 创建一系列的钱堆，并将其链接起来：10<20<50<100
let ten = MoneyPile(value: 10, quantity: 6, nextPile: nil)
let twenty = MoneyPile(value: 20, quantity: 2, nextPile: ten)
let fifty = MoneyPile(value: 50, quantity: 2, nextPile: twenty)
let hundred = MoneyPile(value: 100, quantity: 1, nextPile: fifty)

// 创建 ATM 实例
var atm = ATM(hundred: hundred, fifty: fifty, twenty: twenty, ten: ten)
atm.canWithdraw(amount: 310)
atm.canWithdraw(amount: 100)
atm.canWithdraw(amount: 165)
atm.canWithdraw(amount: 30)

/*:
 > 更多示例：[Design Patterns in Swift](https://github.com/kingreza/Swift-Chain-Of-Responsibility)
 */
/*:
 命令（Command）
 ------------
 命令模式是一种设计模式，它尝试以对象来代表实际行动。命令对象可以把行动(action) 及其参数封装起来，于是这些行动可以被：
 * 重复多次
 * 取消（如果该对象有实现的话）
 * 取消后又再重做
 ### 示例：
 */
protocol DoorCommand {
    func execute() -> String
}

class OpenCommand: DoorCommand {
    let doors: String
    
    required init(doors: String) {
        self.doors = doors
    }
    
    func execute() -> String {
        return "\(doors)打开了"
    }
}

class CloseCommand: DoorCommand {
    let doors: String
    
    required init(doors: String) {
        self.doors = doors
    }
    
    func execute() -> String {
        return "\(doors)关闭了"
    }
}

class ZhimaDoorsOperations {
    let openCommand: DoorCommand
    let closeCommand: DoorCommand
    
    init(doors: String) {
        self.openCommand = OpenCommand(doors: doors)
        self.closeCommand = CloseCommand(doors: doors)
    }
    
    func close() -> String {
        return closeCommand.execute()
    }
    
    func open() -> String {
        return openCommand.execute()
    }
}
/*:
 ### 用法：
 */
let zhimaDoors = "芝麻门"
let doorModule = ZhimaDoorsOperations(doors: zhimaDoors)

doorModule.open()
doorModule.close()
/*:
 解释器（Interpreter）
 ------------------
 给定一种语言，定义他的文法的一种表示，并定义一个解释器，该解释器使用该表示来解释语言中句子。
 ### 示例：
 */
protocol IntegerExpression {
    func evaluate(_ context: IntegerContext) -> Int
    func replace(character: Character, integerExpression: IntegerExpression) -> IntegerExpression
    func copied() -> IntegerExpression
}

final class IntegerContext {
    private var data: [Character: Int] = [:]
    
    func lookup(name: Character) -> Int {
        return self.data[name]!
    }
    
    func assign(expression: IntegerVariableExpression, value: Int)  {
        self.data[expression.name] = value
    }
}

final class IntegerVariableExpression: IntegerExpression {
    let name: Character
    
    init(name: Character) {
        self.name = name
    }
    
    func evaluate(_ context: IntegerContext) -> Int {
        return context.lookup(name: self.name)
    }
    
    func replace(character name: Character, integerExpression: IntegerExpression) -> IntegerExpression {
        if name == self.name {
            return integerExpression.copied()
        } else {
            return IntegerVariableExpression(name: self.name)
        }
    }
    
    func copied() -> IntegerExpression {
        return IntegerVariableExpression(name: self.name)
    }
}

final class AddExpression: IntegerExpression {
    private var operand1: IntegerExpression
    private var operand2: IntegerExpression
    
    init(op1: IntegerExpression, op2: IntegerExpression) {
        self.operand1 = op1
        self.operand2 = op2
    }
    
    func evaluate(_ context: IntegerContext) -> Int {
        return self.operand1.evaluate(context) + self.operand2.evaluate(context)
    }
    
    func replace(character: Character, integerExpression: IntegerExpression) -> IntegerExpression {
        return AddExpression(op1: operand1.replace(character: character, integerExpression: integerExpression), op2: operand2.replace(character: character, integerExpression: integerExpression))
    }
    
    func copied() -> IntegerExpression {
        return AddExpression(op1: self.operand1, op2: self.operand2)
    }
}
/*:
 ### 用法：
 */
var context = IntegerContext()

var a = IntegerVariableExpression(name: "A")
var b = IntegerVariableExpression(name: "B")
var c = IntegerVariableExpression(name: "C")

var expression = AddExpression(op1: a, op2: AddExpression(op1: b, op2: c))

context.assign(expression: a, value: 2)
context.assign(expression: b, value: 1)
context.assign(expression: c, value: 3)

var result = expression.evaluate(context)

/*:
 > 更多示例：[Design Patterns in Swift](https://github.com/kingreza/Swift-Interpreter)
 */
/*:
 迭代器（Iterator）
 ---------------
 迭代器模式可以让用户通过特定的接口巡访容器中的每一个元素而不用了解底层的实现。
 ### 示例：
 */
struct Novella {
    let name: String
}

struct Novellas {
    let novellas: [Novella]
}

struct NovellasIterator: IteratorProtocol {
    
    private var current = 0
    private let novellas: [Novella]
    
    init(novellas: [Novella]) {
        self.novellas = novellas
    }
    
    mutating func next() -> Novella? {
        defer { current += 1 }
        return novellas.count > current ? novellas[current] : nil
    }
}

extension Novellas: Sequence {
    func makeIterator() -> NovellasIterator {
        return NovellasIterator(novellas: novellas)
    }
}
/*:
 ### 用法：
 */
let greatNovellas = Novellas(novellas: [Novella(name:"红楼梦")])
for novella in greatNovellas {
    print("我读了\(novella.name)")
}
/*:
 中介者（Mediator）
 ---------------
 用一个中介者对象封装一系列的对象交互，中介者使各对象不需要显示地相互作用，从而使耦合松散，而且可以独立地改变它们之间的交互。
 ### 示例：
 */
struct Programmer {
    let name: String
    
    init(name: String) {
        self.name = name
    }
    
    func receive(message: String) {
        print("\(name) 收到消息：\(message)")
    }
}

protocol MessageSending {
    func send(message: String)
}

final class MessageMediator: MessageSending {
    
    private var recipients: [Programmer] = []
    
    func add(recipient: Programmer) {
        recipients.append(recipient)
    }
    
    func send(message: String) {
        for recipient in recipients {
            recipient.receive(message: message)
        }
    }
}
/*:
 ### 用法：
 */
func spamMonster(message: String, worker: MessageSending) {
    worker.send(message: message)
}

let messagesMediator = MessageMediator()

let user0 = Programmer(name: "Linus Torvalds")
let user1 = Programmer(name: "Dylan Wang")
messagesMediator.add(recipient: user0)
messagesMediator.add(recipient: user1)

spamMonster(message: "我希望添加您到我的职业网络", worker: messagesMediator)
/*:
 > 更多示例：[Design Patterns in Swift](https://github.com/kingreza/Swift-Mediator)
 */
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
/*:
 观察者（Observer）
 ---------------
 一个目标对象管理所有相依于它的观察者对象，并且在它本身的状态改变时主动发出通知
 ### 示例：
 */
protocol PropertyObserver: class {
    func willChange(propertyName: String, newPropertyValue: Any?)
    func didChange(propertyName: String, oldPropertyValue: Any?)
}

final class TestChambers {
    
    weak var observer: PropertyObserver?
    
    private let testChamberNumberName = "testChamberNumber"
    
    var testChamberNumber: Int = 0 {
        willSet(newValue) {
            observer?.willChange(propertyName: testChamberNumberName, newPropertyValue: newValue)
        }
        didSet {
            observer?.didChange(propertyName: testChamberNumberName, oldPropertyValue: oldValue)
        }
    }
}

final class Observer: PropertyObserver {
    func willChange(propertyName: String, newPropertyValue: Any?) {
        if newPropertyValue as? Int == 1{
            print("Okay. Look. We both said a lot of things that you're going to regret.")
        }
    }
    func didChange(propertyName: String, oldPropertyValue: Any?) {
        if oldPropertyValue as? Int == 0 {
            print("Sorry about the mess. I've really let the place go since you killed me.")
        }
    }
}
/*:
 ### 用法：
 */
var observer = Observer()
var testChambers = TestChambers()
testChambers.observer = observer
testChambers.testChamberNumber += 1
/*:
 > 更多示例：[Design Patterns in Swift](https://github.com/kingreza/Swift-Observer)
 */
/*:
 状态（State）
 ---------
 在状态模式中，对象的行为是基于它的内部状态而改变的
 ### 示例：
 */
final class Context {
    private var state: State = UnauthorizedState()
    
    var isAuthorized: Bool {
        get {
            return state.isAuthorized(context: self)
        }
    }
    
    var userId: String? {
        get {
            return state.userId(context: self)
        }
    }
    
    func changeStateToAuthorized(userId: String) {
        state = AuthorizedState(userId: userId)
    }
    
    func changeStateToUnauthorized() {
        state = UnauthorizedState()
    }
}

protocol State {
    func isAuthorized(context: Context) -> Bool
    func userId(context: Context) -> String?
}

class UnauthorizedState: State {
    func isAuthorized(context: Context) -> Bool { return false }
    
    func userId(context: Context) -> String? { return nil }
}

class AuthorizedState: State {
    let userId: String
    
    init(userId: String) { self.userId = userId }
    
    func isAuthorized(context: Context) -> Bool { return true }
    
    func userId(context: Context) -> String? { return userId }
}
/*:
 ### 用法：
 */
let userContext = Context()
(userContext.isAuthorized, userContext.userId)
userContext.changeStateToAuthorized(userId: "admin")
(userContext.isAuthorized, userContext.userId) // now logged in as "admin"
userContext.changeStateToUnauthorized()
(userContext.isAuthorized, userContext.userId)
/*:
 > 更多示例：[Design Patterns in Swift](https://github.com/kingreza/Swift-State)
 */
/*:
 策略（Strategy）
 --------------
 对象有某个行为，但是在不同的场景中，该行为有不同的实现算法。策略模式：
 * 定义了一族算法（业务规则）；
 * 封装了每个算法；
 * 这族的算法可互换代替（interchangeable）。
 ### 示例：
 */
protocol PrintStrategy {
    func print(_ string: String) -> String
}

final class Printer {
    
    private let strategy: PrintStrategy
    
    init(strategy: PrintStrategy) {
        self.strategy = strategy
    }
    
    func print(_ string: String) -> String {
        return self.strategy.print(string)
    }
}

final class UpperCaseStrategy: PrintStrategy {
    func print(_ string: String) -> String {
        return string.uppercased()
    }
}

final class LowerCaseStrategy: PrintStrategy {
    func print(_ string: String) -> String {
        return string.lowercased()
    }
}
/*:
 ### 用法
 */
var lower = Printer(strategy: LowerCaseStrategy())
lower.print("0 tempora, o mores")

var upper = Printer(strategy: UpperCaseStrategy())
upper.print("0 tempora, o mores")
/*:
 > 更多示例：[Design Patterns in Swift](https://github.com/kingreza/Swift-Strategy)
 */
/*:
 访问者（Visitor）
 --------------
 封装某些作用于某种数据结构中各元素的操作，它可以在不改变数据结构的前提下定义作用于这些元素的新的操作。
 ### 示例：
 */
protocol PlanetVisitor {
    func visit(planet: PlanetAlderaan)
    func visit(planet: PlanetCoruscant)
    func visit(planet: PlanetTatooine)
    func visit(planet: MoonJedah)
}

protocol Planet {
    func accept(visitor: PlanetVisitor)
}

class MoonJedah: Planet {
    func accept(visitor: PlanetVisitor) { visitor.visit(planet: self) }
}

class PlanetAlderaan: Planet {
    func accept(visitor: PlanetVisitor) { visitor.visit(planet: self) }
}

class PlanetCoruscant: Planet {
    func accept(visitor: PlanetVisitor) { visitor.visit(planet: self) }
}

class PlanetTatooine: Planet {
    func accept(visitor: PlanetVisitor) { visitor.visit(planet: self) }
}

class NameVisitor: PlanetVisitor {
    var name = ""
    
    func visit(planet: PlanetAlderaan)  { name = "Alderaan" }
    func visit(planet: PlanetCoruscant) { name = "Coruscant" }
    func visit(planet: PlanetTatooine)  { name = "Tatooine" }
    func visit(planet: MoonJedah)     	{ name = "Jedah" }
}
/*:
 ### 用法：
 */
let planets: [Planet] = [PlanetAlderaan(), PlanetCoruscant(), PlanetTatooine(), MoonJedah()]

let names = planets.map { (planet: Planet) -> String in
    let visitor = NameVisitor()
    planet.accept(visitor: visitor)
    return visitor.name
}

names
/*:
 > 更多示例：[Design Patterns in Swift](https://github.com/kingreza/Swift-Visitor)
 */
