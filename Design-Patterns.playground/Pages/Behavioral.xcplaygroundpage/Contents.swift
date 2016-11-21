//: Behavioral |
//: [Creational](Creational) |
//: [Structural](Structural)
/*:
Behavioral
==========

>In software engineering, behavioral design patterns are design patterns that identify common communication patterns between objects and realize these patterns. By doing so, these patterns increase flexibility in carrying out this communication.
>
>**Source:** [wikipedia.org](http://en.wikipedia.org/wiki/Behavioral_pattern)
*/
import Swift
import Foundation
/*:
🐝 Chain Of Responsibility
--------------------------

The chain of responsibility pattern is used to process varied requests, each of which may be dealt with by a different handler.

### Example:
*/
class MoneyPile {
    let value: Int
    var quantity: Int
    var nextPile: MoneyPile?
    
    init(value: Int, quantity: Int, nextPile: MoneyPile?) {
        self.value = value
        self.quantity = quantity
        self.nextPile = nextPile
    }
    
    func canWithdraw(amount: Int) -> Bool {

        var val = amount

        func canTakeSomeBill(want: Int) -> Bool {
            return (want / self.value) > 0
        }
        
        var q = self.quantity

        while canTakeSomeBill(want: val) {

            if q == 0 {
                break
            }

            val -= self.value
            q -= 1
        }

        if val == 0 {
            return true
        } else if let next = self.nextPile {
            return next.canWithdraw(amount: val)
        }

        return false
    }
}

class ATM {
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
    
    func canWithdraw(value: Int) -> String {
        return "Can withdraw: \(self.startPile.canWithdraw(amount: value))"
    }
}
/*:
### Usage
*/
// Create piles of money and link them together 10 < 20 < 50 < 100.**
let ten = MoneyPile(value: 10, quantity: 6, nextPile: nil)
let twenty = MoneyPile(value: 20, quantity: 2, nextPile: ten)
let fifty = MoneyPile(value: 50, quantity: 2, nextPile: twenty)
let hundred = MoneyPile(value: 100, quantity: 1, nextPile: fifty)

// Build ATM.
var atm = ATM(hundred: hundred, fifty: fifty, twenty: twenty, ten: ten)
atm.canWithdraw(value: 310) // Cannot because ATM has only 300
atm.canWithdraw(value: 100) // Can withdraw - 1x100
atm.canWithdraw(value: 165) // Cannot withdraw because ATM doesn't has bill with value of 5
atm.canWithdraw(value: 30)  // Can withdraw - 1x20, 2x10
/*:
>**Further Examples:** [Design Patterns in Swift](https://github.com/kingreza/Swift-Chain-Of-Responsibility)
*/
/*:
👫 Command
----------

The command pattern is used to express a request, including the call to be made and all of its required parameters, in a command object. The command may then be executed immediately or held for later use.

### Example:
*/
protocol DoorCommand {
    func execute() -> String
}

class OpenCommand : DoorCommand {
    let doors:String

    required init(doors: String) {
        self.doors = doors
    }
    
    func execute() -> String {
        return "Opened \(doors)"
    }
}

class CloseCommand : DoorCommand {
    let doors:String

    required init(doors: String) {
        self.doors = doors
    }
    
    func execute() -> String {
        return "Closed \(doors)"
    }
}

class HAL9000DoorsOperations {
    let openCommand: DoorCommand
    let closeCommand: DoorCommand
    
    init(doors: String) {
        self.openCommand = OpenCommand(doors:doors)
        self.closeCommand = CloseCommand(doors:doors)
    }
    
    func close() -> String {
        return closeCommand.execute()
    }
    
    func open() -> String {
        return openCommand.execute()
    }
}
/*:
### Usage:
*/
let podBayDoors = "Pod Bay Doors"
let doorModule = HAL9000DoorsOperations(doors:podBayDoors)

doorModule.open()
doorModule.close()
/*:
🎶 Interpreter
--------------

The interpreter pattern is used to evaluate sentences in a language.

### Example
*/

protocol IntegerExpression {
    func evaluate(context: IntegerContext) -> Int
    func replace(character: Character, expression: IntegerExpression) -> IntegerExpression
    func copy() -> IntegerExpression
}

class IntegerContext {
    private var data: [Character:Int] = [:]
    
    func lookup(name: Character) -> Int {
        return self.data[name]!
    }
    
    func assign(expression: Expression, value: Int) {
        self.data[expression.name] = value
    }
}

class Expression: IntegerExpression {
    let name: Character
    
    init(name: Character) {
        self.name = name
    }
  
    func evaluate(context: IntegerContext) -> Int {
        return context.lookup(name: self.name)
    }
    
    func replace(character name: Character, expression: IntegerExpression) -> IntegerExpression {
        if name == self.name {
            return expression.copy()
        } else {
            return Expression(name: self.name)
        }
    }
    
    func copy() -> IntegerExpression {
        return Expression(name: self.name)
    }
}

class AddExp: IntegerExpression {
    private var operand1: IntegerExpression
    private var operand2: IntegerExpression
    
    init(op1: IntegerExpression, op2: IntegerExpression) {
        self.operand1 = op1
        self.operand2 = op2
    }
    
    func evaluate(context: IntegerContext) -> Int {
        return self.operand1.evaluate(context: context) + self.operand2.evaluate(context: context)
    }
    
    func replace(character: Character, expression: IntegerExpression) -> IntegerExpression {
        return AddExp(op1: operand1.replace(character: character, expression: expression),
            op2: operand2.replace(character: character, expression: expression))
    }
    
    func copy() -> IntegerExpression {
        return AddExp(op1: self.operand1, op2: self.operand2)
    }
}
/*:
### Usage
*/
var expression: IntegerExpression?
var intContext = IntegerContext()

var a = Expression(name: "A")
var b = Expression(name: "B")
var c = Expression(name: "C")

expression = AddExp(op1: a, op2: AddExp(op1: b, op2: c)) // a + (b + c)

intContext.assign(expression: a, value: 2)
intContext.assign(expression: b, value: 1)
intContext.assign(expression: c, value: 3)

var result = expression?.evaluate(context: intContext)
/*:
>**Further Examples:** [Design Patterns in Swift](https://github.com/kingreza/Swift-Interpreter)
*/
/*:
🍫 Iterator
-----------

The iterator pattern is used to provide a standard interface for traversing a collection of items in an aggregate object without the need to understand its underlying structure.

### Example:
*/
struct NovellasCollection<T> {
    let novellas: [T]
}

extension NovellasCollection: Sequence {
    typealias Generator = AnyIterator<T>
    
    func generate() -> AnyIterator<T> {
        var i = 0
        return AnyIterator { i += 1; return i >= self.novellas.count ? nil : self.novellas[i] }
    }
}
/*:
### Usage
*/
let greatNovellas = NovellasCollection(novellas:["Mist"])

for novella in greatNovellas {
    print("I've read: \(novella)")
}
/*:
💐 Mediator
-----------

The mediator pattern is used to reduce coupling between classes that communicate with each other. Instead of classes communicating directly, and thus requiring knowledge of their implementation, the classes send messages via a mediator object.

### Example
*/

class Colleague {
    let name: String
    let mediator: Mediator
    
    init(name: String, mediator: Mediator) {
        self.name = name
        self.mediator = mediator
    }
    
    func send(message: String) {
        mediator.send(message: message, colleague: self)
    }
    
    func receive(message: String) {
        assert(false, "Method should be overriden")
    }
}

protocol Mediator {
    func send(message: String, colleague: Colleague)
}

class MessageMediator: Mediator {
    private var colleagues: [Colleague] = []
    
    func addColleague(colleague: Colleague) {
        colleagues.append(colleague)
    }
    
    func send(message: String, colleague: Colleague) {
        for c in colleagues {
            if c !== colleague { //for simplicity we compare object references
                c.receive(message: message)
            }
        }
    }
}

class ConcreteColleague: Colleague {
    override func receive(message: String) {
        print("Colleague \(name) received: \(message)")
    }
}

/*:
### Usage
*/

let messagesMediator = MessageMediator()
let user0 = ConcreteColleague(name: "0", mediator: messagesMediator)
let user1 = ConcreteColleague(name: "1", mediator: messagesMediator)
messagesMediator.addColleague(colleague: user0)
messagesMediator.addColleague(colleague: user1)

user0.send(message: "Hello") // user1 receives message
/*:
>**Further Examples:** [Design Patterns in Swift](https://github.com/kingreza/Swift-Mediator)
*/
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
        return [ DPMementoKeyChapter as NSObject:chapter as AnyObject, DPMementoKeyWeapon as NSObject:weapon as AnyObject ]
    }

    func restoreFromMemento(memento: Memento) {
        chapter = memento[DPMementoKeyChapter] as? String ?? "n/a"
        weapon = memento[DPMementoKeyWeapon] as? String ?? "n/a"
    }
}
/*:
Caretaker
*/
enum CheckPoint {
    static func saveState(memento: Memento, keyName: String = DPMementoGameState) {
        let defaults = UserDefaults.standard
        defaults.set(memento, forKey: keyName)
        defaults.synchronize()
    }

    static func restorePreviousState(keyName: String = DPMementoGameState) -> Memento {
        let defaults = UserDefaults.standard

        return defaults.object(forKey: keyName) as? Memento ?? Memento()
    }
}
/*:
 ### Usage
*/
var gameState = GameState()
gameState.restoreFromMemento(memento: CheckPoint.restorePreviousState())

gameState.chapter = "Black Mesa Inbound"
gameState.weapon = "Crowbar"
CheckPoint.saveState(memento: gameState.toMemento())

gameState.chapter = "Anomalous Materials"
gameState.weapon = "Glock 17"
gameState.restoreFromMemento(memento: CheckPoint.restorePreviousState())

gameState.chapter = "Unforeseen Consequences"
gameState.weapon = "MP5"
CheckPoint.saveState(memento: gameState.toMemento(), keyName: "gameState2")

gameState.chapter = "Office Complex"
gameState.weapon = "Crossbow"
CheckPoint.saveState(memento: gameState.toMemento())

gameState.restoreFromMemento(memento: CheckPoint.restorePreviousState(keyName: "gameState2"))

/*:
👓 Observer
-----------

The observer pattern is used to allow an object to publish changes to its state. 
Other objects subscribe to be immediately notified of any changes.

### Example
*/
protocol PropertyObserver : class {
    func willChangePropertyName(propertyName:String, newPropertyValue:AnyObject?)
    func didChangePropertyName(propertyName:String, oldPropertyValue:AnyObject?)
}

class TestChambers {

    weak var observer:PropertyObserver?

    var testChamberNumber: Int = 0 {
        willSet(newValue) {
            observer?.willChangePropertyName(propertyName: "testChamberNumber", newPropertyValue:newValue as AnyObject?)
        }
        didSet {
            observer?.didChangePropertyName(propertyName: "testChamberNumber", oldPropertyValue:oldValue as AnyObject?)
        }
    }
}

class Observer : PropertyObserver {
    func willChangePropertyName(propertyName: String, newPropertyValue: AnyObject?) {
        if newPropertyValue as? Int == 1 {
            print("Okay. Look. We both said a lot of things that you're going to regret.")
        }
    }

    func didChangePropertyName(propertyName: String, oldPropertyValue: AnyObject?) {
        if oldPropertyValue as? Int == 0 {
            print("Sorry about the mess. I've really let the place go since you killed me.")
        }
    }
}
/*:
### Usage
*/
var observerInstance = Observer()
var testChambers = TestChambers()
testChambers.observer = observerInstance
testChambers.testChamberNumber += 1
/*:
>**Further Examples:** [Design Patterns in Swift](https://github.com/kingreza/Swift-Observer)
*/
/*:
🐉 State
---------

The state pattern is used to alter the behaviour of an object as its internal state changes. 
The pattern allows the class for an object to apparently change at run-time.

### Example
*/
class Context {
	private var state: State = UnauthorizedState()

    var isAuthorized: Bool {
        get { return state.isAuthorized(context: self) }
    }

    var userId: String? {
        get { return state.userId(context: self) }
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
### Usage
*/
let context = Context()
(context.isAuthorized, context.userId)
context.changeStateToAuthorized(userId: "admin")
(context.isAuthorized, context.userId) // now logged in as "admin"
context.changeStateToUnauthorized()
(context.isAuthorized, context.userId)
/*:
>**Further Examples:** [Design Patterns in Swift](https://github.com/kingreza/Swift-State)
*/
/*:
💡 Strategy
-----------

The strategy pattern is used to create an interchangeable family of algorithms from which the required process is chosen at run-time.

### Example
*/
protocol PrintStrategy {
    func printString(string: String) -> String
}

class Printer {

    let strategy: PrintStrategy
    
    func printString(string: String) -> String {
        return self.strategy.printString(string: string)
    }
    
    init(strategy: PrintStrategy) {
        self.strategy = strategy
    }
}

class UpperCaseStrategy : PrintStrategy {
    func printString(string:String) -> String {
        return string.uppercased()
    }
}

class LowerCaseStrategy : PrintStrategy {
    func printString(string:String) -> String {
        return string.lowercased()
    }
}
/*:
### Usage
*/
var lower = Printer(strategy:LowerCaseStrategy())
lower.printString(string: "O tempora, o mores!")

var upper = Printer(strategy:UpperCaseStrategy())
upper.printString(string: "O tempora, o mores!")
/*:
>**Further Examples:** [Design Patterns in Swift](https://github.com/kingreza/Swift-Strategy)
*/
/*:
🏃 Visitor
----------

The visitor pattern is used to separate a relatively complex set of structured data classes from the functionality that may be performed upon the data that they hold.

### Example
*/
protocol PlanetVisitor {
	func visit(planet: PlanetAlderaan)
	func visit(planet: PlanetCoruscant)
	func visit(planet: PlanetTatooine)
}

protocol Planet {
	func accept(visitor: PlanetVisitor)
}

class PlanetAlderaan: Planet {
	func accept(visitor: PlanetVisitor) { visitor.visit(self) }
}
class PlanetCoruscant: Planet {
	func accept(visitor: PlanetVisitor) { visitor.visit(self) }
}
class PlanetTatooine: Planet {
	func accept(visitor: PlanetVisitor) { visitor.visit(self) }
}

class NameVisitor: PlanetVisitor {
	var name = ""

	func visit(planet: PlanetAlderaan)  { name = "Alderaan" }
	func visit(planet: PlanetCoruscant) { name = "Coruscant" }
	func visit(planet: PlanetTatooine)  { name = "Tatooine" }
}
/*:
### Usage
*/
let planets: [Planet] = [PlanetAlderaan(), PlanetCoruscant(), PlanetTatooine()]

let names = planets.map { (planet: Planet) -> String in
	let visitor = NameVisitor()
	planet.accept(visitor: visitor)
	return visitor.name
}

names
/*:
>**Further Examples:** [Design Patterns in Swift](https://github.com/kingreza/Swift-Visitor)
*/
