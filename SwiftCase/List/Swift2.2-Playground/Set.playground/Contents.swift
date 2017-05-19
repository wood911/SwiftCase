
import UIKit

var letters : Set<Character> = Set()
letters.count
letters.insert("A")
letters.insert("B")
letters.insert("B")
letters.insert("C")
letters.count



var music : Set<String> = ["Rock", "Classical", "Jazz"]
music.count
music.isEmpty

music.insert("jazz")
music.insert("Bluth")

music.insert("雅皮")

music.remove("jazz")

if let removeMusic = music.remove("Rock") {
    print(removeMusic + "删除成功")
}else {
    print("没有此音乐")
}


music.contains("Jazz")


for m in music {
    print(m)
}

for m in music.sorted(by: { (a, b) -> Bool in
    return a < b
}) {
    print(m)
}



// 集合运算
var set1 : Set<Int> = [1, 3, 5] // 为什么用var而不用let
let set2 : Set<Int> = [2, 3, 5]
// 并集
set1.union(set2) // {5, 2, 3, 1}
// 交集
set1.intersection(set2) // {5, 3}
// 差集
set1.subtract(set2) // {1}
// 补集
set1.symmetricDifference(set2) // {5, 2, 3, 1}







