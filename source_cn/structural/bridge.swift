/*:
 桥接（Bridge）
 -----------
 桥接模式将抽象部分与实现部分分离，使它们都可以独立的变化。
 ### 示例：
 */
protocol Switch {
    var appliance: Appliance { get set }
    func turnOn()
}

protocol Appliance {
    func run()
}

class RemoteControl: Switch {
    var appliance: Appliance
    
    func turnOn() {
        self.appliance.run()
    }
    
    init(appliance: Appliance) {
        self.appliance = appliance
    }
}

class TV: Appliance {
    func run() {
        print("📺 打开了")
    }
}

class VacuumCleaner: Appliance {
    func run() {
        print("吸尘器打开了")
    }
}
/*:
 ### 用法：
 */
var tvRemoteControl = RemoteControl(appliance: TV())
tvRemoteControl.turnOn()

var fancyVacuumCleanerRemoteControl = RemoteControl(appliance: VacuumCleaner())
fancyVacuumCleanerRemoteControl.turnOn()
