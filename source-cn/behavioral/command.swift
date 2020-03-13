/*:
👫 命令（Command）
 ------------
 命令模式是一种设计模式，它尝试以对象来代表实际行动。命令对象可以把行动(action) 及其参数封装起来，于是这些行动可以被：
 * 重复多次
 * 取消（如果该对象有实现的话）
 * 取消后又再重做
 ### 示例：
*/
protocol DoorCommand {
    func execute() -> String
}

final class OpenCommand: DoorCommand {
    let doors:String

    required init(doors: String) {
        self.doors = doors
    }
    
    func execute() -> String {
        return "Opened \(doors)"
    }
}

final class CloseCommand: DoorCommand {
    let doors:String

    required init(doors: String) {
        self.doors = doors
    }
    
    func execute() -> String {
        return "Closed \(doors)"
    }
}

final class HAL9000DoorsOperations {
    let openCommand: DoorCommand
    let closeCommand: DoorCommand
    
    init(doors: String) {
        self.openCommand = OpenCommand(doors:doors)
        self.closeCommand = CloseCommand(doors:doors)
    }
    
    func close() -> String {
        return closeCommand.execute()
    }
    
    func open() -> String {
        return openCommand.execute()
    }
}
/*:
### 用法
*/
let podBayDoors = "Pod Bay Doors"
let doorModule = HAL9000DoorsOperations(doors:podBayDoors)

doorModule.open()
doorModule.close()
