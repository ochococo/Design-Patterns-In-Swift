##👫 Command

The command pattern is used to express a request, including the call to be made and all of its required parameters, in a command object. The command may then be executed immediately or held for later use.

**Example:**

```swift
protocol FileOperationCommand {
    init(file: String)
    func execute()
}

class FileMoveCommand : FileOperationCommand {
    let file:String

    required init(file: String) {
        self.file = file
    }
    
    func execute() {
        print("\(file) moved")
    }
}

class FileDeleteCommand : FileOperationCommand {
    let file:String

    required init(file: String) {
        self.file = file
    }
    
    func execute() {
        print("\(file) deleted")
    }
}

class FileManager {
    let deleteCommand: FileOperationCommand
    let moveCommand: FileOperationCommand
    
    init(deleteCommand: FileDeleteCommand, moveCommand: FileMoveCommand) {
        self.deleteCommand = deleteCommand
        self.moveCommand = moveCommand
    }
    
    func delete() {
        deleteCommand.execute()
    }
    
    func move() {
        moveCommand.execute()
    }
}
```

**Usage:**
```swift
let deleteCommand = FileDeleteCommand(file: "/path/to/testfile")
let moveCommand = FileMoveCommand(file: "/path/to/testfile")
let fileManager = FileManager(deleteCommand:deleteCommand , moveCommand: moveCommand)

fileManager.delete()
fileManager.move()
```

