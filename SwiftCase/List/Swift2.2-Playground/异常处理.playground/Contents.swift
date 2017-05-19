//: Playground - noun: a place where people can play

import UIKit


// 异常处理
// 响应错误并处理错误，swift提供了这种新的错误的一套完整支持，包括运行时错误的 抛出 传送 捕获，符合ErrorType协议的表示，异步会使用枚举表示错误，异常处理步骤：1、定义异常     2、在错误的地方抛出异常    3、捕获异常 do{try}catch{}


enum MachineError : ErrorProtocol {
    case InvalidInput //输入异常
    case OutOfStock //库存不足
    case NoEnoughFunds(required : Double) //余额不足
}

struct Item {
    var price : Double
    var count : Int
}

var inventory = [
    "可口可乐" : Item(price: 3.5, count: 0),
    "饼干" : Item(price: 6.9, count: 10),
    "农夫山泉" : Item(price: 2.5, count: 15)
]

var leftAmount = 4.3 //余额
func buy(name: String) throws{
    guard var item = inventory[name] else {
        // 保证inventory[name]能取出相应的商品，否则抛出异常
        throw MachineError.InvalidInput
    }
    guard item.count > 0 else {
        throw MachineError.OutOfStock
    }
    if leftAmount >= item.price {
        // 购买商品
        leftAmount -= item.price
        item.count -= 1
    }else {
        // 抛出余额不足异常
        throw MachineError.NoEnoughFunds(required: (item.price - leftAmount))
    }
}


do {
    try buy(name: "农夫山泉")
//    try buy(name: "可口可乐")
    try buy(name: "饼干")
    print("购买成功")
} catch MachineError.InvalidInput {
    print("无效输入")
} catch MachineError.OutOfStock {
    print("库存不足")
} catch MachineError.NoEnoughFunds(let require) {
    print("余额不足，还差￥\(require)")
}
















