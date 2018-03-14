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
        return "Can withdraw: \(self.startPile.canWithdraw(amount: amount))"
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
atm.canWithdraw(amount: 310) // Cannot because ATM has only 300
atm.canWithdraw(amount: 100) // Can withdraw - 1x100
atm.canWithdraw(amount: 165) // Cannot withdraw because ATM doesn't has bill with value of 5
atm.canWithdraw(amount: 30)  // Can withdraw - 1x20, 2x10
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
    func evaluate(_ context: IntegerContext) -> Int
    func replace(character: Character, integerExpression: IntegerExpression) -> IntegerExpression
    func copied() -> IntegerExpression
}

final class IntegerContext {
    private var data: [Character:Int] = [:]

    func lookup(name: Character) -> Int {
        return self.data[name]!
    }

    func assign(expression: IntegerVariableExpression, value: Int) {
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
        return AddExpression(op1: operand1.replace(character: character, integerExpression: integerExpression),
                             op2: operand2.replace(character: character, integerExpression: integerExpression))
    }

    func copied() -> IntegerExpression {
        return AddExpression(op1: self.operand1, op2: self.operand2)
    }
}
/*:
### Usage
*/
var context = IntegerContext()

var a = IntegerVariableExpression(name: "A")
var b = IntegerVariableExpression(name: "B")
var c = IntegerVariableExpression(name: "C")

var expression = AddExpression(op1: a, op2: AddExpression(op1: b, op2: c)) // a + (b + c)

context.assign(expression: a, value: 2)
context.assign(expression: b, value: 1)
context.assign(expression: c, value: 3)

var result = expression.evaluate(context)
/*:
>**Further Examples:** [Design Patterns in Swift](https://github.com/kingreza/Swift-Interpreter)
*/
/*:
🍫 Iterator
-----------

The iterator pattern is used to provide a standard interface for traversing a collection of items in an aggregate object without the need to understand its underlying structure.

### Example:
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
### Usage
*/
let greatNovellas = Novellas(novellas: [Novella(name: "The Mist")] )

for novella in greatNovellas {
    print("I've read: \(novella)")
}
/*:
💐 Mediator
-----------

The mediator pattern is used to reduce coupling between classes that communicate with each other. Instead of classes communicating directly, and thus requiring knowledge of their implementation, the classes send messages via a mediator object.

### Example
*/
protocol Receiver {
    associatedtype MessageType
    func receive(message: MessageType)
}

protocol Sender {
    associatedtype MessageType
    associatedtype ReceiverType: Receiver
    
    var recipients: [ReceiverType] { get }
    
    func send(message: MessageType)
}

struct Programmer: Receiver {
    let name: String
    
    init(name: String) {
        self.name = name
    }
    
    func receive(message: String) {
        print("\(name) received: \(message)")
    }
}

final class MessageMediator: Sender {
    internal var recipients: [Programmer] = []
    
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
### Usage
*/
func spamMonster(message: String, worker: MessageMediator) {
    worker.send(message: message)
}

let messagesMediator = MessageMediator()

let user0 = Programmer(name: "Linus Torvalds")
let user1 = Programmer(name: "Avadis 'Avie' Tevanian")
messagesMediator.add(recipient: user0)
messagesMediator.add(recipient: user1)

spamMonster(message: "I'd Like to Add you to My Professional Network", worker: messagesMediator)
/*:
>**Further Examples:** [Design Patterns in Swift](https://github.com/kingreza/Swift-Mediator)
*/
/*:
💾 Memento
----------

The memento pattern is used to capture the current state of an object and store it in such a manner that it can be restored at a later time without breaking the rules of encapsulation.

### Example
*/
typealias Memento = NSDictionary
/*:
Originator
*/
protocol MementoConvertible {
    var memento: Memento { get }
    init?(memento: Memento)
}

struct GameState: MementoConvertible {

    private enum Keys {
        static let chapter = "com.valve.halflife.chapter"
        static let weapon = "com.valve.halflife.weapon"
    }

    var chapter: String
    var weapon: String

    init(chapter: String, weapon: String) {
        self.chapter = chapter
        self.weapon = weapon
    }

    init?(memento: Memento) {
        guard let mementoChapter = memento[Keys.chapter] as? String,
              let mementoWeapon = memento[Keys.weapon] as? String else {
            return nil
        }

        chapter = mementoChapter
        weapon = mementoWeapon
    }

    var memento: Memento {
        return [ Keys.chapter: chapter, Keys.weapon: weapon ]
    }
}
/*:
Caretaker
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
 ### Usage
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
👓 Observer
-----------

The observer pattern is used to allow an object to publish changes to its state.
Other objects subscribe to be immediately notified of any changes.

### Example
*/
protocol PropertyObserver : class {
    func willChange(propertyName: String, newPropertyValue: Any?)
    func didChange(propertyName: String, oldPropertyValue: Any?)
}

final class TestChambers {

    weak var observer:PropertyObserver?

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

final class Observer : PropertyObserver {
    func willChange(propertyName: String, newPropertyValue: Any?) {
        if newPropertyValue as? Int == 1 {
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
final class Context {
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
let userContext = Context()
(userContext.isAuthorized, userContext.userId)
userContext.changeStateToAuthorized(userId: "admin")
(userContext.isAuthorized, userContext.userId) // now logged in as "admin"
userContext.changeStateToUnauthorized()
(userContext.isAuthorized, userContext.userId)
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
    func print(_ string: String) -> String
}

final class Printer {

    private let strategy: PrintStrategy

    func print(_ string: String) -> String {
        return self.strategy.print(string)
    }

    init(strategy: PrintStrategy) {
        self.strategy = strategy
    }
}

final class UpperCaseStrategy: PrintStrategy {
    func print(_ string: String) -> String {
        return string.uppercased()
    }
}

final class LowerCaseStrategy: PrintStrategy {
    func print(_ string:String) -> String {
        return string.lowercased()
    }
}
/*:
### Usage
*/
var lower = Printer(strategy: LowerCaseStrategy())
lower.print("O tempora, o mores!")

var upper = Printer(strategy: UpperCaseStrategy())
upper.print("O tempora, o mores!")
/*:
>**Further Examples:** [Design Patterns in Swift](https://github.com/kingreza/Swift-Strategy)
*/
/*:
🍪 Template
-----------

The Template Pattern is used when two or more implementations of an
algorithm exist. The template is defined and then built upon with further
variations. Use this method when most (or all) subclasses need to implement
the same behavior. Traditionally, this would be accomplished with abstract
classes and protected methods (as in Java). However in Swift, because
abstract classes don't exist (yet - maybe someday),  we need to accomplish
the behavior using interface delegation.


### Example
*/

protocol ICodeGenerator {
    func crossCompile()
}

protocol IGeneratorPhases {
    func collectSource()
    func crossCompile()
}

class CodeGenerator : ICodeGenerator{
    var delegate: IGeneratorPhases

    init(delegate: IGeneratorPhases) {
        self.delegate = delegate
    }

    private func fetchDataforGeneration(){
        //common implementation
        print("fetchDataforGeneration invoked")
    }

    //Template method
    final func crossCompile() {
        fetchDataforGeneration()
        delegate.collectSource()
        delegate.crossCompile()
    }
    
}

class HTMLGeneratorPhases : IGeneratorPhases {
    func collectSource() {
        print("HTMLGeneratorPhases collectSource() executed")
    }

    func crossCompile() {
        print("HTMLGeneratorPhases crossCompile() executed")
    }
}

class JSONGeneratorPhases : IGeneratorPhases {
    func collectSource() {
        print("JSONGeneratorPhases collectSource() executed")
    }

    func crossCompile() {
        print("JSONGeneratorPhases crossCompile() executed")
    }
}



/*:
### Usage
*/

let htmlGen : ICodeGenerator = CodeGenerator(delegate: HTMLGeneratorPhases())
let jsonGen: ICodeGenerator = CodeGenerator(delegate: JSONGeneratorPhases())

htmlGen.crossCompile()
jsonGen.crossCompile()
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
### Usage
*/
let planets: [Planet] = [PlanetAlderaan(), PlanetCoruscant(), PlanetTatooine(), MoonJedah()]

let names = planets.map { (planet: Planet) -> String in
	let visitor = NameVisitor()
    planet.accept(visitor: visitor)
	return visitor.name
}

names
/*:
>**Further Examples:** [Design Patterns in Swift](https://github.com/kingreza/Swift-Visitor)
*/
