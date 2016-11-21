/*:
💐 Mediator
-----------

The mediator pattern is used to reduce coupling between classes that communicate with each other. Instead of classes communicating directly, and thus requiring knowledge of their implementation, the classes send messages via a mediator object.

### Example
*/
struct Programmer {

    let name: String

    init(name: String) {
        self.name = name
    }

    func receive(message: String) {
        print("\(name) received: \(message)")
    }
}

protocol MessageSending {
    func send(message: String)
}

final class MessageMediator: MessageSending {

    private var recipients: [Programmer] = []

    func add(recipient: Programmer) {
        recipients.append(recipient)
    }

    func send(message: String) {
        for recipient in recipients {
            recipient.receive(message: message)
        }
    }
}
/*:
### Usage
*/
func spamMonster(message: String, worker: MessageSending) {
    worker.send(message: message)
}

let messagesMediator = MessageMediator()

let user0 = Programmer(name: "Linus Torvalds")
let user1 = Programmer(name: "Avadis 'Avie' Tevanian")
messagesMediator.add(recipient: user0)
messagesMediator.add(recipient: user1)

spamMonster(message: "I'd Like to Add you to My Professional Network", worker: messagesMediator)
/*:
>**Further Examples:** [Design Patterns in Swift](https://github.com/kingreza/Swift-Mediator)
*/
