##🏭 Factory Method

The factory pattern is used to replace class constructors, abstracting the process of object generation so that the type of the object instantiated can be determined at run-time.

**Example:**

```swift
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

class UnitedStatesDolar : Currency {
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
                return UnitedStatesDolar()
            default:
                return nil
        }
        
    }
}
```
**Usage:**
```swift
let noCurrencyCode = "No Currency Code Available"

CurrencyFactory.currencyForCountry(.Spain)?.code() ?? noCurrencyCode
CurrencyFactory.currencyForCountry(.UnitedStates)?.code() ?? noCurrencyCode
CurrencyFactory.currencyForCountry(.France)?.code() ?? noCurrencyCode
CurrencyFactory.currencyForCountry(.UK)?.code() ?? noCurrencyCode

```
