##💍 Singleton
```swift
class SingletonClass {
    class var shared : SingletonClass {

        struct Static {
            static let instance : SingletonClass = SingletonClass()
        }

        return Static.instance
    }
}
```
**Usage:**
```swift
let instance = SingletonClass.shared

```
