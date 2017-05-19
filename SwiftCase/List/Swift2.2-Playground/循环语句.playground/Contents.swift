//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


// 一行中出现多条语句 使用;隔开
var x = 10
var y = 20; var z = 30
for i in 0 ..< x {
    print("没有这个i=\(i)，照样循环")
}

for _ in 0 ..< x {
    print("只关心循环，不需用到变量i，_ 忽略变量 i")
}


var str2 = "abcd"
for ch in str2.characters {
    print("ch=\(ch)")
}


while x < y {
    print("x=\(x),y=\(y)")
    x += 1
}


/**
 *  do while -> repeat while
 */
var i = 0
repeat {
    print("i = \(i)")
    i += 1
} while i < 10



/**
 *  终止和继续循环 break continue
 */
for i in 0 ..< 10 {
    if i == 4 {
        continue
    }
    if i == 7 {
        break
    }
    print("i = \(i)")
}


outerLoop: for i in 0 ..< 5 {
    for j in 0 ..< 5 {
        print("i=\(i),j=\(j)")
        if i == 2 && j == 3 {
            
            break outerLoop
        }
    }
}




















