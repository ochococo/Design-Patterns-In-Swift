/*:
 🔂 Monostate
 ------------

 The monostate pattern is a alternativa to singleton, so in that case monostate still
 the state as static instead of all object as singleton. You can use a protocol to apply
 dependency inversion helping you on unit tests.

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

//On Screen 1
let screenColor: Color = Settings().theme == .old ? .gray : .white

//On Screen 2
let screenTitle: String = Settings().theme == .old ? "Itunes Connect" : "App Store Connect"
