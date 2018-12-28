/*:
💍 Singleton
------------

The singleton pattern ensures that only one object of a particular class is ever created.
All further references to objects of the singleton class refer to the same underlying instance.
There are very few applications, do not overuse this pattern!

### Example:
*/
class DeathStarSuperlaser {
    static let sharedInstance = DeathStarSuperlaser()

    private init() {
        // Private initialization to ensure just one instance is created.
    }
}
/*:
### Usage:
*/
let laser = DeathStarSuperlaser.sharedInstance
/*:
 >**Further Examples:**
 > <br /> [swift-design-patterns](https://github.com/jVirus/swift-design-patterns/blob/master/Common%20Design%20Patterns/Creational/Singleton/Sinpleton.md)
 */
