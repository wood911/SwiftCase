//: Playground - noun: a place where people can play

import UIKit


// protocol 协议

protocol FullName {
    // 定义要实现的方法，swift接口必须实现
    func show()
    
    // 可以把计算属性升级为存储属性
    var fullName : String {get}
}

// OC协议，默认实现，可选实现
@objc protocol ObjectProtocol {
    func requiredMethod()
    @objc optional func optionalMethod()
}



class Person : FullName, ObjectProtocol {
    func hello(name : String) -> Void {
        print("hello \(name)")
    }
    class func desc() {
        print("类方法")
    }
    func show() {
        print("遵守协议，实现方法")
    }
    var fullName: String = "升级计算属性为存储属性"
    func requiredMethod() {
        print("OC中必须实现的方法")
    }
    func optionalMethod() {
        print("OC中可选实现的方法")
    }
}
extension Person {
    func haohao() -> Void {
        print("extension haohao()")
    }
}
let p = Person()
// 常规调用
p.haohao()
p.hello(name: "wutf")
Person.desc()
// 传入执行对象 js中的this执行环境,表示执行Person()上的(参数)
Person.hello(Person())(name: "xiaowu")



protocol SomeProtocol {
    init(a : Int)
    func test() -> Int
}
class Parent {
    init(a : Int) {
        
    }
    func gg() {
        
    }
}
// 写一个类，继承Parent实现SomeProtocol
class Child : Parent, SomeProtocol {
    var num : Int
    func test() -> Int {
        return num
    }
    override required init(a : Int) {
        num = 10
        super.init(a: a)
    }
    override func gg() {
        print("num=\(num)")
    }
}




/**
 *  封装局部变量 减少变量之间的冲突
 */
var str : String = {
    let str1 = "hello", str2 = "world"
    return "\(str1) \(str2)"
}()




/**
 *  swift单例标准写法
 */
class Singleton {
    // 私有静态对象
    static private let sharedInstance = Singleton()
    // 提供对外访问接口
    class var sharedSingleton: Singleton {
        return sharedInstance
    }
}

Singleton.sharedInstance === Singleton.sharedSingleton




