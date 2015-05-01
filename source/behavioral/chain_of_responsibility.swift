/*:
🐝 Chain Of Responsibility
--------------------------

The chain of responsibility pattern is used to process varied requests, each of which may be dealt with by a different handler.

### Example:
*/
class MoneyPile {
    let value: Int
    var quantity: Int
    var nextPile: MoneyPile?
    
    init(value: Int, quantity: Int, nextPile: MoneyPile?) {
        self.value = value
        self.quantity = quantity
        self.nextPile = nextPile
    }
    
    func canWithdraw(var v: Int) -> Bool {

        func canTakeSomeBill(want: Int) -> Bool {
            return (want / self.value) > 0
        }
        
        var q = self.quantity

        while canTakeSomeBill(v) {

            if q == 0 {
                break
            }

            v -= self.value
            q -= 1
        }

        if v == 0 {
            return true
        } else if let next = self.nextPile {
            return next.canWithdraw(v)
        }

        return false
    }
}

class ATM {
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
    
    func canWithdraw(value: Int) -> String {
        return "Can withdraw: \(self.startPile.canWithdraw(value))"
    }
}
/*:
### Usage
*/
// Create piles of money and link them together 10 < 20 < 50 < 100.**
let ten = MoneyPile(value: 10, quantity: 6, nextPile: nil)
let twenty = MoneyPile(value: 20, quantity: 2, nextPile: ten)
let fifty = MoneyPile(value: 50, quantity: 2, nextPile: twenty)
let hundred = MoneyPile(value: 100, quantity: 1, nextPile: fifty)

// Build ATM.
var atm = ATM(hundred: hundred, fifty: fifty, twenty: twenty, ten: ten)
atm.canWithdraw(310) // Cannot because ATM has only 300
atm.canWithdraw(100) // Can withdraw - 1x100
atm.canWithdraw(165) // Cannot withdraw because ATM doesn't has bill with value of 5
atm.canWithdraw(30)  // Can withdraw - 1x20, 2x10
