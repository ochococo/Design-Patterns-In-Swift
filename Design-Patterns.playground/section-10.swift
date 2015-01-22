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