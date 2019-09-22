//: [行为型模式](Behavioral) |
//: [创建型模式](Creational) |
//: 结构型模式
/*:
 结构型模式（Structural）
 ====================
 
 > 在软件工程中结构型模式是设计模式，借由一以贯之的方式来了解元件间的关系，以简化设计。
 >
 >**来源：** [维基百科](https://zh.wikipedia.org/wiki/%E7%B5%90%E6%A7%8B%E5%9E%8B%E6%A8%A1%E5%BC%8F)
 */
import Swift
import Foundation
/*:
 适配器（Adapter）
 --------------
 
 适配器模式有时候也称包装样式或者包装(wrapper)。将一个类的接口转接成用户所期待的。一个适配使得因接口不兼容而不能在一起工作的类工作在一起，做法是将类自己的接口包裹在一个已存在的类中。
 ### 示例：
 */
protocol OlderDeathStarSuperLaserAiming {
    var angleV: NSNumber { get }
    var angleH: NSNumber { get }
}
/*:
 **被适配者**
 */
struct DeathStarSuperlaserTarget {
    let angleHorizontal: Double
    let angleVertical: Double
    
    init(angleHorizontal: Double, angleVertical: Double) {
        self.angleHorizontal = angleHorizontal
        self.angleVertical = angleVertical
    }
}
/*:
 **适配器**
 */
struct OldDeathStarSuperlaserTarget: OlderDeathStarSuperLaserAiming {
    private let target: DeathStarSuperlaserTarget
    
    var angleV: NSNumber {
        return NSNumber(value: target.angleVertical)
    }
    
    var angleH: NSNumber {
        return NSNumber(value: target.angleHorizontal)
    }
    
    init(_ target: DeathStarSuperlaserTarget) {
        self.target = target
    }
}
/*:
 ### 用法：
 */
let target = DeathStarSuperlaserTarget(angleHorizontal: 14.0, angleVertical: 12.0)
let oldFormat = OldDeathStarSuperlaserTarget(target)

oldFormat.angleH
oldFormat.angleV
/*:
 更多示例：[Design Patterns in Swift](https://github.com/kingreza/Swift-Adapter)
 */
/*:
 桥接（Bridge）
 -----------
 桥接模式将抽象部分与实现部分分离，使它们都可以独立的变化。
 ### 示例：
 */
protocol Switch {
    var appliance: Appliance { get set }
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
        print("📺 打开了")
    }
}

class VacuumCleaner: Appliance {
    func run() {
        print("吸尘器打开了")
    }
}
/*:
 ### 用法：
 */
var tvRemoteControl = RemoteControl(appliance: TV())
tvRemoteControl.turnOn()

var fancyVacuumCleanerRemoteControl = RemoteControl(appliance: VacuumCleaner())
fancyVacuumCleanerRemoteControl.turnOn()
/*:
 组合（Composite）
 --------------
 将对象组合成树形结构以表示‘部分-整体’的层次结构。组合模式使得用户对单个对象和组合对象的使用具有一致性。
 ### 示例：
 */
/*:
 组件（Component）
 */
protocol Shape {
    func draw(fillColor: String)
}
/*:
 叶子节点（Leafs）
 */
final class Square: Shape {
    func draw(fillColor: String) {
        print("画（\(fillColor)）颜色的方形")
    }
}

final class Circle: Shape {
    func draw(fillColor: String) {
        print("画（\(fillColor)）颜色的圆形")
    }
}
/*:
 组合
 */
final class Whiteboard: Shape {
    lazy var shapes = [Shape]()
    
    init(_ shapes: Shape...) {
        self.shapes = shapes
    }
    
    func draw(fillColor: String) {
        for shape in self.shapes {
            shape.draw(fillColor: fillColor)
        }
    }
}
/*:
 ### 用法：
 */
var whiteboard = Whiteboard(Circle(), Square())
whiteboard.draw(fillColor: "红")
/*:
 修饰（Decorator）
 --------------
 修饰模式，是面向对象编程领域中，一种动态地往一个类中添加新的行为的设计模式。
 就功能而言，修饰模式相比生成子类更为灵活，这样可以给某个对象而不是整个类添加一些功能。
 ### 示例：
 */
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
    fileprivate let ingredientSeparator: String = ","
    
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

final class Milk: CoffeeDecorator {
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

final class WhipCoffee: CoffeeDecorator {
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
/*:
 ### 用法：
 */
var someCoffee: Coffee = SimpleCoffee()
print("Cost : \(someCoffee.getCost()); Ingredients: \(someCoffee.getIngredients())")
someCoffee = Milk(decoratedCoffee: someCoffee)
print("Cost : \(someCoffee.getCost()); Ingredients: \(someCoffee.getIngredients())")
someCoffee = WhipCoffee(decoratedCoffee: someCoffee)
print("Cost : \(someCoffee.getCost()); Ingredients: \(someCoffee.getIngredients())")
/*:
 外观（Facade）
 -----------
 外观模式为子系统中的一组接口提供一个统一的高层接口，使得子系统更容易使用。
 ### 示例：
 */
enum Eternal {
    
    static func set(_ object: Any, forKey defaultName: String) {
        let defaults: UserDefaults = UserDefaults.standard
        defaults.set(object, forKey: defaultName)
        defaults.synchronize()
    }
    
    static func object(forKey key: String) -> AnyObject! {
        let defaults: UserDefaults = UserDefaults.standard
        return defaults.object(forKey: key) as AnyObject
    }
}
/*:
 ### 用法：
 */
Eternal.set("Disconnect me. I’d rather be nothing", forKey:"Bishop")
Eternal.object(forKey: "Bishop")
/*:
 享元（Flyweight）
 --------------
 使用共享物件，用来尽可能减少内存使用量以及分享资讯给尽可能多的相似物件；它适合用于当大量物件只是重复因而导致无法令人接受的使用大量内存。
 ### 示例：
 */
final class SpecialityCoffee: CustomStringConvertible {
    var origin: String
    var description: String {
        get {
            return origin
        }
    }
    
    init(origin: String) {
        self.origin = origin
    }
}

final class Menu {
    private var coffeeAvailable: [String: SpecialityCoffee] = [:]
    
    func lookup(origin: String) -> SpecialityCoffee? {
        if coffeeAvailable.index(forKey: origin) == nil {
            coffeeAvailable[origin] = SpecialityCoffee(origin: origin)
        }
        
        return coffeeAvailable[origin]
    }
}

final class CoffeeShop {
    private var orders: [Int: SpecialityCoffee] = [:]
    private var menu = Menu()
    
    func takeOrder(origin: String, table: Int) {
        orders[table] = menu.lookup(origin: origin)
    }
    
    func serve() {
        for (table, origin) in orders {
            print("Serving \(origin) to table \(table)")
        }
    }
}
/*:
 ### 用法：
 */
let coffeeShop = CoffeeShop()

coffeeShop.takeOrder(origin: "Yirgacheffe, Ethiopia", table: 1)
coffeeShop.takeOrder(origin: "Buziraguhindwa, Burundi", table: 3)

coffeeShop.serve()
/*:
☔ Protection Proxy
------------------

The proxy pattern is used to provide a surrogate or placeholder object, which references an underlying object. 
Protection proxy is restricting access.

### Example
*/
protocol DoorOperator {
    func open(doors: String) -> String
}

class HAL9000 : DoorOperator {
    func open(doors: String) -> String {
        return ("HAL9000: Affirmative, Dave. I read you. Opened \(doors).")
    }
}

class CurrentComputer : DoorOperator {
    private var computer: HAL9000!

    func authenticate(password: String) -> Bool {

        guard password == "pass" else {
            return false;
        }

        computer = HAL9000()

        return true
    }

    func open(doors: String) -> String {

        guard computer != nil else {
            return "Access Denied. I'm afraid I can't do that."
        }

        return computer.open(doors: doors)
    }
}
/*:
### Usage
*/
let computer = CurrentComputer()
let podBay = "Pod Bay Doors"

computer.open(doors: podBay)

computer.authenticate(password: "pass")
computer.open(doors: podBay)
/*:
🍬 Virtual Proxy
----------------

The proxy pattern is used to provide a surrogate or placeholder object, which references an underlying object. 
Virtual proxy is used for loading object on demand.

### Example
*/
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
/*:
### Usage
*/
let humanInterface = HEVSuitHumanInterface()
humanInterface.administerMorphine()
