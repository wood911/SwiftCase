//
//  AppGuideViewController.swift
//  SwiftCase
//
//  Created by wtf on 2017/5/19.
//  Copyright © 2017年 Shepherd. All rights reserved.
//

import UIKit

class AppGuideViewController: UIViewController, UIScrollViewDelegate {

    weak var pageControl: UIPageControl!
    
    lazy var images: [UIImage] = {
        var images: [UIImage] = []
        for index in 0..<4 {
            if let image = UIImage(named: "welcome\(index)") {
                images.append(image)
            }
        }
        return images
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = UIColor.white
        
        setupScrollView()
        
        setupPageControl()
        
    }
    
    func backAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupScrollView() {
        // modal present full screen
        let scrollView = UIScrollView(frame: view.bounds)
        let bounds = view.bounds
        // 设置代理
        scrollView.delegate = self
        // 一共4页
        scrollView.contentSize = CGSize(width: bounds.width * CGFloat(images.count), height: bounds.height)
        // 拖动时不要看到背景色
        scrollView.bounces = false
        // 整页滑动
        scrollView.isPagingEnabled = true
        // 关闭水平滚动条
        scrollView.showsHorizontalScrollIndicator = false
        
        for (index, image) in images.enumerated() {
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: CGFloat(index) * bounds.width, y: 0, width: bounds.width, height: bounds.height)
            scrollView.addSubview(imageView)
            // 最后一张 点击/下拉返回
            if index == images.endIndex - 1 {
                imageView.isUserInteractionEnabled = true
                let tap = UITapGestureRecognizer(target: self, action: #selector(backAction))
                imageView.addGestureRecognizer(tap)
                let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(backAction))
                swipeDown.direction = .down
                imageView.addGestureRecognizer(swipeDown)
            }
        }
        view.addSubview(scrollView)
        
    }
    
    func setupPageControl() {
        // 图片下标 4点
        let pageControl = UIPageControl(frame: CGRect(x: 0, y: view.frame.height - 80, width: view.frame.width, height: 40))
        
        pageControl.numberOfPages = 4
        pageControl.currentPage = 0
        // 点的颜色
        pageControl.pageIndicatorTintColor = UIColor.darkGray
        // 选中点的颜色
        pageControl.currentPageIndicatorTintColor = UIColor.white
        pageControl.isUserInteractionEnabled = false
        
        view.addSubview(pageControl)
        self.pageControl = pageControl
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        pageControl.currentPage = pageIndex
    }

}
