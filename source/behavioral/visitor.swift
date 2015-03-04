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
}

protocol Planet {
	func accept(visitor: PlanetVisitor)
}

class PlanetAlderaan: Planet {
	func accept(visitor: PlanetVisitor) { visitor.visit(self) }
}
class PlanetCoruscant: Planet {
	func accept(visitor: PlanetVisitor) { visitor.visit(self) }
}
class PlanetTatooine: Planet {
	func accept(visitor: PlanetVisitor) { visitor.visit(self) }
}

class NameVisitor: PlanetVisitor {
	var name = ""

	func visit(planet: PlanetAlderaan)  { name = "Alderaan" }
	func visit(planet: PlanetCoruscant) { name = "Coruscant" }
	func visit(planet: PlanetTatooine)  { name = "Tatooine" }
}
/*:
### Usage
*/
let planets: [Planet] = [PlanetAlderaan(), PlanetCoruscant(), PlanetTatooine()]

let names = planets.map { (planet: Planet) -> String in
	let visitor = NameVisitor()
	planet.accept(visitor)
	return visitor.name
}

names
