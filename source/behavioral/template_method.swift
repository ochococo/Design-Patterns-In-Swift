/*:
📝 Template Method
-----------

 The template method patter defines the steps of an algorithm and allows the redefinition of one or more of these steps. In this way, the template method protects the algorithm, the order of execution and provides abstract methods that can be implemented by concrete types.

### Example
*/
protocol Garden {
    func prepareSoil()
    func plantSeeds()
    func waterPlants()
    func prepareGarden()
}

extension Garden {

    func prepareGarden() {
        func prepareSoil()
        func plantSeeds()
        func waterPlants()
    }
}

final class RoseGarden: Garden {

    func prepare() {
        prepareGarden()
    }
}

/*:
### Usage
*/

let roseGarden = RoseGarden()
roseGarden.prepare()
