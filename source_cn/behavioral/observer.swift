/*:
 观察者（Observer）
 ---------------
 一个目标对象管理所有相依于它的观察者对象，并且在它本身的状态改变时主动发出通知
 ### 示例：
 */
protocol PropertyObserver: class {
    func willChange(propertyName: String, newPropertyValue: Any?)
    func didChange(propertyName: String, oldPropertyValue: Any?)
}

final class TestChambers {
    
    weak var observer: PropertyObserver?
    
    private let testChamberNumberName = "testChamberNumber"
    
    var testChamberNumber: Int = 0 {
        willSet(newValue) {
            observer?.willChange(propertyName: testChamberNumberName, newPropertyValue: newValue)
        }
        didSet {
            observer?.didChange(propertyName: testChamberNumberName, oldPropertyValue: oldValue)
        }
    }
}

final class Observer: PropertyObserver {
    func willChange(propertyName: String, newPropertyValue: Any?) {
        if newPropertyValue as? Int == 1{
            print("Okay. Look. We both said a lot of things that you're going to regret.")
        }
    }
    func didChange(propertyName: String, oldPropertyValue: Any?) {
        if oldPropertyValue as? Int == 0 {
            print("Sorry about the mess. I've really let the place go since you killed me.")
        }
    }
}
/*:
 ### 用法：
 */
var observer = Observer()
var testChambers = TestChambers()
testChambers.observer = observer
testChambers.testChamberNumber += 1
/*:
 > 更多示例：[Design Patterns in Swift](https://github.com/kingreza/Swift-Observer)
 */
