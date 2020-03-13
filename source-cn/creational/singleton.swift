/*:
💍 单例（Singleton）
--------------

单例对象的类必须保证只有一个实例存在。许多时候整个系统只需要拥有一个的全局对象，这样有利于我们协调系统整体的行为

### 示例：
*/
final class ElonMusk {

    static let shared = ElonMusk()

    private init() {
        // Private initialization to ensure just one instance is created.
    }
}
/*:
### 用法
*/
let elon = ElonMusk.shared // There is only one Elon Musk folks.
