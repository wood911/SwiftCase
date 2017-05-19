
import UIKit
/**
 *  继承，swift是单继承，只能有一个父类或者不继承任何类
 */
class Vehicle {
    // 存储属性
    var curSpeed = 0.0
    // 计算属性
    var desc : String {
        return "当前速度是\(curSpeed)"
    }
    func makeNoise() {
        print("发出什么声音")
    }
    func show() {
        print(desc)
    }
}

class Bicycle: Vehicle {
    // 扩展属性
    var hasBasket = false
    var gear = 1
    func test() {
        print("子类扩展的方法")
    }
    // 重写 override
    override func makeNoise() {
        print("哐当哐当匡卡UN管卡UN个")
    }
    override func show() {
        super.show()
        print("我是自行车")
    }
    // 重写父类存储属性
    override var curSpeed: Double {
        willSet {
            print("即将变速，new:\(newValue)km/h,now:\(curSpeed)km/h，档位:\(gear)")
        }
        didSet {
            print("当前速度:\(curSpeed)")
            gear = Int(curSpeed/10)+1
        }
    }
    // 重写计算属性
    override var desc: String {
        return "当前速度:\(curSpeed)km/h，档位:\(gear)"
    }
}

var bike = Bicycle()
bike.curSpeed = 30
bike.makeNoise()
bike.show()



/**
 *  final 不可变对象
    final修饰的属性、方法不能重写，修饰的类不能被继承
 */
class Base {
    final var desc = "final修饰的变量不能改变"
    final func show() {
        print("final修饰的方法不能被重写,desc:\(desc)")
    }
}

class Child: Base {
    
}

var child = Child()
child.show()



