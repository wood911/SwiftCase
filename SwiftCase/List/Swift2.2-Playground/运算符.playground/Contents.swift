
import UIKit

var a, b, c, d, e, f : Int
a = 10
b = 20
// Swift所有运算符都是函数，赋值运算符函数返回值是void，而不像C++中那样返回函数结果
// c = d = e = 100

c = a + b
d = a - b
e = a * b
f = a / b

// 相同类型参与运算 Float64->Double
Double(a) / Double(b) + Float64(c)

// 取余 跟前面的有关
9 % 2
-9 % 2
-9 % -2

//      10     12    13    13   '++' is unavailable: it has been removed in Swift 3
//var x = a++ + ++a + ++a + a++
a

a > b
a < b
a == b
a != b



// Swift中只有可选类型才可以赋值nil，可选类型就是可以选择nil，可选类型会自动初始化为nil
var z : Int? // 可选类型会自动初始化为nil
z = nil
z = 1

var r = z != nil ? z : 0
// ?? 空合运算符 r = z != nil ? z : 0 简化版
var r2 = z ?? 0



// 区间运算符
a = 10
b = 20
a ... b
a ..< b

a > b && b < c

// 定义两个整数变量 赋值 然后输出最值
max(a, b)


/**
 *  1、if ()圆括号可以省略
    2、{} 不能省略
    3、非0即1 不再成立
 */
if a > b {
    print(a)
}else {
    print(b)
}




var score = 80
var ch : Character;

/**
 *  1、完备性问题 需要匹配所有可能性 一般带有default
 *  2、只要有default 则必须在最后
 *  3、没有隐式贯穿，即不加break，如需向下一个分支执行使用fallthrough
 *  4、case块中无论是否定义变量，都不需要{}
 */
switch score {
case 0 ..< 60 : ch = "D"
case 60 ..< 80 : ch = "C"
case 80 ..< 90 : ch = "B"
    fallthrough // fallthrough相当于一起的switch语句不写break
case 90 ... 100 : ch = "A"
default:ch = "?"
}
print("your grade:\(ch)") // your grade:A




