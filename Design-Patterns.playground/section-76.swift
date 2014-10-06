protocol PlanetVisitor {
	func visit(planet: PlanetEarth)
	func visit(planet: PlanetMars)
	func visit(planet: PlanetGliese581C)
}

protocol Planet {
	func accept(visitor: PlanetVisitor)
}

class PlanetEarth: Planet {
	func accept(visitor: PlanetVisitor) { visitor.visit(self) }
}
class PlanetMars: Planet {
	func accept(visitor: PlanetVisitor) { visitor.visit(self) }
}
class PlanetGliese581C: Planet {
	func accept(visitor: PlanetVisitor) { visitor.visit(self) }
}

class NameVisitor: PlanetVisitor {
	var name = ""

	func visit(planet: PlanetEarth)      { name = "Earth" }
	func visit(planet: PlanetMars)       { name = "Mars" }
	func visit(planet: PlanetGliese581C) { name = "Gliese 581 C" }
}