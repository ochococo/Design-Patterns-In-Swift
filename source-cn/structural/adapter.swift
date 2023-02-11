/*:
🔌 适配器（Adapter）
--------------

适配器模式有时候也称包装样式或者包装(wrapper)。将一个类的接口转接成用户所期待的。一个适配使得因接口不兼容而不能在一起工作的类工作在一起，做法是将类自己的接口包裹在一个已存在的类中。

### 示例：
*/
protocol NewDeathStarSuperLaserAiming {
    var angleV: Double { get }
    var angleH: Double { get }
}
/*:
**被适配者**
*/
struct OldDeathStarSuperLaserTarget {
    let angleHorizontal: Float
    let angleVertical: Float

    init(angleHorizontal: Float, angleVertical: Float) {
        self.angleHorizontal = angleHorizontal
        self.angleVertical = angleVertical
    }
}
/*:
**适配器**
*/
struct NewDeathStarSuperLaserTarget: NewDeathStarSuperLaserAiming {

    private let target: OldDeathStarSuperLaserTarget

    var angleV: Double {
        return Double(target.angleVertical)
    }

    var angleH: Double {
        return Double(target.angleHorizontal)
    }

    init(_ target: OldDeathStarSuperLaserTarget) {
        self.target = target
    }
}
/*:
### 用法
*/
let target = OldDeathStarSuperLaserTarget(angleHorizontal: 14.0, angleVertical: 12.0)
let newFormat = NewDeathStarSuperLaserTarget(target)

newFormat.angleH
newFormat.angleV
