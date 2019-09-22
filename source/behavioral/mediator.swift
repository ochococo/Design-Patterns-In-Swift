/*:
 中介者（Mediator）
 ---------------
 用一个中介者对象封装一系列的对象交互，中介者使各对象不需要显示地相互作用，从而使耦合松散，而且可以独立地改变它们之间的交互。
 ### 示例：
 */
struct Programmer {
    let name: String
    
    init(name: String) {
        self.name = name
    }
    
    func receive(message: String) {
        print("\(name) 收到消息：\(message)")
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
 ### 用法：
 */
func spamMonster(message: String, worker: MessageSending) {
    worker.send(message: message)
}

let messagesMediator = MessageMediator()

let user0 = Programmer(name: "Linus Torvalds")
let user1 = Programmer(name: "Dylan Wang")
messagesMediator.add(recipient: user0)
messagesMediator.add(recipient: user1)

spamMonster(message: "我希望添加您到我的职业网络", worker: messagesMediator)
/*:
 > 更多示例：[Design Patterns in Swift](https://github.com/kingreza/Swift-Mediator)
 */
