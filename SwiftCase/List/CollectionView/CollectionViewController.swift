//
//  CollectionViewController.swift
//  SwiftCase
//
//  Created by 伍腾飞 on 2017/5/6.
//  Copyright © 2017年 Shepherd. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var session: URLSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        session = URLSession(configuration: URLSessionConfiguration())
        session.downloadTask(with: <#T##URL#>, completionHandler: <#T##(URL?, URLResponse?, Error?) -> Void#>)
    }
    
    // MARK: UICollectionViewDelegate, UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
    }

}
