//
//  LocationManager.swift
//  SwiftCase
//
//  Created by wtf on 2017/5/11.
//  Copyright © 2017年 Shepherd. All rights reserved.
//

import UIKit
import CoreLocation

typealias LocationBlock = (_ location: CLLocation?, _ cityName: String?, _ error: Error?) -> Void

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    
    private var mgr: CLLocationManager!
    
    private var geocoder: CLGeocoder!
    
    private var location: LocationBlock?
    
    var cityName: String?
    
    override init() {
        super.init()
        mgr = CLLocationManager()
        // 设置定位精度
        mgr.desiredAccuracy = kCLLocationAccuracyBest
        // 定位频率,每隔多少米定位一次
//        mgr.distanceFilter = 10.0
        mgr.delegate = self
        geocoder = CLGeocoder()
    }
    
    func currentLocation(_ location: @escaping LocationBlock) {
        // 请求授权
        mgr.requestWhenInUseAuthorization()
        // 开始定位
        mgr.startUpdatingLocation()
        // 先保存，当获取到位置时回调
        self.location = location
    }
    
    // 根据地名确定地理坐标
    func placemarks(searchBy address: String, _ completionHandler: @escaping (_ placemarks: [CLPlacemark]) -> Void) -> Void {
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let placemarks = placemarks {
                completionHandler(placemarks)
            } else {
                print(error.debugDescription)
            }
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            if let _ = self.location {
                manager.startUpdatingLocation()
            }
        default:
            print("用户未授权定位")
        }
    }
    
    // 成功获取位置后回调当前位置信息
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let locationBlock = self.location, let location = locations.last {
            // 反向地理编码获取城市名称
            geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                // 取得第一个地标，地标中存储了详细的地址信息
                // 注意：一个地名可能搜索出多个地址，取第一个较为精确
                if let info = placemarks?.first?.addressDictionary {
                    self.cityName = info["City"] as? String
                    locationBlock(location, self.cityName, nil)
                }
            })
        }
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let location = self.location {
            location(nil, nil, error)
        }
        manager.stopUpdatingLocation()
    }
    
    
    
}
