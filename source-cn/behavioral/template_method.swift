/*:
📝 模板方法模式
-----------

 模板方法模式是一种行为设计模式， 它通过父类/协议中定义了一个算法的框架， 允许子类/具体实现对象在不修改结构的情况下重写算法的特定步骤。

### 示例：
*/
protocol Garden {
    func prepareSoil()
    func plantSeeds()
    func waterPlants()
    func prepareGarden()
}

extension Garden {

    func prepareGarden() {
        prepareSoil()
        plantSeeds()
        waterPlants()
    }
}

final class RoseGarden: Garden {

    func prepare() {
        prepareGarden()
    }

    func prepareSoil() {
        print ("prepare soil for rose garden")
    }

    func plantSeeds() {
        print ("plant seeds for rose garden")
    }

    func waterPlants() {
       print ("water the rose garden")
    }
}

/*:
### 用法
*/

let roseGarden = RoseGarden()
roseGarden.prepare()
