//: Playground - noun: a place where people can play

import UIKit

// 变长参数
func arithmeticMean(_ numbers: Double...) -> Double {
    var total: Double = 0
    for number in numbers {
        total += number
    }
    return total / Double(numbers.count)
}

arithmeticMean(1, 2, 5.5, 3.0)

func swapInts(_ a: inout Int, _ b: inout Int) {
    let tmp = a
    a = b
    b = tmp
}
var a = 10, b = 20
swapInts(&a, &b)
print(a, b)

// 泛型
func swap<U>(_ a: inout U, _ b: inout U) {
    let t = a
    a = b
    b = t
}
swap(&a, &b)

// 函数类型作为参数类型 (Int, Int) -> Int
// 定义某个类型的函数，加减乘除 出入对于的函数指针和参数，输出结果
func printMathResult(_ function: (Int, Int) -> Int, _ a: Int, _ b: Int) {
    print("Result: \(function(a, b))")
}
func addTwoInts(_ a: Int, _ b: Int) -> Int {
    return a + b
}
printMathResult(addTwoInts, 10, 20)


// You can use a function type as the return type of another function.
// You do this by writing a complete function type immediately after
// the return arrow (->) of the returning funciton.
// stepForward 、stepBackward函数类型是(Int) -> Int
func chooseStepFunction(_ forward: Bool) -> (Int) -> Int {
    func stepForward(_ input: Int) -> Int {
        return input + 1
    }
    func stepBackward(_ input: Int) -> Int {
        return input - 1
    }
    return forward ? stepForward : stepBackward
}
var currentValue = 3
// 返回的是一个函数指针
chooseStepFunction(currentValue > 0)
chooseStepFunction(false)(currentValue)


// Closures are self-contained blocks of functionality that can be 
// passed around and used in your code.
// 类似于C、Objective-C中的blocks或其他语言Java中的lambdas表达式
// Closures内存管理3中情况
// 1、全局函数是有名字的闭包不捕获任何值
// 2、嵌套函数是有名字的闭包从进入的函数中捕获值
// 3、闭包表达式是没有名字的闭包从上下文中捕获值
var names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
func backward(_ s1: String, _ s2: String) -> Bool {
    return s1 > s2
}
var reversedNames = names.sorted(by: backward)


class SomeClass {
    var x = 10
    func doSomething() {
        functionWithEscapingClosure {
            self.x = 100
        }
        print(x)
        functionWithNonescapingClosure {
            x = 200
        }
        print(x)
    }
    
    // @escaping 逃逸闭包 self的生命周期和闭包的生命周期是交叉的
    // 异步执行，需要显示指定self，非逃逸闭包默认隐式指定了self
    func functionWithEscapingClosure(completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    func functionWithNonescapingClosure(completionHandler: () -> Void) {
        completionHandler()
    }
}
SomeClass().doSomething()

// @autoclosure 把一句表达式自动地封装成一个闭包
func logIfTrue(predicate: () -> Bool) {
    if predicate() {
        print("true")
    }
}
logIfTrue{ 2 > 1 }

func logIfFalse(predicate: @autoclosure () -> Bool) {
    if !predicate() {
        print("false")
    }
}
logIfFalse(predicate: 2 < 1)
















