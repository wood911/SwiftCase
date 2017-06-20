//
//  Common.swift
//  SwiftCase
//
//  Created by 伍腾飞 on 2017/4/29.
//  Copyright © 2017年 Shepherd. All rights reserved.
//

import UIKit

public typealias SVoid = () -> ()


/// 一下设计方式按项目作出相应改变，仅供参考

#if BETA
    
let InterfaceDomain = "https://www.google.com/"

#else
    
let InterfaceDomain = "https://www.apple.com/"
    
#endif





public let ScreenW = UIScreen.main.bounds.width
public let ScreenH = UIScreen.main.bounds.height

/// EEEEEE
let colorA0 = UIColor.hex(0xEEEEEE)
/// FFFFFF
let colorA1 = UIColor.hex(0xFFFFFF)
/// 1268BB
let colorA2 = UIColor.hex(0x1268BB)
/// 999999
let colorA3 = UIColor.hex(0x999999)
/// DDDDDD
let colorA4 = UIColor.hex(0xDDDDDD)
/// 142341
let colorA5 = UIColor.hex(0x142341)
/// 333333
let colorA6 = UIColor.hex(0x333333)
/// F48E2B
let colorA7 = UIColor.hex(0xF48E2B)
/// F35361
let colorA8 = UIColor.hex(0xF35361)
/// E6505F
let colorA9 = UIColor.hex(0xE6505F)
/// C4D5E2
let colorB0 = UIColor.hex(0xC4D5E2)
/// CCCCCC
let colorB1 = UIColor.hex(0xCCCCCC)
/// 666666
let colorB2 = UIColor.hex(0x666666)
/// DCE5E9
let colorB3 = UIColor.hex(0xDCE5E9)
/// C4D5E2
let colorB4 = UIColor.hex(0xC4D5E2)
/// EDF2F6
let colorB5 = UIColor.hex(0xEDF2F6)
/// F5F5F5
let colorB6 = UIColor.hex(0xF5F5F5)
/// FCF8E6
let colorB7 = UIColor.hex(0xFCF8E6)
/// 5BA0FF
let colorB8 = UIColor.hex(0x5BA0FF)
/// F9F9F9
let colorB9 = UIColor.hex(0xF9F9F9)



public let placeholderImage = UIImage(named: "image_default")



public extension UIColor {
    class func hex(_ value: Int, _ alpha: CGFloat = 1.0) -> UIColor {
        let r = (CGFloat)((value & 0xFF0000) >> 16) / 255.0
        let g = (CGFloat)((value & 0xFF00) >> 8) / 255.0
        let b = (CGFloat)(value & 0xFF) / 255.0
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
}

public func XLog<T>(_ message: T, _ file: String = #file, _ line: Int = #line, _ method: String = #function) {
    #if DEBUG
    print("\(file.components(separatedBy: "/").last ?? file) \(line) \(method):\(message)")
    #endif
}


