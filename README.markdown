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
class Number {
    var number: AnyObject

    init(number:AnyObject) {
        self.number = number
    }

    convenience init(integer: Int) {
        self.init(number: integer)
    }

    convenience init(double: Double) {
        self.init(number: double)
    }

    func integerValue() -> Int {
        return self.number as Int
    }

    func doubleValue() -> Double {
        return self.number as Double
    }
}

```
**Usage:**
```swift
let number = Number(double: 12.1)
let double = number.doubleValue()
let integer = number.integerValue()

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
    
    init(_ shapes:[Shape]) {
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
var whiteboard = Whiteboard([Circle(), Square()])
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

##🚧  Bridge
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

##🔗 Chain Of Responsibility

>In object-oriented design, the chain-of-responsibility pattern is a design pattern consisting of a source of command objects and a series of processing objects.[1] Each processing object contains logic that defines the types of command objects that it can handle; the rest are passed to the next processing object in the chain. A mechanism also exists for adding new processing objects to the end of this chain.
>
>**Source:** [wikipedia.org](http://en.wikipedia.org/wiki/Chain-of-responsibility_pattern)

```swift

class Order{
    let orderText : String
    required init(_ orderText : String){
        self.orderText = orderText
    }
}


protocol ChainProtocol{
    var nextInChain : ChainProtocol? {get}
    func handleOrder(order : Order)
    func passOrder(order : Order)
}


class Navigator : ChainProtocol{
    var nextInChain : ChainProtocol?
    
    
    init(nextInChain : ChainProtocol?){
        self.nextInChain = nextInChain;
    }

    func handleOrder(order: Order) {
        if order.orderText.rangeOfString("navigate to") != nil{
            println("Navigator execute the order \(order.orderText)")
        }else{
            passOrder(order)
        }
    }
    
    func passOrder(order : Order){
        self.nextInChain?.handleOrder(order)
    }
}

class AirGunner : ChainProtocol {
    var nextInChain : ChainProtocol?
    
    
    init(nextInChain : ChainProtocol?){
        self.nextInChain = nextInChain;
    }
    
    
    func handleOrder(order: Order) {
        if order.orderText.rangeOfString("shoot at") != nil {
            println("Air Gunner execute the order \(order.orderText)")
        }else{
            passOrder(order)
        }
    }
    
    func passOrder(order : Order){
        self.nextInChain?.handleOrder(order)
    }
}

class Captain : ChainProtocol {
    var nextInChain : ChainProtocol?
    
    
    init(nextInChain : ChainProtocol?){
        self.nextInChain = nextInChain;
    }
    func handleOrder(order: Order) {
        println("Captain executes the order \(order.orderText)")
    }
    
    func passOrder(order : Order){
        self.nextInChain?.handleOrder(order)
    }
}


class PlaneCrew{

    let captain : Captain
    let airGunner : AirGunner
    let navigator : Navigator
    
    init(){
        self.captain = Captain(nextInChain: nil)
        self.airGunner = AirGunner(nextInChain: self.captain)
        self.navigator = Navigator(nextInChain: self.airGunner)
    }
    
    func reciveOrder(order: Order){
        self.navigator.handleOrder(order);
    }
}
```

**Usage:**

```swift

let planeCrew = PlaneCrew()

let order1 = Order("navigate to enemy base")
let order2 = Order("shoot at enemy plane")
let order3 = Order("stop attack!")

planeCrew.reciveOrder(order1)
planeCrew.reciveOrder(order2)
planeCrew.reciveOrder(order3)

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

##👨  Mediator

>The Mediator defines an object that controls how a set of objects interact. Loose coupling between colleague objects is achieved by having colleagues communicate with the Mediator, rather than with each other. The control tower at a controlled airport demonstrates this pattern very well. The pilots of the planes approaching or departing the terminal area communicate with the tower rather than explicitly communicating with one another. The constraints on who can take off or land are enforced by the tower. It is important to note that the tower does not control the whole flight. It exists only to enforce constraints in the terminal area.
>
>**Source:** [sourcemaking.com](http://sourcemaking.com/design_patterns/mediator)

This source code will not work in Playground since it uses async calls - please create new project with those classes and then try it out.


```
import UIKit

class Tower{
    
    var planesLandingQueue : Array<Plane>
    var planesStartingQueue : Array<Plane>
    
    
    init(){
        planesLandingQueue = []
        planesStartingQueue = []
    }
    
    func requestPermissionToLand( plane: Plane ) -> Bool{
        println("Tower recived request for permission to land from flight: \(plane.flightNumber)")
        planesLandingQueue.append(plane)
        
        return planesLandingQueue.count == 1 && planesStartingQueue.isEmpty
    }
    
    func requestPermissionToStart(plane: Plane)-> Bool{
        println("Tower recived request for permission to start2 from flight: \(plane.flightNumber)")
        planesStartingQueue.append(plane)
        
        return planesStartingQueue.count == 1 && planesLandingQueue.isEmpty
    }
    
    func registerTakeOff(flightNumber : String){
        planesStartingQueue = planesStartingQueue.filter({ (plane : Plane) -> Bool in
            return plane.flightNumber != flightNumber;
        })
        handleNextPlane()
    }
    
    func registerTouchDown(flightNumber : String){
        planesLandingQueue = planesLandingQueue.filter({ (plane : Plane) -> Bool in
            return plane.flightNumber != flightNumber;
        })
        handleNextPlane()
    }
    
    func handleNextPlane(){
        //landing planes are handle with higher priority since they can run out of fuel
        if let nextLandingPlane = planesLandingQueue.first  {
            nextLandingPlane.startTouchDown()
        }else if let nextStartingPlane = planesStartingQueue.first {
            nextStartingPlane.startTakeOff()
        }
    }
    
}

protocol PlaneActions {
    var mediator : Tower? {get}
    func startTakeOff()
    func startTouchDown()
}

class Plane : PlaneActions {
    let flightNumber : String
    var mediator : Tower?
    
    func requestPermissionToStart() {
        
        if mediator!.requestPermissionToStart(self) {
            self.startTakeOff()
        }
        
    }
    
    func requestPermissionToLand() {
        if mediator!.requestPermissionToLand(self) {
            self.startTouchDown()
        }
    }
    
    
    init(flightNumber : String){
        self.flightNumber = flightNumber
    }
    
    func registerToTower(tower : Tower){
        mediator = tower;
    }
    
    func startTakeOff() {
        println("flight \(flightNumber) is taking of")
        dispatch_after(20000, dispatch_get_main_queue()) { () -> Void in
            self.didTakeOff()
        }
        
    }
    
    func didTakeOff(){
        println("flight \(self.flightNumber) is in the air")
        self.mediator?.registerTakeOff(self.flightNumber)
    }
    
    func startTouchDown() {
        println("flight \(flightNumber) is approaching to land")
        dispatch_after(10000, dispatch_get_main_queue()) { () -> Void in
            self.didTouchDown()
        }
    }
    
    
    func didTouchDown(){
        println("flight \(self.flightNumber) safe and sound on the ground")
        self.mediator?.registerTouchDown(self.flightNumber)
    }
}

```
**Usage:**
```swift

let tower = Tower()

let plane1 = Plane(flightNumber: "123")
let plane2 = Plane(flightNumber: "451")
let plane3 = Plane(flightNumber: "610")
let plane4 = Plane(flightNumber: "999")

plane1.registerToTower(tower)
plane2.registerToTower(tower)
plane3.registerToTower(tower)
plane4.registerToTower(tower)

plane1.requestPermissionToStart()
plane2.requestPermissionToLand()
plane4.requestPermissionToStart()
plane3.requestPermissionToLand()

```
**Output**
```
Tower recived request for permission to start2 from flight: 123
flight 123 is taking of
Tower recived request for permission to land from flight: 451
Tower recived request for permission to start2 from flight: 999
Tower recived request for permission to land from flight: 610
flight 123 is in the air
flight 451 is approaching to land
flight 451 safe and sound on the ground
flight 610 is approaching to land
flight 610 safe and sound on the ground
flight 999 is taking of
flight 999 is in the air
```


##🚧  Memento
##📩 Observer

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
