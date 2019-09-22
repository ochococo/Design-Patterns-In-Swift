/*:
 生成器（Builder）
 --------------
 一种对象构建模式。它可以将复杂对象的建造过程抽象出来（抽象类别），使这个抽象过程的不同实现方法可以构造出不同表现（属性）的对象。
 ### 示例：
 */
class DeathStarBuilder {
    
    var x: Double?
    var y: Double?
    var z: Double?
    
    typealias BuilderClosure = (DeathStarBuilder) -> ()
    
    init(buildClosure: BuilderClosure) {
        buildClosure(self)
    }
}

struct DeathStar: CustomStringConvertible {
    
    let x: Double
    let y: Double
    let z: Double
    
    init?(builder: DeathStarBuilder) {
        
        if let x = builder.x, let y = builder.y, let z = builder.z {
            self.x = x
            self.y = y
            self.z = z
        } else {
            return nil
        }
    }
    
    var description: String {
        return "Death Star at (x:\(x) y:\(y) z:\(z))"
    }
}
/*:
 ### 用法：
 */
let empire = DeathStarBuilder { builder in
    builder.x = 0.1
    builder.y = 0.2
    builder.z = 0.3
}

let deathStar = DeathStar(builder: empire)
/*:
 > 更多示例：[Design Patterns in Swift](https://github.com/kingreza/Swift-Builder)
 */
