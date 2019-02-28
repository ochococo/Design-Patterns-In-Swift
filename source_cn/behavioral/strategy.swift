/*:
 策略（Strategy）
 --------------
 对象有某个行为，但是在不同的场景中，该行为有不同的实现算法。策略模式：
 * 定义了一族算法（业务规则）；
 * 封装了每个算法；
 * 这族的算法可互换代替（interchangeable）。
 ### 示例：
 */
protocol PrintStrategy {
    func print(_ string: String) -> String
}

final class Printer {
    
    private let strategy: PrintStrategy
    
    init(strategy: PrintStrategy) {
        self.strategy = strategy
    }
    
    func print(_ string: String) -> String {
        return self.strategy.print(string)
    }
}

final class UpperCaseStrategy: PrintStrategy {
    func print(_ string: String) -> String {
        return string.uppercased()
    }
}

final class LowerCaseStrategy: PrintStrategy {
    func print(_ string: String) -> String {
        return string.lowercased()
    }
}
/*:
 ### 用法
 */
var lower = Printer(strategy: LowerCaseStrategy())
lower.print("0 tempora, o mores")

var upper = Printer(strategy: UpperCaseStrategy())
upper.print("0 tempora, o mores")
/*:
 > 更多示例：[Design Patterns in Swift](https://github.com/kingreza/Swift-Strategy)
 */
