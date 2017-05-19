
import UIKit

Int.max
Int.min

Int8.max
Int8.min

MemoryLayout<Int>.size

UInt.max
UInt.min


var f1 : Float
var f2 : Float32
// 把Double取别名Float64
// public typealias Float64 = Double
var f3 : Float64

typealias MyFloat = Float32
var f4 : MyFloat
f4 = 312.99


// public typealias Void = ()
MemoryLayout<Void>.size


// 字符类型
MemoryLayout<Character>.size

// Bool 只能是true、false，不像C语言中非0即真
MemoryLayout<Bool>.size

var bool : Bool
bool = true
if bool {
    print("if bool {...")
}



/**
 *  String 字符串  所有变量使用前必须初始化
 */
var str1 = "变量使用前必须初始化"
print("str1=\(str1)")
NSLog("str1=%@", str1)

var str2 = String()
str2 = String("声明一个字符串并初始化")

let str3 = String("这是常量")



/**
 *  字符 Character
    字符使用双引号，不能使用单引号
    swift中字符使用Unicode编码，支持中文等
 */
var ch = "A"
var ch2 : Character
ch2 = "a"

var ch3 : Character = "剪"
ch3 = "👌"
ch3 = "🍁"


var 🇨🇳 = "中国"
var 🐶 = "🐶"
🐶 += "日了🐶"


// 通过字符数组创建字符串
var catCharacters : [Character] = ["C", "a", "t", "!"]
var catString = String(catCharacters)


// 转义字符
let motto = "\"只有那些足够了解现实，也足够坚持梦想的人，才能把现实和梦想完美地结合在一起。\""


/**
 *  字符串拼接
 */
var str5 = "字符串"
var str6 : String = "拼接"
var str7 = String("在一起")
var strText = str5 + str6 + str7! + "!!"
var width = 15, height = 20
strText += String(width) + "\(height)"

var apples = 3
var oranges = 7
// 我有x个苹果和x个橘子
strText = "我有\(apples)个苹果和\(oranges)个橘子"

var hour = 9, min = 43, sec = 5
var timeStr = "\(hour)点\(min)分\(sec)秒"
timeStr = String(format: "%02d:%02d:%02d", hour, min, sec)
timeStr = String(format: "%02d:%02d:%02d", arguments: [hour,min,sec])





