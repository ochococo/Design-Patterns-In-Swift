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