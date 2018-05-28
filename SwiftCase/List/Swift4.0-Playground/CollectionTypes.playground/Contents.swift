//: Playground - noun: a place where people can play

import UIKit

/**
 集合类型
 Array ordered list
 Set
 Dictionary
 */

// Array<Character> Character指定数组存储的类型，简写成[Character]
var charactersArray = Array<Character>()
var someInts: [Int] = []
someInts.count
someInts.isEmpty
someInts.append(1)

// someInts是一个空数组，但类型仍是[Int]
someInts = []

var doubles = Array(repeating: 0.0, count: 3)

var shoppingList = ["Eggs", "Milk"]
shoppingList += ["Bread", "Butter"]

shoppingList[0] = "Apples"
shoppingList[1...3] = ["Bananas", "Suger"]

for item in shoppingList {
    print(item)
}

for (index, value) in shoppingList.enumerated() {
    print("\(index)-\(value)")
}


// Set<Character> unordered
var charactersSet = Set<Character>()
charactersSet.count
charactersSet.insert("a")
// 仍是Set<Character>类型
charactersSet = []

var favoriteGenres: Set = ["Rock", "Classical", "Hip hop"]
favoriteGenres.insert("Jazz")
favoriteGenres.remove("")
if favoriteGenres.contains("Jazz") {
    let removedGenre = favoriteGenres.remove("Jazz")
}

for genre in favoriteGenres {
    print(genre)
}
for genre in favoriteGenres.sorted() {
    print(genre)
}

let odd: Set = [1, 3, 5, 7, 9]
let even: Set = [0, 2, 4, 6, 8]
let prime: Set = [2, 3, 5, 7]
// 并集
let union = odd.union(even).sorted()
// 交集
odd.intersection(even).sorted()
// 差集
odd.subtracting(prime).sorted()

prime.isSubset(of: union)
odd.isDisjoint(with: even)


// Dictionary [Key: Value]
var nameAge: [String: Int] = ["xiaowu": 24, "xiaoshan": 24]
// add
nameAge["feng"] = 25
// update
nameAge["xiaowu"] = 20
// delete
nameAge["feng"] = nil

for (name, age) in nameAge {
    print("name:\(name) age:\(age)")
}
let names = [String](nameAge.keys)
let ages = [Int](nameAge.values)


let point = (1, -1)
switch point {
case let (x, y) where x == y :
    print("(\(x), \(y)) is on the line x == y")
case let (x, y) where x == -y :
    print("(\(x), \(y)) is on the line x == -y")
case let (x, y):
    print("(\(x), \(y))")
}

if #available(iOS 10, macOS 10.12, *) {
    
} else {
    
}















