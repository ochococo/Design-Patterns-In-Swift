/*:
🎁 Façade
---------

The facade pattern is used to define a simplified interface to a more complex subsystem.

### Example
*/
class Eternal {

    class func setObject(value: AnyObject!, forKey defaultName: String!) {
        let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(value, forKey:defaultName)
        defaults.synchronize()
    }

    class func objectForKey(defaultName: String!) -> AnyObject! {
        let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()

        return defaults.objectForKey(defaultName)
    }

}
/*:
### Usage
*/
Eternal.setObject("Disconnect me. I’d rather be nothing", forKey:"Bishop")
Eternal.objectForKey("Bishop")
