
import UIKit

/**
 *  冒泡排序：相邻的两个数比较并交换
 */
func maopaoSort( data : inout [Int]) {
    for i in 0 ..< data.count {
        for j in 0 ..< data.count-i-1 {
            if data[j] > data[j+1] {
                swap(&data[j], &data[j+1])
            }
        }
    }
}
func maopaoSort( data : inout [Int], rule : (Int, Int) -> Bool) {
    for i in 0 ..< data.count {
        for j in 0 ..< data.count-i-1 {
            if rule(data[j], data[j+1]) {
                swap(&data[j], &data[j+1])
            }
        }
    }
}

var array = [9, 5, 2, 7, 3]
maopaoSort(data: &array)
maopaoSort(data: &array) { (x : Int, y : Int) -> Bool in
    return x > y
}


/**
 *  闭包缩写，只要编译器可以推导出来类型，就可以简写
 */
// 简写1：参数类型省略
maopaoSort(data: &array) { (x, y) -> Bool in
    return x < y
}

// 简写2：返回值类型省略
maopaoSort(data: &array) { (x, y) in
    return x < y
}

// 简写3：当只有一条语句时，省略return
maopaoSort(data: &array) { (x, y) in
    x < y
}

// 简写4：省略参数、参数类型、返回值类型，提供内置参数 $0,$1...$9
maopaoSort(data: &array) {
    $0 < $1
}

// 简写5：全部省略
maopaoSort(data: &array, rule: <)



/**
 *  闭包练习
    一个函数
    参数1：x : Int
    参数2：函数类型 func1 : () -> Int
    参数3：s : String
    参数4：函数类型 func2 : Void -> Void
    if (x > 10) {
        func1()
    }else {
        func2()
    }
 */
func test(x:Int, func1:()->Int, s:String, func2:(Void)->Void) {
    if x > 10 {
        func1()
    }else {
        func2()
    }
}

test(x: 20, func1: { () -> Int in
    print("$0>10，调用第二个函数类型的参数func1:()->Int")
    return 0
    }, s: "Hello", func2: { () in
        print("$0<=10，调用第4个函数类型参数func2:Void->Void")
})



array = [3, 6, 1, 2, 9, 0]
var arr1 = array.sorted(by: >)
arr1



/**
 闭包(closure)：在函数内部定义了其他函数时，闭包有权访问包含函数内部的所有变量
 1、闭包的作用域链包含着它自己的作用域、包含函数的作用域和全局作用域
 2、当函数返回了一个闭包时，这个函数的作用域将会一直在内存中保存到闭包不存在为止
 sort排序其实是匿名函数，不是真正的闭包，但swift称之为闭包
 松本行弘给的定义：将局部变量这一环境封闭起来的结构，叫做闭包
 */
func count() -> (() -> Int) {
    let i = 0
    return {
        () -> Int in
        return i + 1
    }
}

// 创建函数对象，i不会销毁，除非闭包销毁，每次调用时都会++i使i的值+1
var c1 = count()
c1()
c1()
c1()

var c2 = count()
c2()
c2()


/**
 *  objc @selector()，swift：let someMethod = Selector(“someMethodName”)
 */
func callMe() {
    print("this is callMe")
}
func callMeWithParam(timer: Timer) {
    print("this is callMeWithParam,param is :\(timer.userInfo as! String)")
}
//NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "callMe", userInfo: nil, repeats: true)
//NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "callMeWithParam:", userInfo: "i'm prarm", repeats: true)

class Person {
    func hello(name : String) -> Void {
        print("hello \(name)")
    }
    class func desc() {
        print("类方法")
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



// 函数柯里化 Currying
//func addTwoNumbers(a: Int, num: Int) -> Int {
//    return a + num
//}
//let addToFour = addTwoNumbers(4)    // addToFour 是一个 Int -> Int
//let result = addToFour(num: 6)      // result = 10


/**
 *  封装局部变量 零添加无污染 懒加载 readonly
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
    static private let _instance = Singleton()
    // 提供对外访问接口
    class var sharedInstance: Singleton {
        return _instance
    }
}

Singleton.sharedInstance === Singleton.sharedInstance // true






