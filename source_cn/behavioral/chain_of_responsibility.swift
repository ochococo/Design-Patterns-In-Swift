/*:
 责任链（Chain Of Responsibility）
 ------------------------------
 
 责任链模式在面向对象程式设计里是一种软件设计模式，它包含了一些命令对象和一系列的处理对象。每一个处理对象决定它能处理哪些命令对象，它也知道如何将它不能处理的命令对象传递给该链中的下一个处理对象。
 
 ### 示例：
 */
final class MoneyPile {
    
    let value: Int
    var quantity: Int
    var nextPile: MoneyPile?
    
    init(value: Int, quantity: Int, nextPile: MoneyPile?) {
        self.value = value
        self.quantity = quantity
        self.nextPile = nextPile
    }
    
    func canWithdraw(amount: Int) -> Bool {
        
        var amount = amount
        
        func canTakeSomeBill(want: Int) -> Bool {
            return (want / self.value) > 0
        }
        
        var quantity = self.quantity
        
        while canTakeSomeBill(want: amount) {
            
            if quantity == 0 {
                break
            }
            
            amount -= self.value
            quantity -= 1
        }
        
        guard amount > 0 else {
            return true
        }
        
        if let next = self.nextPile {
            return next.canWithdraw(amount: amount)
        }
        
        return false
    }
}

final class ATM {
    private var hundred: MoneyPile
    private var fifty: MoneyPile
    private var twenty: MoneyPile
    private var ten: MoneyPile
    
    private var startPile: MoneyPile {
        return self.hundred
    }
    
    init(hundred: MoneyPile,
         fifty: MoneyPile,
         twenty: MoneyPile,
         ten: MoneyPile) {
        
        self.hundred = hundred
        self.fifty = fifty
        self.twenty = twenty
        self.ten = ten
    }
    
    func canWithdraw(amount: Int) -> String {
        return "能否取现：\(self.startPile.canWithdraw(amount: amount))"
    }
}
/*:
 ### 用法：
 */
// 创建一系列的钱堆，并将其链接起来：10<20<50<100
let ten = MoneyPile(value: 10, quantity: 6, nextPile: nil)
let twenty = MoneyPile(value: 20, quantity: 2, nextPile: ten)
let fifty = MoneyPile(value: 50, quantity: 2, nextPile: twenty)
let hundred = MoneyPile(value: 100, quantity: 1, nextPile: fifty)

// 创建 ATM 实例
var atm = ATM(hundred: hundred, fifty: fifty, twenty: twenty, ten: ten)
atm.canWithdraw(amount: 310)
atm.canWithdraw(amount: 100)
atm.canWithdraw(amount: 165)
atm.canWithdraw(amount: 30)

/*:
 > 更多示例：[Design Patterns in Swift](https://github.com/kingreza/Swift-Chain-Of-Responsibility)
 */
