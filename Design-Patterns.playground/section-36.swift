protocol FileOperationCommand {
    func execute(file: String)
}

class FileMoveCommand : FileOperationCommand {
    func execute(file: String) {
        print("\(file) moved")
    }
}

class FileDeleteCommand : FileOperationCommand {
    func execute(file: String) {
        print("\(file) deleted")
    }
}

class FileManager {
    let operation: FileOperationCommand

    init(operation: FileOperationCommand) {
        self.operation = operation
    }

    func executeOn(# file:String) {
        self.operation.execute(file)
    }
}