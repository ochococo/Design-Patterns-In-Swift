let planets: [Planet] = [PlanetEarth(), PlanetMars(), PlanetGliese581C()]

let names = planets.map { (planet: Planet) -> String in
	let visitor = NameVisitor()
	planet.accept(visitor)
	return visitor.name
}

names