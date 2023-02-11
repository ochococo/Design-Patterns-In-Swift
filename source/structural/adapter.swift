/*:
🔌 Adapter
----------

The adapter pattern is used to provide a link between two otherwise incompatible types by wrapping the "adaptee" with a class that supports the interface required by the client.

### Example
*/
protocol NewDeathStarSuperLaserAiming {
    var angleV: Double { get }
    var angleH: Double { get }
}
/*:
**Adaptee**
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
**Adapter**
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
### Usage
*/
let target = OldDeathStarSuperLaserTarget(angleHorizontal: 14.0, angleVertical: 12.0)
let newFormat = NewDeathStarSuperLaserTarget(target)

newFormat.angleH
newFormat.angleV
