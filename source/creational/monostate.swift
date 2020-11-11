/*:
 🔂 Monostate
 ------------

 The monostate pattern is an alternative to singleton, so in that case, monostate saves the state as static instead of the entire instance as a singleton. You can use a protocol to apply dependency inversion helping you on unit tests.

### Example:
*/
struct Settings {

    enum Theme {
        case .old
        case .new
    }

    private static var theme: Theme

    var currentTheme: Theme {
        get { Settings.theme }
        set(newTheme) { Settings.theme = newTheme }
    }
}
/*:
### Usage:
*/

// When change the theme
let settings = Settings() // Starts using theme .old
settings.theme = .new // Change theme to .new

//On screen 1
let screenColor: Color = Settings().theme == .old ? .gray : .white

//On screen 2
let screenTitle: String = Settings().theme == .old ? "Itunes Connect" : "App Store Connect"
