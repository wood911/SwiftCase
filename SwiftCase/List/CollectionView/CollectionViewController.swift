//
//  CollectionViewController.swift
//  SwiftCase
//
//  Created by 伍腾飞 on 2017/5/6.
//  Copyright © 2017年 Shepherd. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, WGridFlowLayoutDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    typealias DataBlock = (_ data: Data) -> ()
    
    var map = [String: Data]()
    
    var session: URLSession!
    
    lazy var imageURL: [String] = {
        return ["http://img3.cache.netease.com/photo/0001/2017-05-05/CJMC7L4R19BR0001.jpg",
                "http://img3.cache.netease.com/photo/0001/2017-05-05/CJMC1R7P19BR0001.jpg",
                "http://img5.cache.netease.com/photo/0001/2017-05-05/CJMC8H2J19BR0001.jpg",
                "http://img2.cache.netease.com/photo/0001/2017-05-05/CJMC83UO19BR0001.jpg",
                "http://img5.cache.netease.com/photo/0001/2017-05-05/CJMC0ISJ19BR0001.jpg",
                "http://img3.cache.netease.com/photo/0001/2017-05-05/CJMC0T7S19BR0001.jpg",
                "http://img4.cache.netease.com/photo/0001/2017-05-05/CJMC4ISL19BR0001.jpg",
                "http://img3.cache.netease.com/photo/0001/2017-05-05/CJMC51MF19BR0001.jpg",
                "http://img5.cache.netease.com/photo/0001/2017-05-05/CJMC2I4719BR0001.jpg",
                "http://img6.cache.netease.com/photo/0001/2017-05-05/CJMC14JK19BR0001.jpg",
                "http://img3.cache.netease.com/photo/0001/2017-05-05/CJMC0N8919BR0001.jpg",
                "http://img3.cache.netease.com/photo/0001/2017-05-05/CJMC5G6619BR0001.jpg",
                "http://img3.cache.netease.com/photo/0001/2017-05-05/CJMC3LCR19BR0001.jpg",
                "http://img4.cache.netease.com/photo/0001/2017-05-05/CJMC28PC19BR0001.jpg",
                "http://img3.cache.netease.com/photo/0001/2017-05-05/CJMC5BGH19BR0001.jpg",
                "http://img3.cache.netease.com/photo/0001/2017-05-05/CJMC95FT19BR0001.jpg",
                "http://img3.cache.netease.com/photo/0001/2017-05-05/CJMC6PB919BR0001.jpg",
                "http://img2.cache.netease.com/photo/0001/2017-05-05/CJMC6TA119BR0001.jpg",
                "http://img6.cache.netease.com/photo/0001/2017-05-05/CJMC55CV19BR0001.jpg",
                "http://img3.cache.netease.com/photo/0001/2017-05-05/CJMC891B19BR0001.jpg",
                "http://img5.cache.netease.com/photo/0001/2017-05-05/CJMC8TT019BR0001.jpg"]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSourceCodeItem("collectionview")
        session = URLSession(configuration: URLSessionConfiguration.default)
        let flowLayout = WGridFlowLayout()
        flowLayout.delegate = self
        collectionView.collectionViewLayout = flowLayout
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.map.removeAll()
    }
    
    // MARK: UICollectionViewDelegate, UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURL.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath)
        let URLString = imageURL[indexPath.item]
        unowned let weekItem = item
        download(URLString: URLString) { (data) in
            (weekItem.contentView.viewWithTag(1) as! UIImageView).image = UIImage(data: data)
        }
        return item
    }
    
    // MARK: WGridFlowLayoutDelegate
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, columnCountForSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: collectionView.frame.width * 0.5 - 1, height: collectionView.frame.width * 0.25 - 1)
        }
        return CGSize(width: collectionView.frame.width * 0.5 - 1, height: collectionView.frame.width * 0.5 - 1)
    }
    
    func download(URLString: String, dataBlock: @escaping DataBlock) {
        guard URL(string: URLString) != nil else { return }
        
        let imageURLString = URLString
        let range = imageURLString.startIndex..<imageURLString.endIndex
        let filename = imageURLString.replacingOccurrences(of: "[/:]", with: "", options: .regularExpression, range: range)
        let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
        let imageCachePath = cachePath + "/image"
        
        // 1、从一级缓存memory中读取图片数据
        let exist = self.map.contains(where: { (key, value) -> Bool in
            if key == filename {
                return true
            }
            return false
        })
        if exist {
            dataBlock(self.map[filename]!)
        } else {
            if FileManager.default.fileExists(atPath: imageCachePath + filename) {
                if let data = FileManager.default.contents(atPath: imageCachePath + filename) {
                    dataBlock(data)
                }
                return
            }
            
            session.dataTask(with: URL(string: URLString)!, completionHandler: { (data, response, error) in
                if error != nil {
                    print("ERROR:\(error.debugDescription)")
                    return;
                }
                let httpResponse = response as! HTTPURLResponse
                if httpResponse.statusCode == 200 {
                    if let imageData = data {
                        // 一级缓存 memory
                        self.map[filename] = imageData;
                        // 二级缓存 disk
                        // 创建目录
                        try! FileManager.default.createDirectory(atPath: imageCachePath, withIntermediateDirectories: true, attributes: nil)
                        // 写入图片数据
                        FileManager.default.createFile(atPath: imageCachePath + filename, contents: imageData, attributes: nil)
                    }
                }
            }).resume()
            
        }
        
    }

}
