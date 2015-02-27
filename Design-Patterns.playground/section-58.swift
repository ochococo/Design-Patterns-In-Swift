protocol OlderDeathStarSuperLaserAiming {
    var angleV: NSNumber {get}
    var angleH: NSNumber {get}
}

// Adaptee

struct DeathStarSuperlaserTarget {
    let angleHorizontal: Double
    let angleVertical: Double

    init(angleHorizontal:Double, angleVertical:Double) {
        self.angleHorizontal = angleHorizontal
        self.angleVertical = angleVertical
    }
}

// Adapter

struct OldDeathStarSuperlaserTarget : OlderDeathStarSuperLaserAiming {
    private let target : DeathStarSuperlaserTarget

    var angleV:NSNumber {
        return NSNumber(double: target.angleVertical)
    }

    var angleH:NSNumber {
        return NSNumber(double: target.angleHorizontal)
    }

    init(_ target:DeathStarSuperlaserTarget) {
        self.target = target
    }
}