##👓 Observer

The observer pattern is used to allow an object to publish changes to its state. 
Other objects subscribe to be immediately notified of any changes.

**Example:**

```swift
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
```
**Usage:**
```swift
let stepCounter = StepCounter()
stepCounter.totalSteps = 200
// About to set totalSteps to 200
// Added 200 steps
stepCounter.totalSteps = 360
// About to set totalSteps to 360
// Added 160 steps
stepCounter.totalSteps = 896
// About to set totalSteps to 896
// Added 536 steps
```
