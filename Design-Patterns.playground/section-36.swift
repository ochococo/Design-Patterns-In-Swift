let planets: [Planet] = [PlanetAlderaan(), PlanetCoruscant(), PlanetTatooine()]

let names = planets.map { (planet: Planet) -> String in
	let visitor = NameVisitor()
	planet.accept(visitor)
	return visitor.name
}

names