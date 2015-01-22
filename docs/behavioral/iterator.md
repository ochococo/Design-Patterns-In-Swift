##🍫 Iterator

The iterator pattern is used to provide a standard interface for traversing a collection of items in an aggregate object without the need to understand its underlying structure.

**Example:**

```swift
struct NovellasCollection<T> {
    let novellas: [T]
}

extension NovellasCollection: SequenceType {
    typealias Generator = GeneratorOf<T>
    
    func generate() -> GeneratorOf<T> {
        var i = 0
        return GeneratorOf { return i >= self.novellas.count ? nil : self.novellas[i++] }
    }
}
```

***Usage***
```swift
let greatNovellas = NovellasCollection(novellas:["Mist"])

for novella in greatNovellas {
    println("I've read: \(novella)")
}
```
