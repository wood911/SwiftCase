//
//  AppBridge.swift
//  SwiftCase
//
//  Created by 伍腾飞 on 2017/6/17.
//  Copyright © 2017年 Shepherd. All rights reserved.
//

import Foundation
import JavaScriptCore

/// AppBridge导出JS上下文协议
@objc protocol AppBridgeExport: JSExport {
    
    /// 业务模块1
    var model1: OneBridge {get}
    
    /// 业务模块2
//    var model2: TwoBridge {get}
    
    /// App版本 5.12
    var appVersion: String {get}
    
    /// accessToken
    var accessToken: String {get}
    
    /// userid
    var userid: String {get}
    
    /// 平台 iOS Android
    var platform: String {get}
    
    /// 语言 cn en
    var language: String {get}
    
}

/// 业务模块定义JS调用接口
@objc protocol OneBridgeExport: JSExport {
    
    /// 添加商品到购物车
    ///
    /// - Parameter json: {"code":0, "msg":"错误信息，state==0表示成功，没有错误表示不传", "data":Object}
    func addCart(_ json: String?)
}

/// webview中JSContext存在的全局对象
class AppBridge: NSObject, AppBridgeExport {
    /// 业务模块1
    var model1: OneBridge

    /// 语言 cn en fr ...
    var language: String
    
    /// 平台 iOS Android
    var platform: String
    
    /// userid
    var userid: String
    
    /// accessToken
    var accessToken: String
    
    /// App版本 1.0
    var appVersion: String
    
    
    override init() {
        model1 = OneBridge()
        language = "cn"
        platform = "iOS"
        userid = "xiaowu"
        accessToken = "FASDOFIJWOEIDSFN0092IR33REQW90QEWION"
        appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
}

/// 实现接口，共JS方调用
class OneBridge: NSObject, OneBridgeExport {
    
    var block: ((_ obj: JSObj) -> ())?
    
    func addCart(_ json: String?) {
        if let json = json {
            jsonSatax(json)
        }
    }
    
    // 没有在JSExport中声明的方法是不会在JS环境中出现的
    func privateMethod(_ json: String?) {
        if let json = json {
            jsonSatax(json)
        }
    }
    
    private func jsonSatax(_ json: String) {
        XLog("JSCallback:\(json)")
        // 可以使用SwiftyJSON
        if let obj = try? JSONSerialization.jsonObject(with: json.data(using: .utf8)!, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [String: Any], let block = block {
            let t = JSObj()
            if let code = obj?["code"] as? Int {
                t.code = code
            }
            if let msg = obj?["msg"] as? String {
                t.msg = msg
            }
            if let data = obj?["data"] {
                t.data = data
            }
            block(t)
        } else {
            XLog("AppBridge JSON 解析错误")
        }
    }
}

class JSObj: NSObject {
    var code: Int = -1
    var msg: String = ""
    var data: Any = []
}

