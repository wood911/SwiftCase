//: Playground - noun: a place where people can play

import UIKit

/*
 * 本节主要内容
 * 1.基本函数的声明和调用
 * 2.函数和可选型的结合
 * 3.函数和元组的结合
 * 4.函数的参数命名: 外部参数名和内部参数名
 * 4.1 目的: 既可以保证函数调用的语义明确, 又可以保证函数内部调用的语义明确
 * 5.参数是否应该忽略: 只要在调用的时候, 没有歧义, 是可以忽略的; 否则不应该忽略.
 */

// 声明函数没有返回值
func sayHello(name: String) {
    print("Hello, \(name)")
}
func sayHello2(name: String) -> () {}
func sayHello3(name: String) -> Void {}
sayHello(name: "小伍")


func sayHello(_ name: String) {
    print("Hello, \(name)")
}
func sayHello2(_ name: String) -> String {
    return "Hello, " + name
}
sayHello("xiaowu")
_ = sayHello2("xiaowu")

func sayHello4(name: String?) -> String {
    return "Hello, " + (name ?? "Guest")
}
sayHello4(name: nil)


// 声明函数返回数组[String]
func getNames() -> [String] {
    return ["xiaowu", "小伍"]
}

func findUnlimitedValue(number: [Int]) -> (min: Int, max: Int) {
    var minValue = number[0], maxValue = number[0]
    for number in number {
        minValue = min(number, minValue)
        maxValue = max(number, maxValue)
    }
    return (minValue, maxValue)
}
let number: [Int] = [12, 21, 9, 2, 33, 89, 50]
// let result: (min: Int, max: Int) = findUnlimitedValue(number: number)
let result = findUnlimitedValue(number: number)
result.min
result.max

func findUnlimitedValueOptional(number: [Int]) -> (min: Int, max: Int)? {
    if number.isEmpty {
        return nil
    }
    var minValue = number[0], maxValue = number[0]
    for number in number {
        minValue = min(minValue, number)
        maxValue = max(maxValue, number)
    }
    return (minValue, maxValue)
}
let result2 = findUnlimitedValueOptional(number: [])

func multiply(_ number1: Int, _ number2: Int) -> Int {
    return number1 * number2
}
multiply(2, 9)








/*
 * 本节主要内容:
 * 1.可变长参数(Variadic Parameter): 函数的声明的时候, 不清楚传参数的个数
 * 2.将函数参数的值类型改成引用类型, 修改传入的参数的值;
 * 符号 ...
 */
func sayHelloTo(date: String, names: String..., greeting: String) {
    for name in names {
        print("\(greeting) to \(name) --\(date)")
    }
}
sayHelloTo(date: "2016-12-08", names: "张三", "xiaowu", "小伍", greeting: "Hello")

// 原生API方法 交换值
var firstNumber = 100, secondNumber = 200
swap(&firstNumber, &secondNumber)
firstNumber
secondNumber

// 自定义函数 交换值
func swapValue(num1: inout Int, num2: inout Int) {
    num1 ^= num2
    num2 ^= num1
    num1 ^= num2
}
swapValue(num1: &firstNumber, num2: &secondNumber)
firstNumber
secondNumber

// 获取多个参数的平均值
func numberAvarage(_ numbers: Double...) -> Double {
    var sum = 0.0
    for number in numbers {
        sum += number
    }
    return sum / Double(numbers.count)
}
numberAvarage(12.2, 33, 43.09, 54.89)

// 将整数转换为二进制数，除2取余 倒序
func convertToBinaray(_ num: inout Int) -> String {
    var str = ""
    repeat {
        str += String(num % 2) + str
        num /= 2
    } while num != 0
    return str
}
var decimalNumber = 5
let binarayNumber = convertToBinaray(&decimalNumber)


// 排序
func compareFunc(first: Int, second: Int) -> Bool {
    return abs(first) < abs(second)
}
var numberArray: [Int] = []
for i in 0..<10 {
    var tmp: Int = Int(arc4random_uniform(50))
    tmp = i % 2 == 0 ? tmp : -1 * tmp
    numberArray.append(tmp)
}
numberArray.sort(by: compareFunc)
numberArray.sort { (a, b) -> Bool in
    return a < b
}






/*
 * 本节主要内容:
 * 1.枚举类型的声明和使用
 * 2.raw data(元数据); 和函数的结合
 * 3.associated data(关联数据)
 * C语言的不同:
 * 1.枚举类型首字母要求大写
 * 2.没有逗号
 * 3.case关键词描述可能性
 */
enum Week {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    func description() -> String {
        switch self {
        case .monday:
            return "星期一"
        case .tuesday:
            return "星期二"
        case .wednesday:
            return "星期三"
        case .thursday:
            return "星期四"
        case .friday:
            return "星期五"
        case .saturday:
            return "星期六"
        case .sunday:
            return "星期日"
        }
    }
}
let currday = Week.friday
currday.description()

enum WeekInt: Int {
    case monday = 10
    case tuesday = 20
    case wednesday = 100
    case thursday
    case friday
    case saturday
    case sunday
}
let currdayWeek = WeekInt(rawValue: 102)
currdayWeek?.rawValue

enum httpError: String {
    case code404 = "Not Found"
    case code401 = "Unauthorized"
    case code403 = "Forbidden"
    case code400 = "Bad Request"
}
let errorMsg = httpError.code404
errorMsg.rawValue

enum ATMStatus {
    case Success, Failure, Waiting
}
var balance = 10000.0
func withdrawMoney(amount: Double) -> ATMStatus {
    if amount >= 0 && amount <= balance {
        balance -= 1
        return ATMStatus.Success
    } else {
        return ATMStatus.Failure
    }
}
withdrawMoney(amount: balance)







