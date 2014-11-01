##🃏 Prototype

```swift
class ThieveryCorporationPersonDisplay {
    var name: String?
    let font: String

    init(font: String) {
        self.font = font
    }

    func clone() -> ThieveryCorporationPersonDisplay {
        return ThieveryCorporationPersonDisplay(font:self.font)
    }
}
```
**Usage:**
```swift
let Prototype = ThieveryCorporationPersonDisplay(font:"Ubuntu")

let Philippe = Prototype.clone()
Philippe.name = "Philippe"

let Christoph = Prototype.clone()
Christoph.name = "Christoph"

let Eduardo = Prototype.clone()
Eduardo.name = "Eduardo"
```
