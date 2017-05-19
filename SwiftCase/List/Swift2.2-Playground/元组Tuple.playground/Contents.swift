
import UIKit
/**
 *  元组(Tuple)
    将多个类型（可能相同、可能不同）组织到一起的一种数据类型->C语言中的结构体类型
 */

// (String, Int, Int)
("小伍", 24, 100)

// 声明并初始化元组
let http404Error : (Int, String) = (404, "Resources Not Found")

// 访问元组数据
http404Error.0 // 404
http404Error.1 // "Resources Not Found"


let http500Error : (code:Int, desc:String) = (500, "Server Internal Error")
http500Error.0      // 500
http500Error.1
http500Error.code   // 500
http500Error.desc



var stu : (name:String, age:Int, grade:Double) = ("小伍", 24, 1000.99)
print("name=\(stu.name),age=\(stu.age),grade=\(stu.grade)")



/**
 *  元组和switch
 */
var point = (11, 0)
switch point {
case (0, 0) : print("origin")
// 绑定值到变量x中
case (var x, 0) : print("x--\(x)")
// _忽略y的值
case (0, _) : print("y-----")
case (-20 ... 20, -20 ... 20) : print("in rect")
default : print("No...")
}



point = (10, -10)
switch point {
case (0, 0) :
    print("origin")
case var (x, y) where x == y :
    print("(\(x), \(y))")
case var (x, y) where x == -y :
    print("(\(x), \(y))")
default :
    print("No...")
}


















