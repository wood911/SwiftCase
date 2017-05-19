//: Playground - noun: a place where people can play

import UIKit

class Person {
    var name : String
    init(name: String) {
        self.name = name
        print("创建对象 \(self.name)")
    }
    deinit {
        print("\(self.name) 对象销毁了")
    }
}

var p1, p2, p3 : Person?

p1 = Person(name: "刘备")
p2 = Person(name: "关羽")
p3 = Person(name: "张飞")

p3 = p2
p2 = nil
p3 = Person(name: "小伍")


class A {
    weak var b : B? = B()
    deinit {
        print("\(self)销毁了")
    }
    init() {
        print("创建\(self)")
    }
}
class B {
    weak var a : A?
    deinit {
        print("\(self)销毁了")
    }
    init() {
        print("创建\(self)")
    }
}

var a : A? = A()
//var b : B? = B()
//a?.b
//b?.a






