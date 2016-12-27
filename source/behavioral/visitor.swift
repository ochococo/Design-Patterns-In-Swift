/*:
🏃 Visitor
----------

The visitor pattern is used to separate a relatively complex set of structured data classes from the functionality that may be performed upon the data that they hold.

### Example
*/
protocol PlanetVisitor {
	func visit(planet: PlanetAlderaan)
	func visit(planet: PlanetCoruscant)
	func visit(planet: PlanetTatooine)
    func visit(planet: PlanetJedah)
}

protocol Planet {
	func accept(visitor: PlanetVisitor)
}

class PlanetJedah: Planet {
    func accept(visitor: PlanetVisitor) { visitor.visit(planet: self) }
}

class PlanetAlderaan: Planet {
    func accept(visitor: PlanetVisitor) { visitor.visit(planet: self) }
}

class PlanetCoruscant: Planet {
	func accept(visitor: PlanetVisitor) { visitor.visit(planet: self) }
}

class PlanetTatooine: Planet {
	func accept(visitor: PlanetVisitor) { visitor.visit(planet: self) }
}



class NameVisitor: PlanetVisitor {
	var name = ""

	func visit(planet: PlanetAlderaan)  { name = "Alderaan" }
	func visit(planet: PlanetCoruscant) { name = "Coruscant" }
	func visit(planet: PlanetTatooine)  { name = "Tatooine" }
    func visit(planet: PlanetJedah)     { name = "Jedah" }
}

/*:
### Usage
*/
let planets: [Planet] = [PlanetAlderaan(), PlanetCoruscant(), PlanetTatooine(), PlanetJedah()]

let names = planets.map { (planet: Planet) -> String in
	let visitor = NameVisitor()
    planet.accept(visitor: visitor)
	return visitor.name
}

names
/*:
>**Further Examples:** [Design Patterns in Swift](https://github.com/kingreza/Swift-Visitor)
*/
