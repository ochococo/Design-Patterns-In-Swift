/*:
🌰 Abstract Factory
-------------------

The abstract factory pattern is used to provide a client with a set of related or dependant objects. 
The "family" of objects created by the factory are determined at run-time.

### Example
*/
/*: 
Protocols
*/
protocol Decimal {
    func stringValue() -> String
    // factory
    static func make(string : String) -> Decimal
}

typealias NumberFactory = (String) -> Decimal

// Number implementations with factory methods

struct NextStepNumber : Decimal {
    private var nextStepNumber : NSNumber

    func stringValue() -> String { return nextStepNumber.stringValue }
    
    // factory
    static func make(string : String) -> Decimal {
        return NextStepNumber(nextStepNumber:NSNumber(longLong:(string as NSString).longLongValue))
    }
}

struct SwiftNumber : Decimal {
    private var swiftInt : Int

    func stringValue() -> String { return "\(swiftInt)" }
    
    // factory
    static func make(string : String) -> Decimal {
        return SwiftNumber(swiftInt:(string as NSString).integerValue)
    }
}
/*:
Abstract factory
*/
enum NumberType {
    case NextStep, Swift
}

class NumberHelper {
    class func factoryFor(type : NumberType) -> NumberFactory {
        switch type {
        case .NextStep:
            return NextStepNumber.make
        case .Swift:
            return SwiftNumber.make
        }
    }
}
/*:
### Usage
*/
let factoryOne = NumberHelper.factoryFor(.NextStep)
let numberOne = factoryOne("1")
numberOne.stringValue()

let factoryTwo = NumberHelper.factoryFor(.Swift)
let numberTwo = factoryTwo("2")
numberTwo.stringValue()
