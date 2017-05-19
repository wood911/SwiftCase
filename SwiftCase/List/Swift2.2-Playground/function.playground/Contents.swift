
import UIKit

/**
 *  func 函数名(参数:类型, 参数:类型) -> 返回值类型 {...}
 */
func add(x:Int, y:Int) -> Int {
    return x + y
}

add(x: 3, y: 2)

func say() -> Void {
    print("hehe, Hello")
}

// 没有返回值类型，可省略
func sayHello() {
    print("say hello")
}

func sayHello(name:String) {
    print("Hello, \(name)")
}

sayHello()
sayHello(name: "小伍") // 在Swift2中name是可以省略的
say
say()


func sayHello(name : String, age : Int) {
    sayHello(name: name)
    print("Hello,name:\(name) age:\(age)")
}

sayHello(name: "小伍", age: 20)



typealias SumType = (me : Int, you : Int, other : Int)
func statistic(msg : String) -> SumType {
    var result : SumType = (0, 0, 0)
    for ch in msg.characters {
        switch ch {
        case "我":
            result.me += 1
        case "你":
            result.you += 1
        default:
            result.other += 1
        }
    }
    return result
}

var msg = "你可知道我想你念你怨你爱你深情永不变"
let rs : SumType = statistic(msg: msg)
print("我：\(rs.me) 你：\(rs.you) 其他：\(rs.other)")



/**
 inout表示指针
 
 - parameter x: 指针类型
 - parameter y: 指针类型
 */
func swap( x : inout Int, y : inout Int) -> Void {
    let temp = x
    x = y
    y = temp
}

var x = 10, y = 20
swap(x: &x, y: &y)
x
y




/**
 *  函数参数
 */
func fa(i : Int) -> Void {
    print("i=\(i)")
}

// outerName是外部名 只能在函数外部使用的名字
func fa(outerName i : Int) -> Void {
    print("i=\(i)")
}

// fa(10) Swift2.0 ✔️  不过Swift更规范，认了吧
fa(outerName: 20)

// 自定义外部名
func printInfo(Name name : String, Age age : Int) -> Void {
    print("name:\(name),age:\(age)")
}
printInfo(Name: "小伍", Age: 20)

// Swift2 第一个参数默认是内部名，函数从第二个参数开始，既是外部名又是内部名
//func printInfo(name : String, age : Int) -> Void {
//    print("name:\(name),age:\(age)")
//}



func printArray(array : [Int], split : String, flag : Bool) {
    var str = ""
    for i in 0 ..< array.count {
        str += String(array[i]) + (i == array.count-1 ? "" : split)
    }
    if flag {
        str.insert("[", at: str.startIndex)
        str.append("]")
    }
}
var array = [9, 5, 2, 7]
printArray(array: array, split: ",", flag: true)



/**
 *  函数重载 终于还是忍不住抄袭了Java
    方法名相同，参数列表（个数、类型） 构成函数重载
    OC没有重载，可以重写
 */
func sub(x : Int, y : Int) -> Int {
    return x - y
}
func sub(x : Int, z : Int) -> Int {
    return x - y
}
sub(x: 10, y: 30)
sub(x: 10, z: 30)



/**
 *  函数类型
    定义一个变量(理解为指向一个函数首地址的指针变量)psay，
    这个变量类型为 () -> Void ，()表示参数列表，Void表示返回值
    将say函数首地址赋给这个变量psay，则psay是指向say()函数的指针
 */
var psay : () -> Void = say
psay()

// func sub(x : Int, _ y : Int) -> Int {,两个参数的外部名都忽略了
var psub1 : (_ x : Int, _ y : Int) -> Int = add
psub1(3, 4)

var padd1 : (Int, Int) -> Int = add
padd1(1, 2)
var padd3 = add
add(x: 1, y: 2) // 注意：写法不一样哦
padd3(1, 2)
var padd4 : (_ a : Int, Int) -> Int = add
padd4(1, 2) // 到这里，我简直不想活了


// 函数作为参数
func getResult(fun:(Int, Int)->Int, a:Int, b:Int) -> Int {
    return fun(a, b)
}

getResult(fun: padd1, a: 10, b: 12)

// 函数类型的返回值,test函数需要返回(Int, Int) -> Int类型的函数
func test() -> (Int, Int) -> Int{
    return add
}
test()(10, 12)



/**
 *  闭包 温习一下
    Java/C++ Lamda
    javascript 匿名函数
    OC/Ruby Block
 swift
 {(参数列表) -> 返回值类型 in 逻辑代码}
 */

var closure : (Int, Int) -> Int
func getSum(x : Int, _ y : Int) -> Int {
    return x + y
}
closure = getSum
closure(2, 3)

closure = {(x : Int, y : Int) -> Int in
    return x + y
}
closure(2, 3);

_ = {(x:Int, y:Int) -> Int in
    return x + y
}(2, 3)


// 加法
var addResult = getResult(fun: { (x : Int, y : Int) -> Int in
    return x + y
    }, a: 10, b: 12)
print("addResult:\(addResult)")
// 减法
var subResult = getResult(fun: { (x : Int, y : Int) -> Int in
    return x - y
    }, a: 10, b: 12)
print("subResult:\(subResult)")





