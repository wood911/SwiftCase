//: Playground - noun: a place where people can play

import UIKit

/*
 * 本节主要内容:
 * 1.guard语句的使用
 * 2.闭包Closure的使用
 */

// 声明函数，使用guard语法来判断字符串可选类型是否为空
func guardString(_ string: String?) {
    guard let s = string else {
        print("string is nil")
        return
    }
    print("string is \(s)")
}

guardString(nil)

func buyByGuard(money: Int, price: Int, capacity: Int, volume: Int) {
    guard money >= price else {
        print("No enough money")
        return
    }
    guard capacity >= volume else {
        print("No enough capacity")
        return
    }
    print("You can buy it, price is \(price) and volume is \(volume)")
}

// 闭包Closure 匿名函数 {(parameters)->Void in statements}
var array = [1, 2, 3, 4]
func biggerNumber(first: Int, second: Int) -> Bool {
    return first > second
}
array.sort(by: biggerNumber)
array.sort { (first: Int, second: Int) -> Bool in
    return first < second
}
array.sort { (first, second) -> Bool in
    return first < second
}
array.sort { (first, second) in
    return first > second
}
array.sort { (first, second) in
    first > second
}
array.sort(by: {$0 > $1})
array.sort(by: >)


