//: Playground - noun: a place where people can play

import UIKit

// 定义一个变量str，类型String
var str = "Hello, playground"

str = "我是"

// 定义一个变量，不初始化，需要类型标注
var welcomeMsg : String
welcomeMsg = "变量可以多次赋值"

/**
 *  let 常量
 */
let constMsg : String
constMsg = "常量赋值后不能改变"



let i : Int
i = 10
print(i)

var f = 0.80
f = Double(i) //强转
print(f)



// 字面量
var tx = 15
// 017在C语言中是八进制，而swift会忽略前面任意多的0
tx = 017
tx = 0000_00054
tx = 1313_5674_942

tx = 0xff
tx = 0b0110_0011
tx = 0o17


var x = 3.14
x = 3.14E-2



