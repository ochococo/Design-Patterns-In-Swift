/*:
💡 Strategy
-----------

The strategy pattern is used to create an interchangeable family of algorithms from which the required process is chosen at run-time.

### Example
*/
protocol PrintStrategy {
    func print(_ string: String) -> String
}

final class Printer {

    private let strategy: PrintStrategy

    func print(_ string: String) -> String {
        return self.strategy.print(string)
    }

    init(strategy: PrintStrategy) {
        self.strategy = strategy
    }
}

final class UpperCaseStrategy: PrintStrategy {
    func print(_ string: String) -> String {
        return string.uppercased()
    }
}

final class LowerCaseStrategy: PrintStrategy {
    func print(_ string:String) -> String {
        return string.lowercased()
    }
}
/*:
### Usage
*/
var lower = Printer(strategy: LowerCaseStrategy())
lower.print("O tempora, o mores!")

var upper = Printer(strategy: UpperCaseStrategy())
upper.print("O tempora, o mores!")
/*:
>**Further Examples:** [Design Patterns in Swift](https://github.com/kingreza/Swift-Strategy)
*/
