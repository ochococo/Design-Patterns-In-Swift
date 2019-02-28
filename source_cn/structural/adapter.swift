/*:
 适配器（Adapter）
 --------------
 
 适配器模式有时候也称包装样式或者包装(wrapper)。将一个类的接口转接成用户所期待的。一个适配使得因接口不兼容而不能在一起工作的类工作在一起，做法是将类自己的接口包裹在一个已存在的类中。
 ### 示例：
 */
protocol OlderDeathStarSuperLaserAiming {
    var angleV: NSNumber { get }
    var angleH: NSNumber { get }
}
/*:
 **被适配者**
 */
struct DeathStarSuperlaserTarget {
    let angleHorizontal: Double
    let angleVertical: Double
    
    init(angleHorizontal: Double, angleVertical: Double) {
        self.angleHorizontal = angleHorizontal
        self.angleVertical = angleVertical
    }
}
/*:
 **适配器**
 */
struct OldDeathStarSuperlaserTarget: OlderDeathStarSuperLaserAiming {
    private let target: DeathStarSuperlaserTarget
    
    var angleV: NSNumber {
        return NSNumber(value: target.angleVertical)
    }
    
    var angleH: NSNumber {
        return NSNumber(value: target.angleHorizontal)
    }
    
    init(_ target: DeathStarSuperlaserTarget) {
        self.target = target
    }
}
/*:
 ### 用法：
 */
let target = DeathStarSuperlaserTarget(angleHorizontal: 14.0, angleVertical: 12.0)
let oldFormat = OldDeathStarSuperlaserTarget(target)

oldFormat.angleH
oldFormat.angleV
/*:
 更多示例：[Design Patterns in Swift](https://github.com/kingreza/Swift-Adapter)
 */
