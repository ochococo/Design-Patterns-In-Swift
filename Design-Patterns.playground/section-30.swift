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