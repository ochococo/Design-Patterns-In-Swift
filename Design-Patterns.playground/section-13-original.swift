class Number
{
    var number:AnyObject

    init(number:AnyObject){
        self.number = number
    }

    convenience init(integer:Int){
        self.init(number:integer)
    }

    convenience init(double:Double){
        self.init(number:double)
    }

    func integerValue() -> Int{
        return self.number as Int
    }

    func doubleValue() -> Double{
        return self.number as Double
    }
}
