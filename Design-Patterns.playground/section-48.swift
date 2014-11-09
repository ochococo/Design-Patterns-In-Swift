class ThieveryCorporationPersonDisplay {
    var name: String?
    let font: String

    init(font: String) {
        self.font = font
    }

    func clone() -> ThieveryCorporationPersonDisplay {
        return ThieveryCorporationPersonDisplay(font:self.font)
    }
}