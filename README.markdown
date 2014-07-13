Design Patterns implemented in Swift
====================================
A short cheatsheet.


# Creational
> In software engineering, creational design patterns are design patterns that deal with object creation mechanisms, trying to create objects in a manner suitable to the situation. The basic form of object creation could result in design problems or added complexity to the design. Creational design patterns solve this problem by somehow controlling this object creation.
**Source:** http://en.wikipedia.org/wiki/Creational_pattern

## Singleton
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
