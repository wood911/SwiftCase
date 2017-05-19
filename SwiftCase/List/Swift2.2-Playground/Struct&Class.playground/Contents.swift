
import UIKit


// 结构体属性,如果没有初始化编译器会提供一个逐一初始化器，在init方法中都有对应的参数，如果所有属性都初始化了，结构体提供一个无参初始化器和一个逐一初始化器
struct Resolution {
    var width : Float
    var height : Float
}

var r = Resolution(width: 1024, height: 768)


struct Resolution2 {
    var width : Float = 0.0
    var height : Float = 0.0
}

var r2 = Resolution2(width: 1024, height: 768)
var r3 = Resolution2()
r.height



/**
 *  类中属性必须初始化，可选类型属性除外
 */
class Video: AnyObject {
    var name : String?
    var frameRate : Float = 24.0
    var resolution : Resolution = Resolution(width: 1024, height: 768)
    func videoInfo() {
        print("name:\(name),frameRate:\(frameRate),resolution:\(resolution.width)*\(resolution.height)")
    }
}

var v1 = Video()
v1.name
v1.videoInfo()

var v2 = Video()

// 比较地址(全等于) ===
if v1 === v1 {
    print("两个对象地址相同，是同一个对象")
}
if v1 !== v2 {
    print("两个对象地址不等")
}




