
import UIKit

/**
 *  Swift中所有的结构体都是值类型，所有的类都是引用类型
 */

// public struct String
// String 是结构体，值类型
var str1 : String = "hello"
var str2 = str1
str1 = "world"
print("str1=\(str1),str2=\(str2)")
// print指针打印不能写在一起
print(Unmanaged.toOpaque(Unmanaged.passUnretained(str1 as AnyObject)))
print(Unmanaged.toOpaque(Unmanaged.passUnretained(str2 as AnyObject)))

var refStr1 : NSMutableString = "hello"
var refStr2 = refStr1
NSLog("%p,%p", refStr1, refStr2)
refStr1.append(" world")
print("\(refStr1),\(refStr2)")




// public class NSString
var refStr3 : NSString = "引用类型"





