/*:
🌿 Composite
-------------

The composite pattern is used to create hierarchical, recursive tree structures of related objects where any element of the structure may be accessed and utilised in a standard manner.

### Example

Component
*/
protocol Shape {
    func draw(fillColor: String)
}
/*:
Leafs
*/
final class Square: Shape {
    func draw(fillColor: String) {
        print("Drawing a Square with color \(fillColor)")
    }
}

final class Circle: Shape {
    func draw(fillColor: String) {
        print("Drawing a circle with color \(fillColor)")
    }
}

/*:
Composite
*/
final class Whiteboard: Shape {

    private lazy var shapes = [Shape]()

    init(_ shapes: Shape...) {
        self.shapes = shapes
    }

    func draw(fillColor: String) {
        for shape in self.shapes {
            shape.draw(fillColor: fillColor)
        }
    }
}
/*:
### Usage:
*/
var whiteboard = Whiteboard(Circle(), Square())
whiteboard.draw(fillColor: "Red")
