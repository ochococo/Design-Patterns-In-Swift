/*:
 迭代器（Iterator）
 ---------------
 迭代器模式可以让用户通过特定的接口巡访容器中的每一个元素而不用了解底层的实现。
 ### 示例：
 */
struct Novella {
    let name: String
}

struct Novellas {
    let novellas: [Novella]
}

struct NovellasIterator: IteratorProtocol {
    
    private var current = 0
    private let novellas: [Novella]
    
    init(novellas: [Novella]) {
        self.novellas = novellas
    }
    
    mutating func next() -> Novella? {
        defer { current += 1 }
        return novellas.count > current ? novellas[current] : nil
    }
}

extension Novellas: Sequence {
    func makeIterator() -> NovellasIterator {
        return NovellasIterator(novellas: novellas)
    }
}
/*:
 ### 用法：
 */
let greatNovellas = Novellas(novellas: [Novella(name:"红楼梦")])
for novella in greatNovellas {
    print("我读了\(novella.name)")
}
