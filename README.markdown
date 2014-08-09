```swift
import Swift
import Foundation
```

Design Patterns implemented in Swift
====================================
A short cheat-sheet with Xcode 6 Playground ([Design-Patterns.playground.zip](https://raw.githubusercontent.com/ochococo/Design-Patterns-In-Swift/master/Design-Patterns.playground.zip)).

Project maintained by: [@nsmeme](http://twitter.com/nsmeme) (Oktawian Chojnacki)

Playground generated with: [Swift Playground Builder](https://github.com/jas/swift-playground-builder) by [@jasonsandmeyer](http://twitter.com/jasonsandmeyer)

# Creational

> In software engineering, creational design patterns are design patterns that deal with object creation mechanisms, trying to create objects in a manner suitable to the situation. The basic form of object creation could result in design problems or added complexity to the design. Creational design patterns solve this problem by somehow controlling this object creation.
>
>**Source:** [wikipedia.org](http://en.wikipedia.org/wiki/Creational_pattern)

## Singleton
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
##Builder

```swift
protocol ThreeDimensions {
    var x:Double? {get}
    var y:Double? {get}
    var z:Double? {get}
}

class Point:ThreeDimensions {

    var x:Double?
    var y:Double?
    var z:Double?

    typealias PointBuilderClosure = (Point) -> ()

    init(buildClosure:PointBuilderClosure){
        buildClosure(self)
    }
}

```
**Usage:**
```swift
let fancyPoint = Point{ point in
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
let uglierPoint = Point{
    $0.x = 0.1
    $0.y = 0.2
    $0.z = 0.3
}
```


##Abstract Factory


```swift
class Number
{
    var number:AnyObject

    init(number:AnyObject){
        self.number = number
    }

    convenience init(integer:Int){
        self.init(number:integer)
    }

    convenience init(double:Double){
        self.init(number:double)
    }

    func integerValue() -> Int{
        return self.number as Int
    }

    func doubleValue() -> Double{
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

##Prototype

```swift
class ThieveryCorporationPersonDisplay{
    var name:String?
    let font:String

    init(font:String){
        self.font = font
    }

    func clone() -> ThieveryCorporationPersonDisplay{
        return ThieveryCorporationPersonDisplay(font: self.font)
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

#Structural

>In software engineering, structural design patterns are design patterns that ease the design by identifying a simple way to realize relationships between entities.
>
>**Source:** [wikipedia.org](http://en.wikipedia.org/wiki/Structural_pattern)

##Composite
##Facade
##Adapter
##Bridge
##Decorator
##Proxy

#Behavioral

>In software engineering, behavioral design patterns are design patterns that identify common communication patterns between objects and realize these patterns. By doing so, these patterns increase flexibility in carrying out this communication.
>
>**Source:** [wikipedia.org](http://en.wikipedia.org/wiki/Behavioral_pattern)

##Chain Of Responsibility
##Command
##Iterator
##Mediator
##Memento
##Observer
##State
##Strategy

```swift
protocol PrintStrategy {
    func printString(string: String) -> String
}

class Printer {

    let strategy: PrintStrategy
    
    func printString(string:String)->String
    {
        return self.strategy.printString(string);
    }
    
    init(strategy: PrintStrategy){
        self.strategy = strategy
    }
}

class UpperCaseStrategy: PrintStrategy{
    func printString(string:String)->String{
        return string.uppercaseString;
    }
}

class LowerCaseStrategy: PrintStrategy{
    func printString(string:String)->String{
        return string.lowercaseString;
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

##Visitor
