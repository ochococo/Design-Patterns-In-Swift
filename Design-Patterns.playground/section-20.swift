protocol Currency {
    func symbol() -> String
    func code() -> String
}

class Euro : Currency {
    func symbol() -> String {
        return "€"
    }
    
    func code() -> String {
        return "EUR"
    }
}

class UnitedStatedDolar : Currency {
    func symbol() -> String {
        return "$"
    }
    
    func code() -> String {
        return "USD"
    }
}

enum Country {
    case UnitedStates, Spain, France, UK
}

class CurrencyFactory {
    class func currencyForCountry(country:Country) -> Currency? {
        switch country {
        case .Spain, .France :
            return Euro()
        case .UnitedStates :
            return UnitedStatedDolar()
        default:
            return nil
        }
        
    }
}