let DEFAULT_POINT_BASE = 2.0
let DEFAULT_POINT_POLARIZATION = false

class NotSoSimplePointConverter
{
    func pointFrom(#x:Double,y:Double,z:Double,base:Double,negative:Bool) -> Point
    {
        var point = Point{
            $0.x = (x*base) * (negative ? -1.0 : 1.0)
            $0.y = (y*base) * (negative ? -1.0 : 1.0)
            $0.z = (z*base) * (negative ? -1.0 : 1.0)
        }
        
        return point
    }
}

class OhSoSimplePointConverter{
    
    func standarizedXYZFrom(#x:Double,y:Double,z:Double) -> (x:Double!,y:Double!,z:Double!){
        
        let notSimple = NotSoSimplePointConverter()
        
        var pointCalculated = notSimple.pointFrom(x:x,y:y,z:z,base:DEFAULT_POINT_BASE,negative:!DEFAULT_POINT_POLARIZATION)

        return (pointCalculated.x,pointCalculated.y,pointCalculated.z)
    }
    
}