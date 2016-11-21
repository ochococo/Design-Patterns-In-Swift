/*:
## 🍃 Flyweight
The flyweight pattern is used to minimize memory usage or computational expenses by sharing as much as possible with other similar objects.
### Example
*/
// Instances of CoffeeFlavour will be the Flyweights
class CoffeeFlavor : Printable {
    var flavor: String
    var description: String {
        get {
            return flavor
        }
    }

    init(flavor: String) {
        self.flavor = flavor
    }
}

// Menu acts as a factory and cache for CoffeeFlavour flyweight objects
class Menu {
    private var flavors: [String: CoffeeFlavor] = [:]

    func lookup(flavor: String) -> CoffeeFlavor {
        if flavors.indexForKey(flavor) == nil {
            flavors[flavor] = CoffeeFlavor(flavor: flavor)
        }
        return flavors[flavor]!
    }
}

class CoffeeShop {
    private var orders: [Int: CoffeeFlavor] = [:]
    private var menu = Menu()

    func takeOrder(#flavor: String, table: Int) {
        orders[table] = menu.lookup(flavor)
    }

    func serve() {
        for (table, flavor) in orders {
            println("Serving \(flavor) to table \(table)")
        }
    }
}
/*:
### Usage
*/
let coffeeShop = CoffeeShop()

coffeeShop.takeOrder(flavor: "Cappuccino", table: 1)
coffeeShop.takeOrder(flavor: "Frappe", table: 3);
coffeeShop.takeOrder(flavor: "Espresso", table: 2);
coffeeShop.takeOrder(flavor: "Frappe", table: 15);
coffeeShop.takeOrder(flavor: "Cappuccino", table: 10);
coffeeShop.takeOrder(flavor: "Frappe", table: 8);
coffeeShop.takeOrder(flavor: "Espresso", table: 7);
coffeeShop.takeOrder(flavor: "Cappuccino", table: 4);
coffeeShop.takeOrder(flavor: "Espresso", table: 9);
coffeeShop.takeOrder(flavor: "Frappe", table: 12);
coffeeShop.takeOrder(flavor: "Cappuccino", table: 13);
coffeeShop.takeOrder(flavor: "Espresso", table: 5);

coffeeShop.serve()
