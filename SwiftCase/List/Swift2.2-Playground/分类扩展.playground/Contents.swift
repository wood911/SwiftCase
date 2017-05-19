//: Playground - noun: a place where people can play

import UIKit


// swift可以对类或结构体扩展
// 不能在扩展中出现存储属性，但可以有计算属性
extension Double {
    // 扩展一个方法，实现四舍五入
    func round() -> Int {
        return Int(self + 0.5)
    }
    // 扩展计算属性
    var km : Double {
        return self / 1000
    }
}
var meter : Double = 23400.8
meter.round()
meter.km


// 对UIButton扩展
extension UIButton {
    func show() -> Void {
        print("tag:\(self.tag)")
    }
}
var button = UIButton()
button.tag = 123
button.show()



public class MyClass {
    internal var a = 10
    private var b = 12
    public var c = 14
}

var myClass = MyClass()
myClass.a
//myClass.b
myClass.c




// 强制转换
var a = 123
var str1 = "\(a)"
str1 = String(a)
// 媒体类
class MediaItem {
    var name : String
    init(name : String) {
        self.name = name
    }
}
// 电影类
class Movie : MediaItem {
    var director : String
    init(name : String, director : String) {
        self.director = director
        super.init(name: name)
    }
}
// 歌曲类
class Song : MediaItem {
    var singer : String
    init(name : String, singer : String = "艾薇尔") {
        self.singer = singer // 先初始化自身的属性
        super.init(name: name) // 再初始化父类属性，偏偏反人类
    }
}

var library : [MediaItem] = [
    Song(name: "When your gone"),
    Song(name: "秋日私语", singer: "理查德•克莱德曼"),
    Song(name: "菊次郎的夏天", singer: "久石让"),
    Movie(name: "少年派奇幻漂流", director: "李安"),
    Movie(name: "功夫", director: "周星驰"),
    Movie(name: "千与千寻", director: "宫崎骏")
]
// 统计电影和歌曲的数量
// is 是什么类型  类型对象强制转换 as!
var movieCount = 0, songCount = 0
for item in library {
    if item is Song {
        songCount += 1
        let song = item as! Song
        print("电影名称《\(song.name)》 作曲家：\(song.singer)")
    }
    if item is Movie {
        movieCount += 1
        let movie = item as! Movie
        print("歌曲名称《\(movie.name)》 导演：\(movie.director)")
    }
}


// as! 转出来的是 非可选值，必须保证转换之前是非空的
// as? 转出来的是 可选值，可能成功可能失败，失败返回nil
var array1 = NSArray(objects: "a", "b", "c")
var array2 : [String] = array1 as! [String]
var array3 : [String]? = array1 as? [String]

// Any 任意类型 swift和OC中的所有类型
var array4 : Any = array1 as? [String]
// AnyObject OC中的id 没有可选类型
var array5 : AnyObject? = array1 as? [String] as AnyObject



// 泛型  T会根据传入的值自动推导出类型
func swapValue<T> ( a : inout T, _ b : inout T) {
    let temp = a
    a = b
    b = temp
}
var aa = 10, bb = 20
swapValue(a: &aa, &bb)
print("aa=\(aa) bb=\(bb)")

var cc = "aa", dd = "dd"
swapValue(a: &cc, &dd)
cc
dd

// 类型泛型
var arrDouble : Array<Double>
var arrInt : Array<Int>
struct MyStack<T> {
    private var items = [T]()
    // 压栈
    mutating func push(item : T) {
        items.append(item)
    }
    mutating func pop() -> T {
        return items.removeLast()
    }
}

var stack : MyStack<Int> = MyStack()
stack.push(item: 1)
stack.pop()




