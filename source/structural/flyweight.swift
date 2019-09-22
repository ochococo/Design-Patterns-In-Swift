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
