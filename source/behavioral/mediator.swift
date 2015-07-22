/*:
💐 Mediator
-----------

The mediator pattern is used to reduce coupling between classes that communicate with each other. Instead of classes communicating directly, and thus requiring knowledge of their implementation, the classes send messages via a mediator object.

### Example
*/

class Colleague {
    let mediator: Mediator
    
    init(mediator: Mediator) {
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
                colleague.receive(message)
            }
        }
    }
}

class ConcreteColleague: Colleague {
    override func receive(message: String) {
        print("Colleague received: \(message)")
    }
}

/*:
### Usage
*/

let messagesMediator = MessageMediator()
let user0 = ConcreteColleague(mediator: messagesMediator)
let user1 = ConcreteColleague(mediator: messagesMediator)
messagesMediator.addColleague(user0)
messagesMediator.addColleague(user1)

user0.send("Hello") // user1 receives message
