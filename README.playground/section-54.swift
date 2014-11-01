// Create piles of money and link them together 10 < 20 < 50 < 100.
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