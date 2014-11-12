##🍫 Iterator

The iterator pattern is used to provide a standard interface for traversing a collection of items in an aggregate object without the need to understand its underlying structure.

**Example:**

```swift
struct Cart<T> {
    let items: [T]
}

extension Cart: SequenceType {
    typealias Generator = GeneratorOf<T>
    
    func generate() -> GeneratorOf<T> {
        var i = 0
        return GeneratorOf { return i >= self.items.count ? nil : self.items[i++] }
    }
}
```

***Usage***
```swift
let cart = Cart(items: ["foo", "bar", "baz"])

for item in cart {
    println(item)
}
```
