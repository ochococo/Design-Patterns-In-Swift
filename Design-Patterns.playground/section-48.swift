protocol DoorOperator {
    func openDoors(doors: String) -> String
}

class HAL9000 : DoorOperator {
    func openDoors(doors: String) -> String {
        return ("HAL9000: Affirmative, Dave. I read you. Opened \(doors).")
    }
}

class CurrentComputer : DoorOperator {
    private var computer: HAL9000!

    func authenticateWithPassword(pass: String) -> Bool {

        if pass != "pass" {
            return false
        }

        computer = HAL9000()

        return true
    }
    
    func openDoors(doors: String) -> String {

        if (computer == nil) {
            return "Access Denied. I'm afraid I can't do that."
        }
        
        return computer.openDoors(doors)
    }
}