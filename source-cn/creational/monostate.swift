/*:
 🔂 单态（Monostate）
 ------------

  单态模式是实现单一共享的另一种方法。不同于单例模式，它通过完全不同的机制，在不限制构造方法的情况下实现单一共享特性。
  因此，在这种情况下，单态会将状态保存为静态，而不是将整个实例保存为单例。
 [单例和单态 - Robert C. Martin](http://staff.cs.utu.fi/~jounsmed/doos_06/material/SingletonAndMonostate.pdf)

### 示例:
*/
class Settings {

    enum Theme {
        case `default`
        case old
        case new
    }

    private static var theme: Theme?

    var currentTheme: Theme {
        get { Settings.theme ?? .default }
        set(newTheme) { Settings.theme = newTheme }
    }
}
/*:
### 用法:
*/
import SwiftUI

// 改变主题
let settings = Settings() // 开始使用主题 .old
settings.currentTheme = .new // 改变主题为 .new

// 界面一
let screenColor: Color = Settings().currentTheme == .old ? .gray : .white

// 界面二
let screenTitle: String = Settings().currentTheme == .old ? "Itunes Connect" : "App Store Connect"
