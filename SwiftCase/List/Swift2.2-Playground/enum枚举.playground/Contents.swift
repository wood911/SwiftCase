
import UIKit

enum Compass {
    case East
    case West
    case South
    case North
    // 枚举中可定义方法
    func show() {
        print(self)
    }
}


var p = Compass.East
p .show()



// 简写
enum Compass2 {
    case East, West, South, North
    func show() {
        print(self)
    }
}

var p2 : Compass2 = .South

switch p2 {
case .East :
    print("东")
case .West :
    print("西")
case .South :
    print("南")
case .North :
    print("北")
}


// 原始值 (裸值)
enum Week : Int{
    case Sun, Mon, Tue, Wen, Thu, Fri, Sat
}
var weekDay : Int = Week.Fri.rawValue // 5
weekDay = Week.Sat.rawValue

// 使用一个整形值构建一个枚举对象，构建可能失败，用可选值
var week : Week? = Week(rawValue:2)
week = Week(rawValue:10)




