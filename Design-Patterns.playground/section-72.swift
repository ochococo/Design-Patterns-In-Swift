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