
import UIKit

// 定义字典
var dict1 : Dictionary<String, Int> = Dictionary()
var dict2 : Dictionary<String, String> = Dictionary<String, String>()
var dict3 : Dictionary = Dictionary<String, Int>()
var dict4 : Dictionary = [String : Int]()
var dict5 : [String : Int] = Dictionary()
var dict6 : Dictionary<String, Int> = [String : Int]()
var arr : Array = [Int]()

var dict7 : [String : Int?] = ["age":nil]

var dict8 = ["nil":"", "age":20] as [String : Any]


var airports : [String : String] = ["PEK":"背景机场", "CAN":"广州机场", "SHA":"上海机场"]
// 增加数据
airports["SZA"] = "深圳机场"

// 修改数据
airports["SZA"] = "洛杉矶机场"
if let oldValue = airports.updateValue("深圳福田机场", forKey:"SZA") {
    print("oldValue:\(oldValue)") // oldValue:洛杉矶机场
}else {
    print("没有发现对应的机场")
}

// 删除数据
if let airport = airports.removeValue(forKey: "SZA") {
    print("删除成功：" + airport) // 删除成功：深圳福田机场
}else {
    print("删除失败")
}


// 查询数据
airports["SHA"] // 上海机场
airports["fff"] // nil

// 遍历
for airportKey in airports.keys {
    print(airportKey)
}

let airportsKeys = airports.keys
//airportsKeys[1]



// Take a guess: 它们的结构相同吗
var nsdic : NSMutableDictionary = [1:"one", 2:"two"]
var nsdic2 = nsdic
nsdic[1] = "一"
nsdic2[1]

var dic = [1:"one", 2:"two"]
var dic2 = dic
dic[1] = "-"
dic2[1]



