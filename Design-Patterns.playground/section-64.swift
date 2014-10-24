class StepCounter {
    var totalSteps: Int = 0 {
        
        willSet(newTotalSteps) {
            println("About to set totalSteps to \(newTotalSteps)")
        }

        didSet {

            if totalSteps > oldValue  {
                println("Added \(totalSteps - oldValue) steps")
            }
        }
    }
}