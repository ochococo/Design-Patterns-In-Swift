
let tower = Tower()

let plane1 = Plane(flightNumber: "123")
let plane2 = Plane(flightNumber: "451")
let plane3 = Plane(flightNumber: "610")
let plane4 = Plane(flightNumber: "999")

plane1.registerToTower(tower)
plane2.registerToTower(tower)
plane3.registerToTower(tower)
plane4.registerToTower(tower)

plane1.requestPermissionToStart()
plane2.requestPermissionToLand()
plane4.requestPermissionToStart()
plane3.requestPermissionToLand()
