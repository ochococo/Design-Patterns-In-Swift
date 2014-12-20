##☔ Protection Proxy

The proxy pattern is used to provide a surrogate or placeholder object, which references an underlying object. 
Protection proxy is restricting access.

**Example:**

```swift
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

        if computer == nil {
            return "Access Denied. I'm afraid I can't do that."
        }
        
        return computer.openDoors(doors)
    }
}
```

**Usage:**
```swift
let computer = CurrentComputer()
let doors = "Pod Bay Doors"

computer.openDoors(doors)

computer.authenticateWithPassword("pass")
computer.openDoors(doors)
```

