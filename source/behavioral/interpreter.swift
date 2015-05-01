/*:
🎶 Interpreter
--------------

The interpreter pattern is used to evaluate sentences in a language.

### Example
*/

protocol IntegerExp {
    func evaluate(context: IntegerContext) -> Int
    func replace(character: Character, integerExp: IntegerExp) -> IntegerExp
    func copy() -> IntegerExp
}

class IntegerContext {
    private var data: [Character:Int] = [:]
    
    func lookup(name: Character) -> Int {
        return self.data[name]!
    }
    
    func assign(integerVarExp: IntegerVarExp, value: Int) {
        self.data[integerVarExp.name] = value
    }
}

class IntegerVarExp: IntegerExp {
    let name: Character
    
    init(name: Character) {
        self.name = name
    }
    
    func evaluate(context: IntegerContext) -> Int {
        return context.lookup(self.name)
    }
    
    func replace(name: Character, integerExp: IntegerExp) -> IntegerExp {
        if name == self.name {
            return integerExp.copy()
        } else {
            return IntegerVarExp(name: self.name)
        }
    }
    
    func copy() -> IntegerExp {
        return IntegerVarExp(name: self.name)
    }
}

class AddExp: IntegerExp {
    private var operand1: IntegerExp
    private var operand2: IntegerExp
    
    init(op1: IntegerExp, op2: IntegerExp) {
        self.operand1 = op1
        self.operand2 = op2
    }
    
    func evaluate(context: IntegerContext) -> Int {
        return self.operand1.evaluate(context) + self.operand2.evaluate(context)
    }
    
    func replace(character: Character, integerExp: IntegerExp) -> IntegerExp {
        return AddExp(op1: operand1.replace(character, integerExp: integerExp),
            op2: operand2.replace(character, integerExp: integerExp))
    }
    
    func copy() -> IntegerExp {
        return AddExp(op1: self.operand1, op2: self.operand2)
    }
}
/*:
### Usage
*/
var expression: IntegerExp?
var intContext = IntegerContext()

var a = IntegerVarExp(name: "A")
var b = IntegerVarExp(name: "B")
var c = IntegerVarExp(name: "C")

expression = AddExp(op1: a, op2: AddExp(op1: b, op2: c)) // a + (b + c)

intContext.assign(a, value: 2)
intContext.assign(b, value: 1)
intContext.assign(c, value: 3)

var result = expression?.evaluate(intContext)
