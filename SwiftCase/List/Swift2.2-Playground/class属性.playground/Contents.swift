
import UIKit
/**
 *  结构体
    存储属性：用变量或常量来存储属性值
 */
struct MyRange {
    var location : Int
    let length : Int
}
var range = MyRange(location: 10, length: 30)
range.location = 50


/**
 *  计算属性
 */
struct Point {
    var x = 0.0, y = 0.0
}
struct Size {
    var w = 0.0, h = 0.0
}

struct Rect {
    // 存储属性
    var origin = Point()
    var size = Size()
    // 中心点 计算属性
    var center : Point {
        // 获取中心点
        get {
            let x = origin.x + size.w * 0.5
            let y = self.origin.y + self.size.h * 0.5
            return Point(x: x, y: y)
        }
        // 设置中心点
        set {
            // newValue内置参数->set (point){}，point.x
            //self.center.x 会调用getter，改变原点，则间接改变中心点
            let x = newValue.x - size.w * 0.5
            let y = newValue.y - size.h * 0.5
            origin = Point(x: x, y: y)
        }
    }
    // 如果只有getter方法且只有一行代码(readonly)，则get可以省略
    var center2 : Point {
        return Point(x: origin.x + size.w * 0.5, y: self.origin.y + self.size.h * 0.5)
    }
}

var rect = Rect(origin: Point(x: 20, y: 30), size: Size(w: 100, h: 80))
print("rect:\(rect)")
print("center:\(rect.center)")
rect.center = Point(x: 50, y: 50)
print("rect:\(rect) center:\(rect.center) center2:\(rect.center2)")



/**
 *  延迟属性，OC中的懒加载
 */
class Data {
    init() {
        print("Data 初始化，创建对象")
    }
    var file = "data.txt"
}
class DataManager {
    lazy var data = Data()
    var count : Int = 0
}

var dataMgr = DataManager()
dataMgr.count
dataMgr.data.file


/**
 *  属性监视器 KVO 在属性发生变化时调用
    1、计算属性 延迟属性 不能设置属性监视器 存储属性可以
    2、在属性初始化时不调用
    3、两种：willSet、didSet
    4、一个属性可以有多个属性监视器
 */
class StepCounter {
    var text = "内容"
    // 存储属性
    var count : Int = 10
    // 计算属性
    var allSteps : Int {
        return count + 10
    }
    // 设置属性监视器
    var total : Int = 1 {
        willSet(newValue) {
            print("属性即将变成\(newValue)，现在是\(total)")
        }
        didSet {
            print("属性值已经改变，原来是\(oldValue)现在是\(total)")
        }
    }
}

var step = StepCounter()
step.total = 10



/**
 *  类型属性 & 实例属性
    类型属性：在结构体或枚举中static修饰的属性和类中static修饰或class修饰，实现资源共享
    实例属性：
 */
enum Week : Int {
    static var today = 0
    case Mon, Tue, Wen, Thu, Fri, Sat, Sun
}
var week = Week(rawValue: 3)
week?.rawValue

struct Some {
    init () {
        Some.x += 1
    }
    // 存储属性
    var a = 10 {
        willSet {
            print("KVO-willSet,self:\(self),newValue:\(newValue),now:\(a)")
        }
        didSet {
            print("KVO-didSet,self:\(self),oldValue:\(oldValue),now:\(a)")
        }
    }
    // 计算属性
    var b : Int {
        return a + 1
    }
    // 类型属性，属于类的，只有一份，不能通过对象访问
    static var x = 0
    static var y : Int {
        return 10
    }
}

var s1 = Some()
var s2 = Some()
s1.a = 20
Some.x
Some.y


class Clazz {
    init () {
        Clazz.x += 1
    }
    // 存储属性
    var a = 10 {
        willSet {
            print("KVO-willSet,self:\(self),newValue:\(newValue),now:\(a)")
        }
        didSet {
            print("KVO-didSet,self:\(self),oldValue:\(oldValue),now:\(a)")
        }
    }
    // 计算属性
    var b : Int {
        return a + 1
    }
    // 类型属性，属于类的，只有一份，不能通过对象访问
    static var x = 0
    static var y : Int {
        return 10
    }
//    class var xx = 0,class不能修饰存储属性，可以修饰计算属性
    class var yy : Int {
        return 10
    }
}
var c1 = Clazz()
var c2 = Clazz()
c1.a += 1
Clazz.yy
Clazz.x



/**
 *  类方法 & 实例方法
 */
class Counter {
    var count = 0
    static var count2 = 1
    class var count3 : Int {
        return (count2+1)
    }
    // 实例方法
    func increment() {
        count += 1
        Counter.count2 += 2
        print("count:\(count),count2:\(Counter.count2),count3:\(Counter.count3)")
    }
    func increment(amount: Int) {
        count += amount
    }
}

var cou = Counter()

cou.increment()


// 值类型实例方法
struct Pointer {
    var x = 10, y = 20
    static var z = 30
    func instanceMethod() -> Void {
        print("x:\(x) y:\(y) z:\(Pointer.z)")
        Pointer.z = 50
        Pointer.instanceMethod(self)
        print(Pointer.z)
        // 类方法早于实例方法初始化，实例方法中实例属性不能修改，需加上mutating
//        x = 20
    }
    mutating func instanceMethod2() -> Void {
        x = 20
        print(x)
    }
    // 结构体中定义类方法
    static func classMethod() {
        print("结构体中定义静态方法")
    }
}
var pp = Pointer()
pp.instanceMethod()
pp.instanceMethod2()
Pointer.classMethod()


// 类方法
class Clazz2 {
    var prop : Int  = 0
    static var a : Int = 1
    static var b : Int {
        return a + 1
    }
    class var c : Int {
        return a + b + 1
    }
    static func classMethod() {
        print("类方法中不能到有实例属性和方法，因为先初始化类，再创建对象才有了成员变量和方法")
        print("a:\(a),b:\(b),c:\(c)")
    }
}

Clazz2.classMethod()








