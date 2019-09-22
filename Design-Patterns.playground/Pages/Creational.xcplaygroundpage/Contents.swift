//: [行为型模式](Behavioral) |
//: 创建型模式 |
//: [结构型模式](Structural)
/*:
 创建型模式
 ========
 
 > 创建型模式是处理对象创建的设计模式，试图根据实际情况使用合适的方式创建对象。基本的对象创建方式可能会导致设计上的问题，或增加设计的复杂度。创建型模式通过以某种方式控制对象的创建来解决问题。
 >
 >**来源：** [维基百科](https://zh.wikipedia.org/wiki/%E5%89%B5%E5%BB%BA%E5%9E%8B%E6%A8%A1%E5%BC%8F)
 */
import Swift
import Foundation
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
/*:
 生成器（Builder）
 --------------
 一种对象构建模式。它可以将复杂对象的建造过程抽象出来（抽象类别），使这个抽象过程的不同实现方法可以构造出不同表现（属性）的对象。
 ### 示例：
 */
class DeathStarBuilder {
    
    var x: Double?
    var y: Double?
    var z: Double?
    
    typealias BuilderClosure = (DeathStarBuilder) -> ()
    
    init(buildClosure: BuilderClosure) {
        buildClosure(self)
    }
}

struct DeathStar: CustomStringConvertible {
    
    let x: Double
    let y: Double
    let z: Double
    
    init?(builder: DeathStarBuilder) {
        
        if let x = builder.x, let y = builder.y, let z = builder.z {
            self.x = x
            self.y = y
            self.z = z
        } else {
            return nil
        }
    }
    
    var description: String {
        return "Death Star at (x:\(x) y:\(y) z:\(z))"
    }
}
/*:
 ### 用法：
 */
let empire = DeathStarBuilder { builder in
    builder.x = 0.1
    builder.y = 0.2
    builder.z = 0.3
}

let deathStar = DeathStar(builder: empire)
/*:
 > 更多示例：[Design Patterns in Swift](https://github.com/kingreza/Swift-Builder)
 */
/*:
 工厂方法（Factory Method）
 -----------------------
 定义一个创建对象的接口，但让实现这个接口的类来决定实例化哪个类。工厂方法让类的实例化推迟到子类中进行。
 ### 示例：
 */
protocol Currency {
    func symbol() -> String
    func code() -> String
}

class Euro: Currency {
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
    case unitedStates, spain, uk, greece
}

enum CurrencyFactory {
    static func currency(for country:Country) -> Currency? {
        
        switch country {
        case .spain, .greece :
            return Euro()
        case .unitedStates :
            return UnitedStatesDolar()
        default:
            return nil
        }
        
    }
}
/*:
 ### 用法：
 */
let noCurrencyCode = "无可用货币码"

CurrencyFactory.currency(for: .greece)?.code() ?? noCurrencyCode
CurrencyFactory.currency(for: .spain)?.code() ?? noCurrencyCode
CurrencyFactory.currency(for: .unitedStates)?.code() ?? noCurrencyCode
CurrencyFactory.currency(for: .uk)?.code() ?? noCurrencyCode
/*:
 原型（Prototype）
 --------------
 通过“复制”一个已经存在的实例来返回新的实例,而不是新建实例。被复制的实例就是我们所称的“原型”，这个原型是可定制的。
 ### 示例：
 */
class ChungasRevengeDisplay {
    var name: String?
    let font: String
    
    init(font: String) {
        self.font = font
    }
    
    func clone() -> ChungasRevengeDisplay {
        return ChungasRevengeDisplay(font: self.font)
    }
}
/*:
 ### 用法：
 */
let Prototype = ChungasRevengeDisplay(font:"GotanProject")

let Philippe = Prototype.clone()
Philippe.name = "Philippe"

let Christoph = Prototype.clone()
Christoph.name = "Christoph"

let Eduardo = Prototype.clone()
Eduardo.name = "Eduardo"
/*:
 > 更多示例：[Design Patterns in Swift](https://github.com/kingreza/Swift-Prototype)
 */
/*:
 单例（Singleton）
 --------------
 单例对象的类必须保证只有一个实例存在。许多时候整个系统只需要拥有一个的全局对象，这样有利于我们协调系统整体的行为
 ### 示例：
 */
class DeathStarSuperlaser {
    static let sharedInstance = DeathStarSuperlaser()
    
    private init() {
        
    }
}
/*:
 ### 用法：
 */
let laser = DeathStarSuperlaser.sharedInstance
