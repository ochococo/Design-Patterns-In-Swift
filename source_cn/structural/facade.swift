/*:
 外观（Facade）
 -----------
 外观模式为子系统中的一组接口提供一个统一的高层接口，使得子系统更容易使用。
 ### 示例：
 */
enum Eternal {
    
    static func set(_ object: Any, forKey defaultName: String) {
        let defaults: UserDefaults = UserDefaults.standard
        defaults.set(object, forKey: defaultName)
        defaults.synchronize()
    }
    
    static func object(forKey key: String) -> AnyObject! {
        let defaults: UserDefaults = UserDefaults.standard
        return defaults.object(forKey: key) as AnyObject
    }
}
/*:
 ### 用法：
 */
Eternal.set("Disconnect me. I’d rather be nothing", forKey:"Bishop")
Eternal.object(forKey: "Bishop")
