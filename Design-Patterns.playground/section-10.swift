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