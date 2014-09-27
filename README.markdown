```swift
import Swift
import Foundation
```

Design Patterns implemented in Swift
====================================
A short cheat-sheet with Xcode 6 Playground ([Design-Patterns.playground.zip](https://raw.githubusercontent.com/ochococo/Design-Patterns-In-Swift/master/Design-Patterns.playground.zip)).

👷 Project maintained by: [@nsmeme](http://twitter.com/nsmeme) (Oktawian Chojnacki)

🍺 Playground generated with: [Swift Playground Builder](https://github.com/jas/swift-playground-builder) by [@jasonsandmeyer](http://twitter.com/jasonsandmeyer)

🚀 How to generate playground (+zip) from this README: [GENERATE.markdown](https://github.com/ochococo/Design-Patterns-In-Swift/blob/master/GENERATE.markdown)

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
protocol Shape {
    func draw()
}
class Rectangle: Shape {
    func draw() { println("Inside Rectangle draw method") }
}
class Square: Shape {
    func draw() { println("Inside Square draw method") }
}
class Circle: Shape {
    func draw() { println("Inside Circle draw method") }
}

protocol Color {
    func fill()
}
class Red: Color {
    func fill() { println("Inside Red fill method") }
}
class Green: Color {
    func fill() { println("Inside Green fill method") }
}

class Blue: Color {
    func fill() { println("Inside Blue fill method") }
}

protocol AbstractFactory {
    func getColor(color: String) -> Color?
    func getShape(shape: String) -> Shape?
}

class ShapeFactory: AbstractFactory {
    func getShape(shape: String) -> Shape? {
        switch shape {
        case "Circle":
            return Circle()
        case "Rectangle":
            return Rectangle()
        case "Square":
            return Square()
        default:
            return nil
        }
    }
    func getColor(color: String) -> Color? {
        return nil
    }
}

class ColorFactory: AbstractFactory {
    func getColor(color: String) -> Color? {
        switch color {
        case "Red":
            return Red()
        case "Blue":
            return Blue()
        case "Green":
            return Green()
        default:
            return nil
        }
    }
    func getShape(shape: String) -> Shape? {
        return nil
    }
}

class FactoryProducer {
    class func getFactory(choice: String) -> AbstractFactory? {
        if choice == "Shape" {
            return ShapeFactory()
        } else if choice == "Color" {
            return ColorFactory()
        } else {
            return nil
        }
    }
}
```
**Usage:**
```swift
let shapeFactory: AbstractFactory? = FactoryProducer.getFactory("Shape")
let someCircle = shapeFactory?.getShape("Circle")
someCircle?.draw()
let someRectangle = shapeFactory?.getShape("Rectangle")
someRectangle?.draw()
let someSquare = shapeFactory?.getShape("Square")
someSquare?.draw()

let colorFactory: AbstractFactory? = FactoryProducer.getFactory("Color")
let someRed: Color? = colorFactory?.getColor("Red")
someRed?.fill()
let someBlue: Color? = colorFactory?.getColor("Blue")
someBlue?.fill()
let someGreen: Color? = colorFactory?.getColor("Green")
someGreen?.fill()
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

    class func convert(#point:Point, base:Double, negative:Bool) -> Point{

        var pointConverted = Point{
            if let x = point.x{ $0.x = x * base * (negative ? -1.0 : 1.0) }
            if let y = point.y{ $0.y = y * base * (negative ? -1.0 : 1.0) }
            if let z = point.z{ $0.z = z * base * (negative ? -1.0 : 1.0) }
        }
        
        return pointConverted
    }
}

extension PointConverter{
    
    class func convert(#x:Double!, y:Double!, z:Double!, base:Double!, negative:Bool!) -> (x:Double!,y:Double!,z:Double!){

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


##🚧  Proxy

#Behavioral

>In software engineering, behavioral design patterns are design patterns that identify common communication patterns between objects and realize these patterns. By doing so, these patterns increase flexibility in carrying out this communication.
>
>**Source:** [wikipedia.org](http://en.wikipedia.org/wiki/Behavioral_pattern)

##🚧 Chain Of Responsibility
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
    
    func delete () {
        deleteCommand.execute()
    }
    
    func move () {
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
	func changeStateToAuthorized(#userId: String) {
		state = AuthorizedState(userId: userId)
	}
	func changeStateToUnauthorized() {
		state = UnauthorizedState()
	}
	var isAuthorized: Bool {
		get { return state.isAuthorized(self) }
	}
	var userId: String? {
		get { return state.userId(self) }
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
    
    func printString(string:String) -> String {
        return self.strategy.printString(string)
    }
    
    init(strategy: PrintStrategy) {
        self.strategy = strategy
    }
}

class UpperCaseStrategy: PrintStrategy {
    func printString(string:String) -> String {
        return string.uppercaseString
    }
}

class LowerCaseStrategy: PrintStrategy {
    func printString(string:String) -> String {
        return string.lowercaseString
    }
}
```
**Usage:**
```swift
var lower = Printer(strategy: LowerCaseStrategy())
lower.printString("O tempora, o mores!")

var upper = Printer(strategy: UpperCaseStrategy())
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
