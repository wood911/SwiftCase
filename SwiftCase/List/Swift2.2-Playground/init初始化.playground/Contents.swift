//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


/**
 *  初始化器 init
    和OC中init方法相同，都是初始化属性
    OC中init需要我们手动调用
    swift初始化方法会根据参数自动调用 C++/Java构造方法
 */

struct MyStruct {
    var x : Double = 0.0
    var y : Int
    // 所有属性都有默认值时，会默认提供一个无参构造器和带参构造器
    // 如果自定义了初始化方法，编译器不会提供默认初始化方法
    init(x : Double) {
        self.x = x
        self.y = 0
    }
    init() {
        self.y = 1
    }
}

var mystruct = MyStruct(x: 10.0)

var mystruct2 = MyStruct()



struct Color {
    let red, green, blue : Double
    init(red:Double, green:Double, blue:Double) {
        self.red = red
        self.green = green
        self.blue = blue
    }
    init(_ red:Double, _ green:Double, _ blue:Double) {
        self.init(red: red, green: green, blue: blue)
    }
    func show() -> Void {
        print("red:\(red) green:\(green) blue:\(blue)")
    }
}

var c1 = Color(red: 1.0, green: 2.0, blue: 3)
c1.show()
var c2 = Color(10, 20, 30)
c2.show()




/**
 *  类类型初始化器
    类类型不提供逐一初始化器，只默认提供一个无参初始化器
    如果我们自定义了初始化器，编译器不再提供默认的初始化器
 */
class MyClass {
    // 类中的属性必须初始化
    var text : String
    init(s : String = "") {
        self.text = s
    }
    
}

var class1 = MyClass()
var class2 = MyClass(s: "aho")


class Food {
    var name : String
    var count : Int = 0
    private init(name : String) {
        self.name = name
    }
    convenience init() {
        self.init(name : "为什么不和struct一致，让我直接调用，还得贴个标签convenience")
    }
    convenience init(count : Int) {
        self.init()
        self.count = count
    }
    func show() -> Void {
        print("name:\(name),count:\(count)")
    }
}

var food1 = Food()
food1.show()
var food2 = Food(name: "私有带参初始化器")
food2.show()



class Apple : Food {
    var quantity : Int
    init(name : String, quantity : Int) {
        // 先初始化子类属性
        self.quantity = 10
        // 再调用父类初始化器
        super.init(name: name)
        // 如果对父类属性重新赋值，必须卸载父类初始化方法调用之后
        self.name = "haohao" //self.name找不到，找到父类的name
        super.name = "hehe"
    }
    override convenience init(name: String) {
        self.init(name: name, quantity: 100)
    }
    deinit {
        print("\(self)对象销毁了")
    }
}

var apple : Apple? = Apple(name: "百步穿杨", quantity: 99)
apple.debugDescription
apple?.quantity
apple?.count
apple?.name
apple = nil



