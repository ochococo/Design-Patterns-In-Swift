/*:
🍬 虚拟代理（Virtual Proxy）
----------------

在代理模式中，创建一个类代表另一个底层类的功能。
虚拟代理用于对象的需时加载。

### 示例：
*/
protocol HEVSuitMedicalAid {
    func administerMorphine() -> String
}

final class HEVSuit: HEVSuitMedicalAid {
    func administerMorphine() -> String {
        return "Morphine administered."
    }
}

final class HEVSuitHumanInterface: HEVSuitMedicalAid {

    lazy private var physicalSuit: HEVSuit = HEVSuit()

    func administerMorphine() -> String {
        return physicalSuit.administerMorphine()
    }
}
/*:
### 用法
*/
let humanInterface = HEVSuitHumanInterface()
humanInterface.administerMorphine()
