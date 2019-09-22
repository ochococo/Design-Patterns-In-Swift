/*:
 抽象工厂（Abstract Factory）
 -------------
 抽象工厂模式提供了一种方式，可以将一组具有同一主题的单独的工厂封装起来。在正常使用中，客户端程序需要创建抽象工厂的具体实现，然后使用抽象工厂作为接口来创建这一主题的具体对象。
 ### 示例：
 */
/*:
 协议
 */
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
/*:
 抽象工厂
 */
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
/*:
 用法：
 */
let factoryOne = NumberHelper.factory(for: .nextStep)
let numberOne = factoryOne("1")
numberOne.stringValue()

let factoryTwo = NumberHelper.factory(for: .swift)
let nemberTwo = factoryTwo("2")
nemberTwo.stringValue()
