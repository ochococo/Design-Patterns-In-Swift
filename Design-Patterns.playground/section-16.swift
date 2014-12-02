let messagesMediator = MessageMediator()
let user0 = ConcreteColleague(mediator: messagesMediator)
let user1 = ConcreteColleague(mediator: messagesMediator)
messagesMediator.addColleague(user0)
messagesMediator.addColleague(user1)

user0.send("Hello") // user1 receives message