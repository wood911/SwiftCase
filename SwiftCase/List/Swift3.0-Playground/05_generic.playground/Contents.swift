//: Playground - noun: a place where people can play

import UIKit

/*
 * 本节主要内容:
 * 1.泛型类型(枚举和结构体)
 */

var array: [Int] = []
var dict: [Int: String] = [:]

// 定义Result枚举，成功回调ValueType类型，失败回调ErrorType类型
enum Result<ValueType, ErrorType> {
    case success(ValueType)
    case failure(ErrorType)
}

// 求商函数：给定2个Int值 返回Result<Int, String>枚举类型（泛型）
func divide(first: Int, second: Int) -> Result<Int, String> {
    // 分母不能为0
    guard second != 0 else {
        return Result.failure("分母不能为0")
    }
    return Result.success(first / second)
}
divide(first: 10, second: 0)
divide(first: 20, second: 9)

/*
 * 1.需求: 声明一个结构体, 使用泛型语法, 描述数据结构中的"队列"
 * 2.要求: enqueue(入队), dequeue(出队), 队列是否为空;
 */
struct Queue<Element> {
    var elements = [Element]()
    // 入队 mutating让属性可以在实例方法中被修改
    // mutating解释: http://www.tuicool.com/articles/NRFzYf
    mutating func enqueue(newElement: Element) {
        elements.append(newElement)
    }
    // 出队
    mutating func dequeue() -> Element? {
        guard !elements.isEmpty else {
            return nil
        }
        return elements.remove(at: 0)
    }
    func isEmpty() -> Bool {
        return elements.isEmpty
    }
}




