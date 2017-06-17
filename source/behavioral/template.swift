/*:
🍪 Template
-----------

The Template Pattern is used when two or more implementations of an
algorithm exist. The template is defined and then built upon with further
variations. Use this method when most (or all) subclasses need to implement
the same behavior. Traditionally, this would be accomplished with abstract
classes and protected methods (as in Java). However in Swift, because
abstract classes don't exist (yet - maybe someday),  we need to accomplish
the behavior using interface delegation.


### Example
*/

protocol ICodeGenerator {
    func crossCompile()
}

protocol IGeneratorPhases {
    func collectSource()
    func crossCompile()
}

class CodeGenerator : ICodeGenerator{
    var delegate: IGeneratorPhases

    init(delegate: IGeneratorPhases) {
        self.delegate = delegate
    }

    private func fetchDataforGeneration(){
        //common implementation
        print("fetchDataforGeneration invoked")
    }

    //Template method
    final func crossCompile() {
        fetchDataforGeneration()
        delegate.collectSource()
        delegate.crossCompile()
    }
    
}

class HTMLGeneratorPhases : IGeneratorPhases {
    func collectSource() {
        print("HTMLGeneratorPhases collectSource() executed")
    }

    func crossCompile() {
        print("HTMLGeneratorPhases crossCompile() executed")
    }
}

class JSONGeneratorPhases : IGeneratorPhases {
    func collectSource() {
        print("JSONGeneratorPhases collectSource() executed")
    }

    func crossCompile() {
        print("JSONGeneratorPhases crossCompile() executed")
    }
}



/*:
### Usage
*/

let htmlGen : ICodeGenerator = CodeGenerator(delegate: HTMLGeneratorPhases())
let jsonGen: ICodeGenerator = CodeGenerator(delegate: JSONGeneratorPhases())

htmlGen.crossCompile()
jsonGen.crossCompile()
