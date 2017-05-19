//
//  LocationViewController.swift
//  SwiftCase
//
//  Created by wtf on 2017/5/11.
//  Copyright © 2017年 Shepherd. All rights reserved.
//

import UIKit
import MapKit

class LocationViewController: UIViewController, UISearchBarDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    lazy var geocoder = {
        return CLGeocoder()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.userTrackingMode = .followWithHeading // 带导航的定位
        mapView.isRotateEnabled = false
        mapView.mapType = .standard
        
        // 获取用户位置
        LocationManager.shared.currentLocation { (location, cityName, error) in
            if let location = location, let cityName = cityName {
                print("\(location.coordinate) \(location.altitude) \(cityName)")
            }
        }
        
    }
    
    // MARK: - MKMapViewDelegate
    // 添加标注（大头针）
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // MKUserLocation 用户大头针标记，与添加的大头针区分开
        if annotation.isKind(of: MKUserLocation.classForCoder()) {
            return nil
        }
        
        let identifier = "pin"
        // 复用机制，类似于tableview cell
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.pinTintColor = UIColor.green
            // 显示弹框
            annotationView!.canShowCallout = true
            annotationView!.leftCalloutAccessoryView = UIImageView(image: UIImage(named: "user_address"))
            annotationView!.rightCalloutAccessoryView = UIImageView(image: UIImage(named: "share_more"))
        } else {
            annotationView!.annotation = annotation
        }
        return annotationView
    }
    
    // 获取用户位置
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
    }
    
    // 画线渲染，线宽、颜色
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay)
        render.lineWidth = 3.0
        render.strokeColor = UIColor.blue
        return render
    }
    
    // MARK: - UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let place = searchBar.text!
        if place.isEmpty {
            return
        }
        getLocation(by: place)
    }
    
    func getLocation(by address: String) {
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let placemarks = placemarks {
                self.mapView.removeAnnotations(self.mapView.annotations)
                var latitudeDelta: CLLocationDegrees! = 0.0
                var longitudeDelta: CLLocationDegrees! = 0.0
                
                // 取得第一个地标，地标中存储了详细的地址信息
                // 注意：一个地名可能搜索出多个地址
                for placemark in placemarks {
                    let location = placemark.location // 位置
                    let region = placemark.region // 区域
                    let name = placemark.name // 地名
                    let country = placemark.country // 国家
                    let locality = placemark.locality // 城市
                    let thoroughfare = placemark.thoroughfare // 街道
                    // let subThoroughfare = placemark.subThoroughfare // 街道相关信息，例如门牌等
                    // let subLocality = placemark.subLocality // 城市相关信息，例如标志性建筑
                    // let administrativeArea = placemark.administrativeArea // 州
                    // let subAdministrativeArea = placemark.subAdministrativeArea // 其他行政区域信息
                    // let postalCode = placemark.postalCode // 邮编
                    // let inlandWater = placemark.inlandWater // 水源、湖泊
                    // let ocean = placemark.ocean // 海洋
                    // let areasOfInterest = placemark.areasOfInterest // 关联的或利益相关的地标
                    // let addressInfo = placemark.addressDictionary // 详细地址信息字典,包含以下部分信息
                    
                    print("\(String(describing: location)) \(String(describing: region)) \(String(describing: name))")
                    
                    // 1、创建标注对象
                    let annotation = MKPointAnnotation()
                    
                    // 2、设置属性
                    annotation.coordinate = (placemark.location?.coordinate)!
                    annotation.title = name
                    annotation.subtitle = (country ?? "") + (locality ?? "") + (thoroughfare ?? "")
                    
                    // 3、添加到地图上
                    self.mapView.addAnnotation(annotation)
                    
                    if let location = location, let userLocation = self.mapView.userLocation.location {
                        let distance = location.distance(from: userLocation)
                        // 设置子标题，距离我的位置
                        let sub = distance > 1000 ? String(format: "%.2f km", distance / 1000.0) : "\(distance) m"
                        annotation.subtitle = annotation.subtitle! + sub
                        // 求出距离我的位置的经纬度增量
                        latitudeDelta = max(abs(location.coordinate.latitude - userLocation.coordinate.latitude), latitudeDelta)
                        longitudeDelta = max(abs(location.coordinate.longitude - userLocation.coordinate.longitude), longitudeDelta)
                    }
                }
                // 4、将最大距离作为中心区域
                self.mapView.setRegion(MKCoordinateRegion(center: self.mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 2.1 * latitudeDelta, longitudeDelta: 2.1 * longitudeDelta)), animated: true)
            } else {
                print(error.debugDescription)
            }
        }
    }
    
    
    // MARK: - UIEvents
    @IBAction func walk(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            view.showMessage("开始跑步🏃")
        } else {
            sender.isSelected = true
            view.showMessage("跑步结束")
        }
        
    }
    
    @IBAction func userLocation(_ sender: UIButton) {
        mapView.showsUserLocation = true
    }
    
    
    /// 根据起点和重点绘制路线
    ///
    /// - Parameters:
    ///   - startMark: 起点
    ///   - endMark: 重点
    func route(start startMark: CLPlacemark, end endMark: CLPlacemark) {
        // 创建请求，设置起点和重点
        let request = MKDirectionsRequest()
        request.source = MKMapItem(placemark: MKPlacemark(placemark: startMark))
        request.destination = MKMapItem(placemark: MKPlacemark(placemark: endMark))
        
        // 根据请求信息，计算出路线
        let direction = MKDirections(request: request)
        direction.calculate { (response, error) in
            if let response = response {
                for route in response.routes {
                    print("Distance: %.2f km Time: %.1f h", route.distance / 1000.0, route.expectedTravelTime / 3600)
                    // 转折点连线添加到地图中
                    for step in route.steps {
                        self.mapView.add(step.polyline)
                    }
                }
            }
        }
        
    }

}
