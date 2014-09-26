
class Order{
    let orderText : String
    required init(_ orderText : String){
        self.orderText = orderText
    }
}


protocol ChainProtocol{
    var nextInChain : ChainProtocol? {get}
    func handleOrder(order : Order)
    func passOrder(order : Order)
}


class Navigator : ChainProtocol{
    var nextInChain : ChainProtocol?
    
    
    init(nextInChain : ChainProtocol?){
        self.nextInChain = nextInChain;
    }

    func handleOrder(order: Order) {
        if order.orderText.rangeOfString("navigate to") != nil{
            println("Navigator execute the order \(order.orderText)")
        }else{
            passOrder(order)
        }
    }
    
    func passOrder(order : Order){
        self.nextInChain?.handleOrder(order)
    }
}

class AirGunner : ChainProtocol {
    var nextInChain : ChainProtocol?
    
    
    init(nextInChain : ChainProtocol?){
        self.nextInChain = nextInChain;
    }
    
    
    func handleOrder(order: Order) {
        if order.orderText.rangeOfString("shoot at") != nil {
            println("Air Gunner execute the order \(order.orderText)")
        }else{
            passOrder(order)
        }
    }
    
    func passOrder(order : Order){
        self.nextInChain?.handleOrder(order)
    }
}

class Captain : ChainProtocol {
    var nextInChain : ChainProtocol?
    
    
    init(nextInChain : ChainProtocol?){
        self.nextInChain = nextInChain;
    }
    func handleOrder(order: Order) {
        println("Captain executes the order \(order.orderText)")
    }
    
    func passOrder(order : Order){
        self.nextInChain?.handleOrder(order)
    }
}


class PlaneCrew{

    let captain : Captain
    let airGunner : AirGunner
    let navigator : Navigator
    
    init(){
        self.captain = Captain(nextInChain: nil)
        self.airGunner = AirGunner(nextInChain: self.captain)
        self.navigator = Navigator(nextInChain: self.airGunner)
    }
    
    func reciveOrder(order: Order){
        self.navigator.handleOrder(order);
    }
}