/*:
💡 Strategy
-----------

The strategy pattern is used to create an interchangeable family of algorithms from which the required process is chosen at run-time.

### Example
*/
protocol PrintStrategy {
    func printString(string: String) -> String
}

class Printer {

    let strategy: PrintStrategy
    
    func printString(string: String) -> String {
        return self.strategy.printString(string)
    }
    
    init(strategy: PrintStrategy) {
        self.strategy = strategy
    }
}

class UpperCaseStrategy : PrintStrategy {
    func printString(string:String) -> String {
        return string.uppercaseString
    }
}

class LowerCaseStrategy : PrintStrategy {
    func printString(string:String) -> String {
        return string.lowercaseString
    }
}
/*:
### Usage
*/
var lower = Printer(strategy:LowerCaseStrategy())
lower.printString("O tempora, o mores!")

var upper = Printer(strategy:UpperCaseStrategy())
upper.printString("O tempora, o mores!")

