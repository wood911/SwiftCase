//: Playground - noun: a place where people can play

import UIKit

// 注意：自动解包可选类型一定要保证不是nil

/**
 *  可选值 默认自动初始化为nil，只有可选值类型的变量、常量可以赋值nil
    Int? 可选值类型的简化形式
 */

var x : Int?
x = nil

// 非简化形式
var o : Optional<Int>
o = nil


var num = "123"
// 因为转换可能失败，失败返回nil，所以返回可选类型Int?
var convertNum = Int(num)
print(convertNum)

//convertNum = convertNum ?? 0
if convertNum == nil {
    print("不能解包")
}else {
    print("可以解包")
    // 加上类型标注 ！增强可读性
    var testValue = convertNum! + 10
}


// 把可选值赋给另一个变量，则另一个变量也为可选值
var otherNum = convertNum
print("\(otherNum)也是可选值")

otherNum = 99

//otherNum + 1
// 可选绑定 会自动解包 不是nil就进if
if var bind = otherNum {
    print(bind)
}else {
    print("绑定失败")
}



/**
 *  Type? 需要强制解包的可选类型或需要可选绑定解包
    可以自动解包的可选类型 Type!
 */
var optional_a : Int! = 10 // 可自动解包的可选类型，前提是已知a!=nil
var optional_b : Int? = 10 // 需强制解包的可选类型，不知b是否为nil
// 变量必须是非空的，否则解包不成功导致报错

print("optional_a=\(optional_a + 1)")



/**
 *  使用故事版拖拽组件 在使用时 一定是非空的 
    所以产生的类型是可自动解包的可选类型
    使用代理时，使用非自动解包的可选类型比较合适，代理不能为空
 */
// 可选链 如果name=nil也不会报错
var name : String?
print(name?.lowercased())













