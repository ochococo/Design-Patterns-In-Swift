
设计模式
========================================

本项目翻译自 [@nsmeme](http://twitter.com/nsmeme) (Oktawian Chojnacki) 的「[源项目](https://github.com/ochococo/Design-Patterns-In-Swift)」

## 目录

* [行为型模式](#behavioral)
* [创建型模式](#creational)
* [结构型模式](#structural)


```swift

 [行为型模式] |
 [创建型模式](Creational) |
 [结构型模式](Structural)
```

 行为型模式
 ========
 
 >在软件工程中， 行为型模式为设计模式的一种类型，用来识别对象之间的常用交流模式并加以实现。如此，可在进行这些交流活动时增强弹性。
 >
 >**来源：** [维基百科](https://zh.wikipedia.org/wiki/%E8%A1%8C%E7%82%BA%E5%9E%8B%E6%A8%A1%E5%BC%8F)
 
```swift

import Swift
import Foundation
```

 责任链（Chain Of Responsibility）
 ------------------------------
 
 责任链模式在面向对象程式设计里是一种软件设计模式，它包含了一些命令对象和一系列的处理对象。每一个处理对象决定它能处理哪些命令对象，它也知道如何将它不能处理的命令对象传递给该链中的下一个处理对象。
 
 ### 示例：
 
```swift

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
```

 ### 用法：
 
```swift

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

```

 > 更多示例：[Design Patterns in Swift](https://github.com/kingreza/Swift-Chain-Of-Responsibility)
 
```swift

```

 命令（Command）
 ------------
 命令模式是一种设计模式，它尝试以对象来代表实际行动。命令对象可以把行动(action) 及其参数封装起来，于是这些行动可以被：
 * 重复多次
 * 取消（如果该对象有实现的话）
 * 取消后又再重做
 ### 示例：
 
```swift

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
```

 ### 用法：
 
```swift

let zhimaDoors = "芝麻门"
let doorModule = ZhimaDoorsOperations(doors: zhimaDoors)

doorModule.open()
doorModule.close()
```

 解释器（Interpreter）
 ------------------
 给定一种语言，定义他的文法的一种表示，并定义一个解释器，该解释器使用该表示来解释语言中句子。
 ### 示例：
 
```swift

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
```

 ### 用法：
 
```swift

var context = IntegerContext()

var a = IntegerVariableExpression(name: "A")
var b = IntegerVariableExpression(name: "B")
var c = IntegerVariableExpression(name: "C")

var expression = AddExpression(op1: a, op2: AddExpression(op1: b, op2: c))

context.assign(expression: a, value: 2)
context.assign(expression: b, value: 1)
context.assign(expression: c, value: 3)

var result = expression.evaluate(context)

```

 > 更多示例：[Design Patterns in Swift](https://github.com/kingreza/Swift-Interpreter)
 
```swift

```

 迭代器（Iterator）
 ---------------
 迭代器模式可以让用户通过特定的接口巡访容器中的每一个元素而不用了解底层的实现。
 ### 示例：
 
```swift

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
```

 ### 用法：
 
```swift

let greatNovellas = Novellas(novellas: [Novella(name:"红楼梦")])
for novella in greatNovellas {
    print("我读了\(novella.name)")
}
```

 中介者（Mediator）
 ---------------
 用一个中介者对象封装一系列的对象交互，中介者使各对象不需要显示地相互作用，从而使耦合松散，而且可以独立地改变它们之间的交互。
 ### 示例：
 
```swift

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
```

 ### 用法：
 
```swift

func spamMonster(message: String, worker: MessageSending) {
    worker.send(message: message)
}

let messagesMediator = MessageMediator()

let user0 = Programmer(name: "Linus Torvalds")
let user1 = Programmer(name: "Dylan Wang")
messagesMediator.add(recipient: user0)
messagesMediator.add(recipient: user1)

spamMonster(message: "我希望添加您到我的职业网络", worker: messagesMediator)
```

 > 更多示例：[Design Patterns in Swift](https://github.com/kingreza/Swift-Mediator)
 
```swift

```

 备忘录（Memento）
 --------------
 在不破坏封装性的前提下，捕获一个对象的内部状态，并在该对象之外保存这个状态。这样就可以将该对象恢复到原先保存的状态
 ### 示例：
 
```swift

typealias Memento = NSDictionary
```

 发起人（Originator）
 
```swift

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
```

 管理者（Caretaker）
 
```swift

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
```

 ### 用法：
 
```swift

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
```

 观察者（Observer）
 ---------------
 一个目标对象管理所有相依于它的观察者对象，并且在它本身的状态改变时主动发出通知
 ### 示例：
 
```swift

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
```

 ### 用法：
 
```swift

var observer = Observer()
var testChambers = TestChambers()
testChambers.observer = observer
testChambers.testChamberNumber += 1
```

 > 更多示例：[Design Patterns in Swift](https://github.com/kingreza/Swift-Observer)
 
```swift

```

 状态（State）
 ---------
 在状态模式中，对象的行为是基于它的内部状态而改变的
 ### 示例：
 
```swift

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
```

 ### 用法：
 
```swift

let userContext = Context()
(userContext.isAuthorized, userContext.userId)
userContext.changeStateToAuthorized(userId: "admin")
(userContext.isAuthorized, userContext.userId) // now logged in as "admin"
userContext.changeStateToUnauthorized()
(userContext.isAuthorized, userContext.userId)
```

 > 更多示例：[Design Patterns in Swift](https://github.com/kingreza/Swift-State)
 
```swift

```

 策略（Strategy）
 --------------
 对象有某个行为，但是在不同的场景中，该行为有不同的实现算法。策略模式：
 * 定义了一族算法（业务规则）；
 * 封装了每个算法；
 * 这族的算法可互换代替（interchangeable）。
 ### 示例：
 
```swift

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
```

 ### 用法
 
```swift

var lower = Printer(strategy: LowerCaseStrategy())
lower.print("0 tempora, o mores")

var upper = Printer(strategy: UpperCaseStrategy())
upper.print("0 tempora, o mores")
```

 > 更多示例：[Design Patterns in Swift](https://github.com/kingreza/Swift-Strategy)
 
```swift

```

 访问者（Visitor）
 --------------
 封装某些作用于某种数据结构中各元素的操作，它可以在不改变数据结构的前提下定义作用于这些元素的新的操作。
 ### 示例：
 
```swift

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
```

 ### 用法：
 
```swift

let planets: [Planet] = [PlanetAlderaan(), PlanetCoruscant(), PlanetTatooine(), MoonJedah()]

let names = planets.map { (planet: Planet) -> String in
    let visitor = NameVisitor()
    planet.accept(visitor: visitor)
    return visitor.name
}

names
```

 > 更多示例：[Design Patterns in Swift](https://github.com/kingreza/Swift-Visitor)
 
```swift

 [行为型模式](Behavioral) |
 创建型模式 |
 [结构型模式](Structural)
```

 创建型模式
 ========
 
 > 创建型模式是处理对象创建的设计模式，试图根据实际情况使用合适的方式创建对象。基本的对象创建方式可能会导致设计上的问题，或增加设计的复杂度。创建型模式通过以某种方式控制对象的创建来解决问题。
 >
 >**来源：** [维基百科](https://zh.wikipedia.org/wiki/%E5%89%B5%E5%BB%BA%E5%9E%8B%E6%A8%A1%E5%BC%8F)
 
```swift

import Swift
import Foundation
```

 抽象工厂（Abstract Factory）
 -------------
 抽象工厂模式提供了一种方式，可以将一组具有同一主题的单独的工厂封装起来。在正常使用中，客户端程序需要创建抽象工厂的具体实现，然后使用抽象工厂作为接口来创建这一主题的具体对象。
 ### 示例：
 
```swift

```

 协议
 
```swift

protocol Decimal {
    func stringValue() -> String
    // 工厂
    static func make(string: String) -> Decimal
}

typealias NumberFactory = (String) -> Decimal

// 工厂方法实现

struct NextStepNumber: Decimal {
    private var nextStepNumber: NSNumber
    
    func stringValue() -> String {
        return nextStepNumber.stringValue
    }
    
    static func make(string: String) -> Decimal {
        return NextStepNumber(nextStepNumber: NSNumber(value: (string as NSString).longLongValue))
    }
}

struct SwiftNumber: Decimal {
    private var swiftInt: Int
    
    func stringValue() -> String {
        return "\(swiftInt)"
    }
    
    static func make(string: String) -> Decimal {
        return SwiftNumber(swiftInt: (string as NSString).integerValue)
    }
}
```

 抽象工厂
 
```swift

enum NumberType {
    case nextStep, swift
}

enum NumberHelper {
    static func factory(for type: NumberType) -> NumberFactory {
        switch type {
        case .nextStep:
            return NextStepNumber.make
        case .swift:
            return SwiftNumber.make
        }
    }
}
```

 用法：
 
```swift

let factoryOne = NumberHelper.factory(for: .nextStep)
let numberOne = factoryOne("1")
numberOne.stringValue()

let factoryTwo = NumberHelper.factory(for: .swift)
let nemberTwo = factoryTwo("2")
nemberTwo.stringValue()
```

 生成器（Builder）
 --------------
 一种对象构建模式。它可以将复杂对象的建造过程抽象出来（抽象类别），使这个抽象过程的不同实现方法可以构造出不同表现（属性）的对象。
 ### 示例：
 
```swift

class DeathStarBuilder {
    
    var x: Double?
    var y: Double?
    var z: Double?
    
    typealias BuilderClosure = (DeathStarBuilder) -> ()
    
    init(buildClosure: BuilderClosure) {
        buildClosure(self)
    }
}

struct DeathStar: CustomStringConvertible {
    
    let x: Double
    let y: Double
    let z: Double
    
    init?(builder: DeathStarBuilder) {
        
        if let x = builder.x, let y = builder.y, let z = builder.z {
            self.x = x
            self.y = y
            self.z = z
        } else {
            return nil
        }
    }
    
    var description: String {
        return "Death Star at (x:\(x) y:\(y) z:\(z))"
    }
}
```

 ### 用法：
 
```swift

let empire = DeathStarBuilder { builder in
    builder.x = 0.1
    builder.y = 0.2
    builder.z = 0.3
}

let deathStar = DeathStar(builder: empire)
```

 > 更多示例：[Design Patterns in Swift](https://github.com/kingreza/Swift-Builder)
 
```swift

```

 工厂方法（Factory Method）
 -----------------------
 定义一个创建对象的接口，但让实现这个接口的类来决定实例化哪个类。工厂方法让类的实例化推迟到子类中进行。
 ### 示例：
 
```swift

protocol Currency {
    func symbol() -> String
    func code() -> String
}

class Euro: Currency {
    func symbol() -> String {
        return "€"
    }
    
    func code() -> String {
        return "EUR"
    }
}

class UnitedStatesDolar : Currency {
    func symbol() -> String {
        return "$"
    }
    
    func code() -> String {
        return "USD"
    }
}

enum Country {
    case unitedStates, spain, uk, greece
}

enum CurrencyFactory {
    static func currency(for country:Country) -> Currency? {
        
        switch country {
        case .spain, .greece :
            return Euro()
        case .unitedStates :
            return UnitedStatesDolar()
        default:
            return nil
        }
        
    }
}
```

 ### 用法：
 
```swift

let noCurrencyCode = "无可用货币码"

CurrencyFactory.currency(for: .greece)?.code() ?? noCurrencyCode
CurrencyFactory.currency(for: .spain)?.code() ?? noCurrencyCode
CurrencyFactory.currency(for: .unitedStates)?.code() ?? noCurrencyCode
CurrencyFactory.currency(for: .uk)?.code() ?? noCurrencyCode
```

 原型（Prototype）
 --------------
 通过“复制”一个已经存在的实例来返回新的实例,而不是新建实例。被复制的实例就是我们所称的“原型”，这个原型是可定制的。
 ### 示例：
 
```swift

class ChungasRevengeDisplay {
    var name: String?
    let font: String
    
    init(font: String) {
        self.font = font
    }
    
    func clone() -> ChungasRevengeDisplay {
        return ChungasRevengeDisplay(font: self.font)
    }
}
```

 ### 用法：
 
```swift

let Prototype = ChungasRevengeDisplay(font:"GotanProject")

let Philippe = Prototype.clone()
Philippe.name = "Philippe"

let Christoph = Prototype.clone()
Christoph.name = "Christoph"

let Eduardo = Prototype.clone()
Eduardo.name = "Eduardo"
```

 > 更多示例：[Design Patterns in Swift](https://github.com/kingreza/Swift-Prototype)
 
```swift

```

 单例（Singleton）
 --------------
 单例对象的类必须保证只有一个实例存在。许多时候整个系统只需要拥有一个的全局对象，这样有利于我们协调系统整体的行为
 ### 示例：
 
```swift

class DeathStarSuperlaser {
    static let sharedInstance = DeathStarSuperlaser()
    
    private init() {
        
    }
}
```

 ### 用法：
 
```swift

let laser = DeathStarSuperlaser.sharedInstance
 [行为型模式](Behavioral) |
 [创建型模式](Creational) |
 结构型模式
```

 结构型模式（Structural）
 ====================
 
 > 在软件工程中结构型模式是设计模式，借由一以贯之的方式来了解元件间的关系，以简化设计。
 >
 >**来源：** [维基百科](https://zh.wikipedia.org/wiki/%E7%B5%90%E6%A7%8B%E5%9E%8B%E6%A8%A1%E5%BC%8F)
 
```swift

import Swift
import Foundation
```

 适配器（Adapter）
 --------------
 
 适配器模式有时候也称包装样式或者包装(wrapper)。将一个类的接口转接成用户所期待的。一个适配使得因接口不兼容而不能在一起工作的类工作在一起，做法是将类自己的接口包裹在一个已存在的类中。
 ### 示例：
 
```swift

protocol OlderDeathStarSuperLaserAiming {
    var angleV: NSNumber { get }
    var angleH: NSNumber { get }
}
```

 **被适配者**
 
```swift

struct DeathStarSuperlaserTarget {
    let angleHorizontal: Double
    let angleVertical: Double
    
    init(angleHorizontal: Double, angleVertical: Double) {
        self.angleHorizontal = angleHorizontal
        self.angleVertical = angleVertical
    }
}
```

 **适配器**
 
```swift

struct OldDeathStarSuperlaserTarget: OlderDeathStarSuperLaserAiming {
    private let target: DeathStarSuperlaserTarget
    
    var angleV: NSNumber {
        return NSNumber(value: target.angleVertical)
    }
    
    var angleH: NSNumber {
        return NSNumber(value: target.angleHorizontal)
    }
    
    init(_ target: DeathStarSuperlaserTarget) {
        self.target = target
    }
}
```

 ### 用法：
 
```swift

let target = DeathStarSuperlaserTarget(angleHorizontal: 14.0, angleVertical: 12.0)
let oldFormat = OldDeathStarSuperlaserTarget(target)

oldFormat.angleH
oldFormat.angleV
```

 更多示例：[Design Patterns in Swift](https://github.com/kingreza/Swift-Adapter)
 
```swift

```

 桥接（Bridge）
 -----------
 桥接模式将抽象部分与实现部分分离，使它们都可以独立的变化。
 ### 示例：
 
```swift

protocol Switch {
    var appliance: Appliance { get set }
    func turnOn()
}

protocol Appliance {
    func run()
}

class RemoteControl: Switch {
    var appliance: Appliance
    
    func turnOn() {
        self.appliance.run()
    }
    
    init(appliance: Appliance) {
        self.appliance = appliance
    }
}

class TV: Appliance {
    func run() {
        print("📺 打开了")
    }
}

class VacuumCleaner: Appliance {
    func run() {
        print("吸尘器打开了")
    }
}
```

 ### 用法：
 
```swift

var tvRemoteControl = RemoteControl(appliance: TV())
tvRemoteControl.turnOn()

var fancyVacuumCleanerRemoteControl = RemoteControl(appliance: VacuumCleaner())
fancyVacuumCleanerRemoteControl.turnOn()
```

 组合（Composite）
 --------------
 将对象组合成树形结构以表示‘部分-整体’的层次结构。组合模式使得用户对单个对象和组合对象的使用具有一致性。
 ### 示例：
 
```swift

```

 组件（Component）
 
```swift

protocol Shape {
    func draw(fillColor: String)
}
```

 叶子节点（Leafs）
 
```swift

final class Square: Shape {
    func draw(fillColor: String) {
        print("画（\(fillColor)）颜色的方形")
    }
}

final class Circle: Shape {
    func draw(fillColor: String) {
        print("画（\(fillColor)）颜色的圆形")
    }
}
```

 组合
 
```swift

final class Whiteboard: Shape {
    lazy var shapes = [Shape]()
    
    init(_ shapes: Shape...) {
        self.shapes = shapes
    }
    
    func draw(fillColor: String) {
        for shape in self.shapes {
            shape.draw(fillColor: fillColor)
        }
    }
}
```

 ### 用法：
 
```swift

var whiteboard = Whiteboard(Circle(), Square())
whiteboard.draw(fillColor: "红")
```

 修饰（Decorator）
 --------------
 修饰模式，是面向对象编程领域中，一种动态地往一个类中添加新的行为的设计模式。
 就功能而言，修饰模式相比生成子类更为灵活，这样可以给某个对象而不是整个类添加一些功能。
 ### 示例：
 
```swift

protocol Coffee {
    func getCost() -> Double
    func getIngredients() -> String
}

class SimpleCoffee: Coffee {
    func getCost() -> Double {
        return 1.0
    }
    
    func getIngredients() -> String {
        return "Coffee"
    }
}

class CoffeeDecorator: Coffee {
    private let decoratedCoffee: Coffee
    fileprivate let ingredientSeparator: String = ","
    
    required init(decoratedCoffee: Coffee) {
        self.decoratedCoffee = decoratedCoffee
    }
    
    func getCost() -> Double {
        return decoratedCoffee.getCost()
    }
    
    func getIngredients() -> String {
        return decoratedCoffee.getIngredients()
    }
}

final class Milk: CoffeeDecorator {
    required init(decoratedCoffee: Coffee) {
        super.init(decoratedCoffee: decoratedCoffee)
    }
    
    override func getCost() -> Double {
        return super.getCost() + 0.5
    }
    
    override func getIngredients() -> String {
        return super.getIngredients() + ingredientSeparator + "Milk"
    }
}

final class WhipCoffee: CoffeeDecorator {
    required init(decoratedCoffee: Coffee) {
        super.init(decoratedCoffee: decoratedCoffee)
    }
    
    override func getCost() -> Double {
        return super.getCost() + 0.7
    }
    
    override func getIngredients() -> String {
        return super.getIngredients() + ingredientSeparator + "Whip"
    }
}
```

 ### 用法：
 
```swift

var someCoffee: Coffee = SimpleCoffee()
print("Cost : \(someCoffee.getCost()); Ingredients: \(someCoffee.getIngredients())")
someCoffee = Milk(decoratedCoffee: someCoffee)
print("Cost : \(someCoffee.getCost()); Ingredients: \(someCoffee.getIngredients())")
someCoffee = WhipCoffee(decoratedCoffee: someCoffee)
print("Cost : \(someCoffee.getCost()); Ingredients: \(someCoffee.getIngredients())")
```

 外观（Facade）
 -----------
 外观模式为子系统中的一组接口提供一个统一的高层接口，使得子系统更容易使用。
 ### 示例：
 
```swift

enum Eternal {
    
    static func set(_ object: Any, forKey defaultName: String) {
        let defaults: UserDefaults = UserDefaults.standard
        defaults.set(object, forKey: defaultName)
        defaults.synchronize()
    }
    
    static func object(forKey key: String) -> AnyObject! {
        let defaults: UserDefaults = UserDefaults.standard
        return defaults.object(forKey: key) as AnyObject
    }
}
```

 ### 用法：
 
```swift

Eternal.set("Disconnect me. I’d rather be nothing", forKey:"Bishop")
Eternal.object(forKey: "Bishop")
```

 享元（Flyweight）
 --------------
 使用共享物件，用来尽可能减少内存使用量以及分享资讯给尽可能多的相似物件；它适合用于当大量物件只是重复因而导致无法令人接受的使用大量内存。
 ### 示例：
 
```swift

final class SpecialityCoffee: CustomStringConvertible {
    var origin: String
    var description: String {
        get {
            return origin
        }
    }
    
    init(origin: String) {
        self.origin = origin
    }
}

final class Menu {
    private var coffeeAvailable: [String: SpecialityCoffee] = [:]
    
    func lookup(origin: String) -> SpecialityCoffee? {
        if coffeeAvailable.index(forKey: origin) == nil {
            coffeeAvailable[origin] = SpecialityCoffee(origin: origin)
        }
        
        return coffeeAvailable[origin]
    }
}

final class CoffeeShop {
    private var orders: [Int: SpecialityCoffee] = [:]
    private var menu = Menu()
    
    func takeOrder(origin: String, table: Int) {
        orders[table] = menu.lookup(origin: origin)
    }
    
    func serve() {
        for (table, origin) in orders {
            print("Serving \(origin) to table \(table)")
        }
    }
}
```

 ### 用法：
 
```swift

let coffeeShop = CoffeeShop()

coffeeShop.takeOrder(origin: "Yirgacheffe, Ethiopia", table: 1)
coffeeShop.takeOrder(origin: "Buziraguhindwa, Burundi", table: 3)

coffeeShop.serve()
```

☔ Protection Proxy
------------------

The proxy pattern is used to provide a surrogate or placeholder object, which references an underlying object. 
Protection proxy is restricting access.

### Example

```swift

protocol DoorOperator {
    func open(doors: String) -> String
}

class HAL9000 : DoorOperator {
    func open(doors: String) -> String {
        return ("HAL9000: Affirmative, Dave. I read you. Opened \(doors).")
    }
}

class CurrentComputer : DoorOperator {
    private var computer: HAL9000!

    func authenticate(password: String) -> Bool {

        guard password == "pass" else {
            return false;
        }

        computer = HAL9000()

        return true
    }

    func open(doors: String) -> String {

        guard computer != nil else {
            return "Access Denied. I'm afraid I can't do that."
        }

        return computer.open(doors: doors)
    }
}
```

### Usage

```swift

let computer = CurrentComputer()
let podBay = "Pod Bay Doors"

computer.open(doors: podBay)

computer.authenticate(password: "pass")
computer.open(doors: podBay)
```

🍬 Virtual Proxy
----------------

The proxy pattern is used to provide a surrogate or placeholder object, which references an underlying object. 
Virtual proxy is used for loading object on demand.

### Example

```swift

protocol HEVSuitMedicalAid {
    func administerMorphine() -> String
}

class HEVSuit : HEVSuitMedicalAid {
    func administerMorphine() -> String {
        return "Morphine aministered."
    }
}

class HEVSuitHumanInterface : HEVSuitMedicalAid {
    lazy private var physicalSuit: HEVSuit = HEVSuit()

    func administerMorphine() -> String {
        return physicalSuit.administerMorphine()
    }
}
```

### Usage

```swift

let humanInterface = HEVSuitHumanInterface()
humanInterface.administerMorphine()
```


Info
====

📖 Descriptions from: [Gang of Four Design Patterns Reference Sheet](http://www.blackwasp.co.uk/GangOfFour.aspx)


```swift
