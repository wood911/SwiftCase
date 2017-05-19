
import UIKit

var arr : Array<Int> = [1, 2, 3, 4, 5]

var arr2 : Array<String> = ["1", String(2), "3", "4"]


// 定义数组的形式  要让编译器知道数组里面的类型
var array1 = Array<Int>(arrayLiteral: 1, 2)
var array2 : Array<Int> = Array<Int>()
var array3 : Array = Array<Int>()
var array4 : Array<Int> = Array()
var array5 : Array = [Int]()
var array6 : [Int] = Array()
var array7 : [Int] = [Int]()
var array8 = [1, "", Double(2), UIView()] as [Any] // 必须指定类型swift3
var array9 : [Int]// 没有开辟空间 array9.count会报错


var list = ["默罕", "释迦牟尼"] // ["默罕", "释迦牟尼"]

// 修改数据
list[0] = "默罕默德"
list    // ["默罕默德", "释迦牟尼"]

// 增加数据
list.append("耶稣")

// 两个数组相加 必须是同类型元素
list += ["如来", "观音", "hehe"]

list.insert("小伍", at: 1) // ["默罕默德", "小伍", "释迦牟尼", "耶稣", "如来", "观音", "hehe"]

// 移除数据
list.remove(at: 5) // "观音"  返回被移除的元素
list.removeFirst()
list.removeLast()
list        // ["小伍", "释迦牟尼", "耶稣", "如来"]
list.replaceSubrange(Range(0 ..< 2), with: ["1", "2"]) // ["1", "2", "耶稣", "如来"]
//list.removeAll()


// 查询
var subList = list[1 ... 3] // ["2", "耶稣", "如来"]

for item in subList {
    print(item)
}

for item in list {
    print(item)
}

print("-----------")
for var i in 0 ..< list.count {
    print(list[i])
}







