/*:
 🔂 Monostate
 ------------

 The monostate pattern is another way to achieve singularity. It works through a completely different mechanism, it enforces the behavior of singularity without imposing structural constraints. 
 So in that case, monostate saves the state as static instead of the entire instance as a singleton.
 [SINGLETON and MONOSTATE - Robert C. Martin](http://staff.cs.utu.fi/~jounsmed/doos_06/material/SingletonAndMonostate.pdf)

### Example:
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
### Usage:
*/

import SwiftUI

// When change the theme
let settings = Settings() // Starts using theme .old
settings.currentTheme = .new // Change theme to .new

// On screen 1
let screenColor: Color = Settings().currentTheme == .old ? .gray : .white

// On screen 2
let screenTitle: String = Settings().currentTheme == .old ? "Itunes Connect" : "App Store Connect"
