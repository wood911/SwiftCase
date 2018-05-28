/**
 Swift重写了C、Objective-C中所有类型，Int、Float、Double、Bool、String
 同时还提供集合类型 Array、Set、Dictionary(Map)，高级类型Tuples元组
 1、let 、 var
 2、安全 Optional
 */

import UIKit

// 声明常亮
let one = 1
// 声明变量
var two = 2
two = 10

// 编译器能根据值识别变量类型
var x = 0.0, y = 0.0, z = 0.0, a = 1
var red, green, blue: CGFloat
red = 80.0 / 255.0
green = 140.0 / 255.0
blue = 150.0 / 255.0
UIColor(red: red, green: green, blue: blue, alpha: 1)

// 定义了变量msg，但未初始化，直接使用会crash
var msg: String
msg = "Hello"


let 你好 = "你好，World"
let 😆 = "哈哈😆"
print("Lily \(😆)")


let minValue = UInt8.min
let maxValue = UInt8.max

// On a 32-bit platform, Int is the same size as Int32
// On a 64-bit platform, Int is the same size as Int64
let intMax = Int.max >> 2

let decimal = 17
let binary = 0b10001  // 32 48 65 97
let octal = 0o21
let hexdecimal = 0x11

let paddleDoule = 000_123.456

Bool("")    // false
Bool(" ")   // false
Bool("1")   // false

Bool(1)     // true
Bool(-1)    // true
Bool(0)     // false


let http404Error = (404, "Not Found")
let (code, message) = http404Error
print(code, message)
print(http404Error.0, http404Error.1, separator: " ", terminator: "\n")

let http200Status = (code: 200, message: "Success")
print(http200Status.code, http200Status.message)

if let x = Int("200"), let y = Int("404"), x < y && y < 500 {
    print(x + y)
}

enum NumberFormatError: Error {
    case success(Int)
    case failure(String)
}

// Error Handling
func formatToInt(_ t: String) throws {
    if let i = Int(t) {
        print(i)
    } else {
        throw NumberFormatError.failure("转换失败 \(t)")
    }
}

do {
    try formatToInt("200-")
} catch {
    print(error)
}












