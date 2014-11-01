##🔌 Adapter

The adapter pattern is used to provide a link between two otherwise incompatible types by wrapping the "adaptee" with a class that supports the interface required by the client.

**Example:**

```swift
// WARNING: This example uses Point class from Builder pattern!

class PointConverter {

    class func convert(#point:Point, base:Double, negative:Bool) -> Point {

        var pointConverted = Point{
            if let x = point.x { $0.x = x * base * (negative ? -1.0 : 1.0) }
            if let y = point.y { $0.y = y * base * (negative ? -1.0 : 1.0) }
            if let z = point.z { $0.z = z * base * (negative ? -1.0 : 1.0) }
        }
        
        return pointConverted
    }
}

extension PointConverter{
    
    class func convert(#x:Double!, y:Double!, z:Double!, base:Double!, negative:Bool!) -> (x:Double!,y:Double!,z:Double!) {
        var point = Point{ $0.x = x; $0.y = y; $0.z = z }
        var pointCalculated = self.convert(point:point, base:base, negative:negative)

        return (pointCalculated.x!,pointCalculated.y!,pointCalculated.z!)
    }

}
```

**Usage:**
```swift
var tuple = PointConverter.convert(x:1.1, y:2.2, z:3.3, base:2.0, negative:true)

tuple.x
tuple.y
tuple.z
```
