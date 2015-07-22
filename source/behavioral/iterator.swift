/*:
🍫 Iterator
-----------

The iterator pattern is used to provide a standard interface for traversing a collection of items in an aggregate object without the need to understand its underlying structure.

### Example:
*/
struct NovellasCollection<T> {
    let novellas: [T]
}

extension NovellasCollection: SequenceType {
    typealias Generator = AnyGenerator<T>
    
    func generate() -> AnyGenerator<T> {
        var i = 0
        return anyGenerator{ return i >= self.novellas.count ? nil : self.novellas[i++] }
    }
}
/*:
### Usage
*/
let greatNovellas = NovellasCollection(novellas:["Mist"])

for novella in greatNovellas {
    print("I've read: \(novella)")
}
