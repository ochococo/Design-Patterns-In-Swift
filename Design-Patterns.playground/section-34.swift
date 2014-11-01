protocol ThreeDimensions {
    var x: Double? {get}
    var y: Double? {get}
    var z: Double? {get}
}

class Point : ThreeDimensions {
    var x: Double?
    var y: Double?
    var z: Double?

    typealias PointBuilderClosure = (Point) -> ()

    init(buildClosure: PointBuilderClosure) {
        buildClosure(self)
    }
}
