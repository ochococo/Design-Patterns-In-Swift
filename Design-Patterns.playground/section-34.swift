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