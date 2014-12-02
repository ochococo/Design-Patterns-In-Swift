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
        println("Colleague received: \(message)")
    }
}