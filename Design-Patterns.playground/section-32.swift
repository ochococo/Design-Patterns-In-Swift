let factoryOne = NumberAbstractFactory.numberFactoryType(.NextStep)
let numberOne = factoryOne.numberFromString("1")
numberOne.stringValue()

let factoryTwo = NumberAbstractFactory.numberFactoryType(.Swift)
let numberTwo = factoryTwo.numberFromString("2")
numberTwo.stringValue()