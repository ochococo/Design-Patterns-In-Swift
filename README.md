```swift
import Swift
import Foundation
```

Design Patterns implemented in Swift
====================================
A short cheat-sheet with Xcode 6 Playground ([Design-Patterns.playground.zip](https://raw.githubusercontent.com/ochococo/Design-Patterns-In-Swift/master/Design-Patterns.playground.zip)).

👷 Project maintained by: [@nsmeme](http://twitter.com/nsmeme) (Oktawian Chojnacki)

## Table of Contents

* [Behavioral](#behavioral)
* [Creational](#creational)
* [Structural](#structural)

# Behavioral

>In software engineering, behavioral design patterns are design patterns that identify common communication patterns between objects and realize these patterns. By doing so, these patterns increase flexibility in carrying out this communication.
>
>**Source:** [wikipedia.org](http://en.wikipedia.org/wiki/Behavioral_pattern)

##🐝 Chain Of Responsibility

The chain of responsibility pattern is used to process varied requests, each of which may be dealt with by a different handler.

**Example:**

```swift
class MoneyPile {
    let value: Int
    var quantity: Int
    var nextPile: MoneyPile?
    
    init(value: Int, quantity: Int, nextPile: MoneyPile?) {
        self.value = value
        self.quantity = quantity
        self.nextPile = nextPile
    }
    
    func canWithdraw(var v: Int) -> Bool {

        func canTakeSomeBill(want: Int) -> Bool {
            return (want / self.value) > 0
        }
        
        var q = self.quantity

        while canTakeSomeBill(v) {

            if (q == 0) {
                break
            }

            v -= self.value
            q -= 1
        }

        if v == 0 {
            return true
        } else if let next = self.nextPile {
            return next.canWithdraw(v)
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
        return "Can withdraw: \(self.startPile.canWithdraw(value))"
    }
}
```

**Usage:**
```swift
// Create piles of money and link them together 10 < 20 < 50 < 100.
let ten = MoneyPile(value: 10, quantity: 6, nextPile: nil)
let twenty = MoneyPile(value: 20, quantity: 2, nextPile: ten)
let fifty = MoneyPile(value: 50, quantity: 2, nextPile: twenty)
let hundred = MoneyPile(value: 100, quantity: 1, nextPile: fifty)

// Build ATM.
var atm = ATM(hundred: hundred, fifty: fifty, twenty: twenty, ten: ten)
atm.canWithdraw(310) // Cannot because ATM has only 300
atm.canWithdraw(100) // Can withdraw - 1x100
atm.canWithdraw(165) // Cannot withdraw because ATM doesn't has bill with value of 5
atm.canWithdraw(30)  // Can withdraw - 1x20, 2x10
```
##👫 Command

The command pattern is used to express a request, including the call to be made and all of its required parameters, in a command object. The command may then be executed immediately or held for later use.

**Example:**

```swift
protocol FileOperationCommand {
    init(file: String)
    func execute()
}

class FileMoveCommand : FileOperationCommand {
    let file:String

    required init(file: String) {
        self.file = file
    }
    
    func execute() {
        print("\(file) moved")
    }
}

class FileDeleteCommand : FileOperationCommand {
    let file:String

    required init(file: String) {
        self.file = file
    }
    
    func execute() {
        print("\(file) deleted")
    }
}

class FileManager {
    let deleteCommand: FileOperationCommand
    let moveCommand: FileOperationCommand
    
    init(deleteCommand: FileDeleteCommand, moveCommand: FileMoveCommand) {
        self.deleteCommand = deleteCommand
        self.moveCommand = moveCommand
    }
    
    func delete() {
        deleteCommand.execute()
    }
    
    func move() {
        moveCommand.execute()
    }
}
```

**Usage:**
```swift
let deleteCommand = FileDeleteCommand(file: "/path/to/testfile")
let moveCommand = FileMoveCommand(file: "/path/to/testfile")
let fileManager = FileManager(deleteCommand:deleteCommand , moveCommand: moveCommand)

fileManager.delete()
fileManager.move()
```

##🚧  Iterator

The iterator pattern is used to provide a standard interface for traversing a collection of items in an aggregate object without the need to understand its underlying structure.

*No example, yet.*
##🚧  Mediator

The mediator pattern is used to reduce coupling between classes that communicate with each other. Instead of classes communicating directly, and thus requiring knowledge of their implementation, the classes send messages via a mediator object.

*No example, yet.*
##💾 Memento

The memento pattern is used to capture the current state of an object and store it in such a manner that it can be restored at a later time without breaking the rules of encapsulation.

**Example:**

```swift
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
```
***Usage:***
```swift
var gameState = GameState()
gameState.gameLevel = 2
gameState.playerScore = 200

// Saves state: {gameLevel 2 playerScore 200}
CheckPoint.saveState(gameState.saveToMemeto())

gameState.gameLevel = 3
gameState.gameLevel = 250

// Restores state: {gameLevel 2 playerScore 200}
gameState.restoreFromMemeto(CheckPoint.restorePreviousState())

gameState.gameLevel = 4

// Saves state - gameState2: {gameLevel 4 playerScore 200}
CheckPoint.saveState(gameState.saveToMemeto(), keyName: "gameState2")

gameState.gameLevel = 5
gameState.playerScore = 300

// Saves state - gameState3: {gameLevel 5 playerScore 300}
CheckPoint.saveState(gameState.saveToMemeto(), keyName: "gameState3")

// Restores state - gameState2: {gameLevel 4 playerScore 200}
gameState.restoreFromMemeto(CheckPoint.restorePreviousState(keyName: "gameState2"))
```
##👓 Observer

The observer pattern is used to allow an object to publish changes to its state. 
Other objects subscribe to be immediately notified of any changes.

**Example:**

```swift
class StepCounter {
    var totalSteps: Int = 0 {
        
        willSet(newTotalSteps) {
            println("About to set totalSteps to \(newTotalSteps)")
        }

        didSet {

            if totalSteps > oldValue  {
                println("Added \(totalSteps - oldValue) steps")
            }
        }
    }
}
```
**Usage:**
```swift
let stepCounter = StepCounter()
stepCounter.totalSteps = 200
// About to set totalSteps to 200
// Added 200 steps
stepCounter.totalSteps = 360
// About to set totalSteps to 360
// Added 160 steps
stepCounter.totalSteps = 896
// About to set totalSteps to 896
// Added 536 steps
```
##🐉 State

The state pattern is used to alter the behaviour of an object as its internal state changes. 
The pattern allows the class for an object to apparently change at run-time.

**Example:**

```swift
class Context {
	private var state: State = UnauthorizedState()

    var isAuthorized: Bool {
        get { return state.isAuthorized(self) }
    }

    var userId: String? {
        get { return state.userId(self) }
    }

	func changeStateToAuthorized(#userId: String) {
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
**Usage:**
```swift
let context = Context()
(context.isAuthorized, context.userId)
context.changeStateToAuthorized(userId: "admin")
(context.isAuthorized, context.userId) // now logged in as "admin"
context.changeStateToUnauthorized()
(context.isAuthorized, context.userId)
```
##💡 Strategy

The strategy pattern is used to create an interchangeable family of algorithms from which the required process is chosen at run-time.

**Example:**

```swift
protocol PrintStrategy {
    func printString(string: String) -> String
}

class Printer {

    let strategy: PrintStrategy
    
    func printString(string: String) -> String {
        return self.strategy.printString(string)
    }
    
    init(strategy: PrintStrategy) {
        self.strategy = strategy
    }
}

class UpperCaseStrategy : PrintStrategy {
    func printString(string:String) -> String {
        return string.uppercaseString
    }
}

class LowerCaseStrategy : PrintStrategy {
    func printString(string:String) -> String {
        return string.lowercaseString
    }
}
```
**Usage:**
```swift
var lower = Printer(strategy:LowerCaseStrategy())
lower.printString("O tempora, o mores!")

var upper = Printer(strategy:UpperCaseStrategy())
upper.printString("O tempora, o mores!")
```
##🏃 Visitor

The visitor pattern is used to separate a relatively complex set of structured data classes from the functionality that may be performed upon the data that they hold.

**Example:**

```swift
protocol PlanetVisitor {
	func visit(planet: PlanetEarth)
	func visit(planet: PlanetMars)
	func visit(planet: PlanetGliese581C)
}

protocol Planet {
	func accept(visitor: PlanetVisitor)
}

class PlanetEarth: Planet {
	func accept(visitor: PlanetVisitor) { visitor.visit(self) }
}
class PlanetMars: Planet {
	func accept(visitor: PlanetVisitor) { visitor.visit(self) }
}
class PlanetGliese581C: Planet {
	func accept(visitor: PlanetVisitor) { visitor.visit(self) }
}

class NameVisitor: PlanetVisitor {
	var name = ""

	func visit(planet: PlanetEarth)      { name = "Earth" }
	func visit(planet: PlanetMars)       { name = "Mars" }
	func visit(planet: PlanetGliese581C) { name = "Gliese 581 C" }
}
```
**Usage:**
```swift
let planets: [Planet] = [PlanetEarth(), PlanetMars(), PlanetGliese581C()]

let names = planets.map { (planet: Planet) -> String in
	let visitor = NameVisitor()
	planet.accept(visitor)
	return visitor.name
}

names
```
# Creational

> In software engineering, creational design patterns are design patterns that deal with object creation mechanisms, trying to create objects in a manner suitable to the situation. The basic form of object creation could result in design problems or added complexity to the design. Creational design patterns solve this problem by somehow controlling this object creation.
>
>**Source:** [wikipedia.org](http://en.wikipedia.org/wiki/Creational_pattern)

##🌰 Abstract Factory

The abstract factory pattern is used to provide a client with a set of related or dependant objects. 
The "family" of objects created by the factory are determined at run-time.

**Example:**

```swift
// Protocols.

protocol Decimal {
    func stringValue() -> String
}

protocol NumberFactoryProtocol {
    func numberFromString(string : String) -> Decimal
}

// Number implementations.

struct NextStepNumber : Decimal {
    private var nextStepNumber : NSNumber

    func stringValue() -> String { return nextStepNumber.stringValue }
}

struct SwiftNumber : Decimal {
    private var swiftInt : Int

    func stringValue() -> String { return "\(swiftInt)" }
}

// Factories.

class NextStepNumberFactory : NumberFactoryProtocol {
    func numberFromString(string : String) -> Decimal {
        return NextStepNumber(nextStepNumber:NSNumber(longLong:(string as NSString).longLongValue))
    }
}

class SwiftNumberFactory : NumberFactoryProtocol {
    func numberFromString(string : String) -> Decimal {
        return SwiftNumber(swiftInt:(string as NSString).integerValue)
    }
}

// Abstract factory.

enum NumberType {
    case NextStep, Swift
}

class NumberAbstractFactory {
    class func numberFactoryType(type : NumberType) -> NumberFactoryProtocol {
        
        switch type {
            case .NextStep:
                    return NextStepNumberFactory()
            case .Swift:
                    return SwiftNumberFactory()
        }
    }
}
```
**Usage:**
```swift
let factoryOne = NumberAbstractFactory.numberFactoryType(.NextStep)
let numberOne = factoryOne.numberFromString("1")
numberOne.stringValue()

let factoryTwo = NumberAbstractFactory.numberFactoryType(.Swift)
let numberTwo = factoryTwo.numberFromString("2")
numberTwo.stringValue()
```
##👷 Builder

The builder pattern is used to create complex objects with constituent parts that must be created in the same order or using a specific algorithm. 
An external class controls the construction algorithm.

**Example:**

```swift
protocol ThreeDimensions {
    var x: Double? {get}
    var y: Double? {get}
    var z: Double? {get}
}

class Point : ThreeDimensions {
    var x: Double?
    var y: Double?
    var z: Double?

    typealias PointBuilderClosure = (Point) -> ()

    init(buildClosure: PointBuilderClosure) {
        buildClosure(self)
    }
}

```
**Usage:**
```swift
let fancyPoint = Point { point in
    point.x = 0.1
    point.y = 0.2
    point.z = 0.3
}

fancyPoint.x
fancyPoint.y
fancyPoint.z
```

Shorter but oh-so-ugly alternative:

```swift
let uglierPoint = Point {
    $0.x = 0.1
    $0.y = 0.2
    $0.z = 0.3
}
```
##🏭 Factory Method

The factory pattern is used to replace class constructors, abstracting the process of object generation so that the type of the object instantiated can be determined at run-time.

**Example:**

```swift
protocol Currency {
    func symbol() -> String
    func code() -> String
}

class Euro : Currency {
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
    case UnitedStates, Spain, France, UK
}

class CurrencyFactory {
    class func currencyForCountry(country:Country) -> Currency? {

        switch country {
            case .Spain, .France :
                return Euro()
            case .UnitedStates :
                return UnitedStatesDolar()
            default:
                return nil
        }
        
    }
}
```
**Usage:**
```swift
let noCurrencyCode = "No Currency Code Available"

CurrencyFactory.currencyForCountry(.Spain)?.code() ?? noCurrencyCode
CurrencyFactory.currencyForCountry(.UnitedStates)?.code() ?? noCurrencyCode
CurrencyFactory.currencyForCountry(.France)?.code() ?? noCurrencyCode
CurrencyFactory.currencyForCountry(.UK)?.code() ?? noCurrencyCode

```
##🃏 Prototype

The prototype pattern is used to instantiate a new object by copying all of the properties of an existing object, creating an independent clone. 
This practise is particularly useful when the construction of a new object is inefficient.

**Example:**

```swift
class ThieveryCorporationPersonDisplay {
    var name: String?
    let font: String

    init(font: String) {
        self.font = font
    }

    func clone() -> ThieveryCorporationPersonDisplay {
        return ThieveryCorporationPersonDisplay(font:self.font)
    }
}
```
**Usage:**
```swift
let Prototype = ThieveryCorporationPersonDisplay(font:"Ubuntu")

let Philippe = Prototype.clone()
Philippe.name = "Philippe"

let Christoph = Prototype.clone()
Christoph.name = "Christoph"

let Eduardo = Prototype.clone()
Eduardo.name = "Eduardo"
```
##💍 Singleton

The singleton pattern ensures that only one object of a particular class is ever created.
All further references to objects of the singleton class refer to the same underlying instance.

**Example:**

```swift
class SingletonClass {
    class var shared : SingletonClass {

        struct Static {
            static let instance : SingletonClass = SingletonClass()
        }

        return Static.instance
    }
}
```
**Usage:**
```swift
let instance = SingletonClass.shared

```
#Structural

>In software engineering, structural design patterns are design patterns that ease the design by identifying a simple way to realize relationships between entities.
>
>**Source:** [wikipedia.org](http://en.wikipedia.org/wiki/Structural_pattern)

##🔌 Adapter

The adapter pattern is used to provide a link between two otherwise incompatible types by wrapping the "adaptee" with a class that supports the interface required by the client.

**Example:**

```swift
// WARNING: This example uses Point class from Builder pattern!

class PointConverter {

    class func convert(#point:Point, base:Double, negative:Bool) -> Point {

        var pointConverted = Point{
            if let x = point.x { $0.x = x * base * (negative ? -1.0 : 1.0) }
            if let y = point.y { $0.y = y * base * (negative ? -1.0 : 1.0) }
            if let z = point.z { $0.z = z * base * (negative ? -1.0 : 1.0) }
        }
        
        return pointConverted
    }
}

extension PointConverter{
    
    class func convert(#x:Double!, y:Double!, z:Double!, base:Double!, negative:Bool!) -> (x:Double!,y:Double!,z:Double!) {
        var point = Point{ $0.x = x; $0.y = y; $0.z = z }
        var pointCalculated = self.convert(point:point, base:base, negative:negative)

        return (pointCalculated.x!,pointCalculated.y!,pointCalculated.z!)
    }

}
```

**Usage:**
```swift
var tuple = PointConverter.convert(x:1.1, y:2.2, z:3.3, base:2.0, negative:true)

tuple.x
tuple.y
tuple.z
```
##🌉  Bridge

The bridge pattern is used to separate the abstract elements of a class from the implementation details, providing the means to replace the implementation details without modifying the abstraction.

**Example:**

```swift
protocol Switch {
    var appliance: Appliance {get set}
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
        println("tv turned on");
    }
}

class VacuumCleaner: Appliance {
    func run() {
        println("vacuum cleaner turned on")
    }
}
```

**Usage**
```swift
var tvRemoteControl = RemoteControl(appliance: TV())
tvRemoteControl.turnOn()

var fancyVacuumCleanerRemoteControl = RemoteControl(appliance: VacuumCleaner())
fancyVacuumCleanerRemoteControl.turnOn()
```

##🌿 Composite

The composite pattern is used to create hierarchical, recursive tree structures of related objects where any element of the structure may be accessed and utilised in a standard manner.

**Example:**

```swift
/**
 *  Component
 */
protocol Shape {
    func draw(fillColor: String)
}

/**
 * Leafs
 */
class Square : Shape {
    func draw(fillColor: String) {
        print("Drawing a Square with color \(fillColor)")
    }
}

class Circle : Shape {
    func draw(fillColor: String) {
        print("Drawing a circle with color \(fillColor)")
    }
}

/**
* Composite
*/
class Whiteboard : Shape {
    lazy var shapes = [Shape]()
    
    init(_ shapes:Shape...) {
        self.shapes = shapes
    }
    
    func draw(fillColor:String) {
        for shape in self.shapes {
            shape.draw(fillColor)
        }
    }
}
```
**Usage:**
```swift
var whiteboard = Whiteboard(Circle(), Square())
whiteboard.draw("Red")
```
##🍧 Decorator

The decorator pattern is used to extend or alter the functionality of objects at run- time by wrapping them in an object of a decorator class. 
This provides a flexible alternative to using inheritance to modify behaviour.

**Example:**

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
    private let ingredientSeparator: String = ", "

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

class Milk: CoffeeDecorator {
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

class WhipCoffee: CoffeeDecorator {
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

**Usage:**
```swift
var someCoffee: Coffee = SimpleCoffee()
println("Cost : \(someCoffee.getCost()); Ingredients: \(someCoffee.getIngredients())")
someCoffee = Milk(decoratedCoffee: someCoffee)
println("Cost : \(someCoffee.getCost()); Ingredients: \(someCoffee.getIngredients())")
someCoffee = WhipCoffee(decoratedCoffee: someCoffee)
println("Cost : \(someCoffee.getCost()); Ingredients: \(someCoffee.getIngredients())")
```

##🎁 Façade

The facade pattern is used to define a simplified interface to a more complex subsystem.

**Example:**

```swift
class Eternal {

    class func setObject(value: AnyObject!, forKey defaultName: String!) {
        let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(value, forKey:defaultName)
        defaults.synchronize()
    }

    class func objectForKey(defaultName: String!) -> AnyObject! {
        let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()

        return defaults.objectForKey(defaultName)
    }

}
```
**Usage:**
```swift
Eternal.setObject("Disconnect me. I’d rather be nothing", forKey:"Bishop")
Eternal.objectForKey("Bishop")
```
##☔ Protection Proxy

The proxy pattern is used to provide a surrogate or placeholder object, which references an underlying object. 
Protection proxy is restricting access.

**Example:**

```swift
protocol DoorOperator {
    func openDoors(doors: String) -> String
}

class HAL9000 : DoorOperator {
    func openDoors(doors: String) -> String {
        return ("HAL9000: Affirmative, Dave. I read you. Opened \(doors).")
    }
}

class CurrentComputer : DoorOperator {
    private var computer: HAL9000!

    func authenticateWithPassword(pass: String) -> Bool {

        if pass != "pass" {
            return false
        }

        computer = HAL9000()

        return true
    }
    
    func openDoors(doors: String) -> String {

        if (computer == nil) {
            return "Access Denied. I'm afraid I can't do that."
        }
        
        return computer.openDoors(doors)
    }
}
```

**Usage:**
```swift
let computer = CurrentComputer()
let doors = "Pod Bay Doors"

computer.openDoors(doors)

computer.authenticateWithPassword("pass")
computer.openDoors(doors)
```

##🍬 Virtual Proxy

The proxy pattern is used to provide a surrogate or placeholder object, which references an underlying object. 
Virtual proxy is used for loading object on demand.

**Example:**

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

**Usage:**
```swift
let humanInterface = HEVSuitHumanInterface()
humanInterface.administerMorphine()
```

Info
====

🍺 Playground generated with: [playground](https://github.com/jas/playground) by [@jasonsandmeyer](http://twitter.com/jasonsandmeyer)

📖 Descriptions from: [Gang of Four Design Patterns Reference Sheet](http://www.blackwasp.co.uk/GangOfFour.aspx)

🚀 How to generate playground (+zip) from this README: [GENERATE.markdown](https://github.com/ochococo/Design-Patterns-In-Swift/blob/master/GENERATE.markdown)
