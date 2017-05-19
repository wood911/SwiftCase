//: Playground - noun: a place where people can play

import UIKit

/*
 * 本节主要内容:
 * 1.结构体如何使用并实例化
 * 2.访问结构体属性; 重新赋值
 * 3.没有给定自定义的init构造方法, 编译器会自动生成一个包含所有属性的构造方法
 */

struct Location {
    var latitude: Double    // 纬度
    var longitude: Double   // 经度
    let country: String     // 出生地
    func desc() -> String {
        return "[latitude:\(latitude) longitude:\(longitude) country:\(country)]"
    }
    // mutating 实例方法中是不可以修改值类型的属性 
    mutating func moveBy(location: Location) {
        latitude = location.latitude
        longitude = location.longitude
    }
}
// 实例化结构体
var locationOne = Location(latitude: 39.123, longitude: 116.465, country: "Beijing")
locationOne = Location(latitude: 39.123, longitude: 116.465, country: "北京")
locationOne.latitude
locationOne.longitude
locationOne.country

struct Place {
    let location: Location
    var name: String // 现在所在城市的名字
    // 添加无参构造函数，会覆盖编译器提供的默认构造函数
    init() {
        print("Call init method")
        location = Location(latitude: 39.123, longitude: 116.465, country: "Beijing")
        name = "北京"
    }
    // 此构造函数本是编译器默认提供的，但上面写了init()，编译器不再提供要手动写上
    init(location: Location, name: String) {
        self.location = location
        self.name = name
    }
    // 描述方法
    func desc() -> Void {
        print("[name:\(name) location:\(location.desc())]")
    }
}
var placeOne = Place()
placeOne.desc()
var locationTwo = Location(latitude: 96.325, longitude: 102.321, country: "Shenzhen")
var placeTwo = Place(location: locationTwo, name: "深圳")
placeTwo.desc()


struct Coordinate {
    let latitude: Double
    let longitude: Double
    // 无参构造函数
    init() {
        latitude = 0.0
        longitude = 0.0
    }
    // 所有属性构造函数
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    // 可选构造函数，失败返回nil
    init?(coordinate: String) {
        guard let range = coordinate.range(of: ",") else {
            return nil
        }
        // 字符串中包含, 可以解析 
        // range.lowerBound 左边的下标  range.upperBound 右边的下标
        let leftIndex = coordinate.index(range.lowerBound, offsetBy: 0)
        let rightIndex = coordinate.index(leftIndex, offsetBy: 1)
        print("\(leftIndex == range.lowerBound), \(rightIndex == range.upperBound)")
        guard let left = Double(coordinate.substring(to: range.lowerBound)), let right = Double(coordinate.substring(from: range.upperBound)) else {
            return nil
        }
        self.init(latitude: left, longitude: right)
    }
    func isNorth() -> Bool {
        return latitude > 0
    }
    func isSouth() -> Bool {
        return !isNorth()
    }
    func distance(location: Coordinate) -> Double {
        return sqrt(pow(latitude - location.latitude, 2) + pow(longitude - location.longitude, 2))
    }
}

var coordinateOne = Coordinate()
var coordinateTwo = Coordinate(latitude: 39.123, longitude: 116.465)
var coordinateThree = Coordinate(coordinate: "39.123,116.465")
coordinateThree?.latitude
coordinateThree?.longitude






