//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

var refStr = NSString().stringByAppendingString(str)
var x = 100

assert(x == 100 && str == refStr, "x=100是正确的")

print("断言是成立的，程序继续运行")


func testAssert(x : Int) -> Void {
    assert(x != 0, "参数不能为0")
    print(1.0/Double(x))
}


testAssert(9)



