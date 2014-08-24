var fileManager = FileManager(operation: FileDeleteCommand())
fileManager.executeOn(file: "/path/to/testfile")

fileManager = FileManager(operation: FileMoveCommand())
fileManager.executeOn(file: "/path/to/testfile")