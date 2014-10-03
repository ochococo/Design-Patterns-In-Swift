```swift
import Swift
import Foundation
```

Design Patterns implemented in Swift
====================================
A short cheat-sheet with Xcode 6 Playground ([Design-Patterns.playground.zip](https://raw.githubusercontent.com/ochococo/Design-Patterns-In-Swift/master/Design-Patterns.playground.zip)).

👷 Project maintained by: [@nsmeme](http://twitter.com/nsmeme) (Oktawian Chojnacki)

# Creational

> In software engineering, creational design patterns are design patterns that deal with object creation mechanisms, trying to create objects in a manner suitable to the situation. The basic form of object creation could result in design problems or added complexity to the design. Creational design patterns solve this problem by somehow controlling this object creation.
>
>**Source:** [wikipedia.org](http://en.wikipedia.org/wiki/Creational_pattern)

##💍 Singleton
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
##👷 Builder

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

##🌰 Abstract Factory

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
        
        switch (type) {
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


##🃏 Prototype

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

##🏭 Factory Method

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

#Structural

>In software engineering, structural design patterns are design patterns that ease the design by identifying a simple way to realize relationships between entities.
>
>**Source:** [wikipedia.org](http://en.wikipedia.org/wiki/Structural_pattern)

##🌿 Composite

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

##🎁 Façade

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

##🔌 Adapter
```swift
// WARNING: This example uses Point class from Builder pattern!

class PointConverter {

    class func convert(#point:Point, base:Double, negative:Bool) -> Point {
        var pointConverted = Point{
            if let x = point.x{ $0.x = x * base * (negative ? -1.0 : 1.0) }
            if let y = point.y{ $0.y = y * base * (negative ? -1.0 : 1.0) }
            if let z = point.z{ $0.z = z * base * (negative ? -1.0 : 1.0) }
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

##🍧 Decorator

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


##🍬  Virtual Proxy

**Source:**
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

##☔  Protection Proxy

**Source:**
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


#Behavioral

>In software engineering, behavioral design patterns are design patterns that identify common communication patterns between objects and realize these patterns. By doing so, these patterns increase flexibility in carrying out this communication.
>
>**Source:** [wikipedia.org](http://en.wikipedia.org/wiki/Behavioral_pattern)

##🚧 Chain Of Responsibility
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
        println("value to withdraw: \(v)")

        func canTakeSomeBill(want: Int) -> Bool {
            return (want / self.value) > 0
        }
        
        var q = self.quantity
        while canTakeSomeBill(v) {
            if (q == 0) {
                break
            }
            
            v -= self.value
            q--
            println("- \(self.value)")
        }

        if (v == 0) {
            return true
        } else if let next = self.nextPile {
            return next.canWithdraw(v)
        }

        println("rest: \(v)")
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
    
    init(hundred: MoneyPile, fifty: MoneyPile, twenty: MoneyPile, ten: MoneyPile) {
        self.hundred = hundred
        self.fifty = fifty
        self.twenty = twenty
        self.ten = ten
    }
    
    func canWithdraw(value: Int) -> Bool {
        return self.startPile.canWithdraw(value)
    }
}
```

**Usage:**
```swift
/// Create piles of money and link them together 10 < 20 < 50 < 100
var ten = MoneyPile(value: 10, quantity: 6, nextPile: nil)
var twenty = MoneyPile(value: 20, quantity: 2, nextPile: ten)
var fifty = MoneyPile(value: 50, quantity: 2, nextPile: twenty)
var hundred = MoneyPile(value: 100, quantity: 1, nextPile: fifty)

/// build atm
var atm = ATM(hundred: hundred, fifty: fifty, twenty: twenty, ten: ten)
var canWithdraw = atm.canWithdraw

println("Can withdraw = \(canWithdraw(310))") // false, 1x100, 2x50, 2x20, 6x10. 10 is missing
println("Can withdraw = \(canWithdraw(100))") // true, 1x100
println("Can withdraw = \(canWithdraw(165))") // false, cannot withdraw because no 5 bill inside
println("Can withdraw = \(canWithdraw(30))") // true, 1x20, 1x10
```


##👫 Command

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
##🚧  Mediator
##🚧  Memento
##👓 Observer

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

Info
====

🍺 Playground generated with: [Swift Playground Builder](https://github.com/jas/swift-playground-builder) by [@jasonsandmeyer](http://twitter.com/jasonsandmeyer)

🚀 How to generate playground (+zip) from this README: [GENERATE.markdown](https://github.com/ochococo/Design-Patterns-In-Swift/blob/master/GENERATE.markdown)
