/*:
💐 Mediator
-----------

The mediator pattern is used to reduce coupling between classes that communicate with each other. Instead of classes communicating directly, and thus requiring knowledge of their implementation, the classes send messages via a mediator object.

### Example
*/

class Colleague {
    let name: String
    let mediator: Mediator
    
    init(name: String, mediator: Mediator) {
        self.name = name
        self.mediator = mediator
    }
    
    func send(message: String) {
        mediator.send(message, colleague: self)
    }
    
    func receive(message: String) {
        assert(false, "Method should be overriden")
    }
}

protocol Mediator {
    func send(message: String, colleague: Colleague)
}

class MessageMediator: Mediator {
    private var colleagues: [Colleague] = []
    
    func addColleague(colleague: Colleague) {
        colleagues.append(colleague)
    }
    
    func send(message: String, colleague: Colleague) {
        for c in colleagues {
            if c !== colleague { //for simplicity we compare object references
                c.receive(message)
            }
        }
    }
}

class ConcreteColleague: Colleague {
    override func receive(message: String) {
        print("Colleague \(name) received: \(message)")
    }
}

/*:
### Usage
*/

let messagesMediator = MessageMediator()
let user0 = ConcreteColleague(name: "0", mediator: messagesMediator)
let user1 = ConcreteColleague(name: "1", mediator: messagesMediator)
messagesMediator.addColleague(user0)
messagesMediator.addColleague(user1)

user0.send("Hello") // user1 receives message
