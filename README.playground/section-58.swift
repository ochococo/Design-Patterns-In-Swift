let deleteCommand = FileDeleteCommand(file: "/path/to/testfile")
let moveCommand = FileMoveCommand(file: "/path/to/testfile")
let fileManager = FileManager(deleteCommand:deleteCommand , moveCommand: moveCommand)

fileManager.delete()
fileManager.move()