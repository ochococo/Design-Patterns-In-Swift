##🃏 Prototype

The prototype pattern is used to instantiate a new object by copying all of the properties of an existing object, creating an independent clone. 
This practise is particularly useful when the construction of a new object is inefficient.

**Example:**

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
