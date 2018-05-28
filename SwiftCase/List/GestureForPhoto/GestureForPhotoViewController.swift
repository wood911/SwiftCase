//
//  GestureForPhotoViewController.swift
//  SwiftCase
//
//  Created by 伍腾飞 on 2017/5/13.
//  Copyright © 2017年 Shepherd. All rights reserved.
//

import UIKit

// MARK: - protocol PhotoViewDelegate
protocol PhotoViewDelegate {
    func showMoreOptions()
    
}

// MARK: - class PhotoView
class PhotoView: UIView, UIGestureRecognizerDelegate, UIScrollViewDelegate {
    
    var photoDelegate: PhotoViewDelegate?
    var imageURLs: [String]?
    var images: [UIImage]?
    var imageViews: [UIImageView] = []
    var count: Int = 0
    var index: Int {
        didSet {
            if let title = title {
                title.text = "\(index + 1)/\(count)"
            }
            UIView.animate(withDuration: 0.35) {
                for imageView in self.imageViews {
                    imageView.transform = CGAffineTransform.identity
                }
            }
        }
    }
    var title: UILabel?
    
    init(imageURLs: [String], index: Int) {
        self.imageURLs = imageURLs
        self.index = index
        super.init(frame: CGRect.zero)
        setup()
    }
    
    init(images: [UIImage], index: Int) {
        self.images = images
        self.index = index
        super.init(frame: CGRect.zero)
        setup()
    }
    
    func setup() {
        let frame = UIScreen.main.bounds
        self.frame = frame
        self.backgroundColor = UIColor.black
        // 承载图片
        let scrollView = UIScrollView(frame: frame)
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        self.addSubview(scrollView)
        
        // 展示图片下标/总数
        let label = UILabel(frame: CGRect(x: frame.midX - 30, y: 10, width: 60, height: 30))
        label.tag = 1;
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        title = label
        self.addSubview(label)
        
        // 更多选项
        let button = UIButton(frame: CGRect(x: frame.width - 50, y: 10, width: 40, height: 40))
        button.setTitle("...", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(PhotoView.moreAction(_:)), for: .touchUpInside)
        self.addSubview(button)
        
        if let imageURLs = imageURLs {
            count = imageURLs.count
            title!.text = "\(index + 1)/\(count)"
            // 下载图片
            // 参见CollectionView 有图片缓存
        }
        
        if let images = images {
            count = images.count
            title!.text = "\(index + 1)/\(count)"
            // http://stackoverflow.com/questions/24028421/swift-for-loop-for-index-element-in-array
            for (i, image) in images.enumerated() {
                // 这里用ScrollView嵌套ImageView,而不直接用ImageView
                let imageView = UIImageView(frame: CGRect(x: CGFloat(i) * frame.width, y: 0, width: frame.width, height: frame.height))
                imageView.image = image
                imageView.contentMode = .scaleAspectFit
                imageView.isUserInteractionEnabled = true
                imageView.isMultipleTouchEnabled = true
                // 添加手势
                // 1、单击退出
                let tap = UITapGestureRecognizer()
                tap.delegate = self
                tap.numberOfTapsRequired = 1
                tap.handler = { [unowned self] sender in
                    UIView.animate(withDuration: 0.5, animations: { 
                        self.alpha = 0
                    }, completion: { _ in
                        self.removeFromSuperview()
                    })
                }
                imageView.addGestureRecognizer(tap)
                // 2、双击放大
                let doubleTap = UITapGestureRecognizer()
                doubleTap.delegate = self
                doubleTap.numberOfTapsRequired = 2
                doubleTap.handler = { sender in
                    if let view = sender.view {
                        UIView.animate(withDuration: 0.5, animations: {
                            if !view.transform.isIdentity {
                                view.transform = CGAffineTransform.identity
                                view.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                            } else {
                                view.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
                            }
                        })
                    }
                }
                imageView.addGestureRecognizer(doubleTap)
                // 单击双击共存
                tap.require(toFail: doubleTap)
                // 3、长按显示更多选项
                let longPress = UILongPressGestureRecognizer()
                longPress.delegate = self
                longPress.addTarget(self, action: #selector(moreAction(_:)))
                imageView.addGestureRecognizer(longPress)
                // 4、旋转
                let rotation = UIRotationGestureRecognizer()
                rotation.delegate = self
                rotation.handler = { [unowned self] sender in
                    self.adjustAnchorPoint(sender)
                    if let view = sender.view, let gestureReconizer = sender as? UIRotationGestureRecognizer {
                        if gestureReconizer.state == .began || gestureReconizer.state == .changed {
                            print("rotation:\(gestureReconizer.rotation)")
                            // 旋转中心不变
                            view.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                            view.transform = view.transform.rotated(by: gestureReconizer.rotation)
                            gestureReconizer.rotation = 0
                        }
                    }
                }
                imageView.addGestureRecognizer(rotation)
                // 5、缩放
                let pinch = UIPinchGestureRecognizer()
                pinch.delegate = self
                pinch.handler = { [unowned self] sender in
                    self.adjustAnchorPoint(sender)
                    if let view = sender.view, let gestureReconizer = sender as? UIPinchGestureRecognizer {
                        if gestureReconizer.state == .began || gestureReconizer.state == .changed {
                            print("scale:\(gestureReconizer.scale)")
                            view.transform = view.transform.scaledBy(x: gestureReconizer.scale, y: gestureReconizer.scale)
                            gestureReconizer.scale = 1.0
                        }
                    }
                }
                imageView.addGestureRecognizer(pinch)
                // 6、上一张
                let rightSwipe = UISwipeGestureRecognizer()
                rightSwipe.delegate = self
                rightSwipe.direction = .right
                rightSwipe.handler = { sender in
                    
                }
                imageView.addGestureRecognizer(rightSwipe)
                // 7、下一张
                let leftSwipe = UISwipeGestureRecognizer()
                leftSwipe.delegate = self
                leftSwipe.direction = .left
                leftSwipe.handler = { sender in
                    
                }
                imageView.addGestureRecognizer(leftSwipe)
                
                scrollView.addSubview(imageView)
                imageViews.append(imageView)
            }
            scrollView.contentSize = CGSize(width: CGFloat(images.count) * frame.width, height: frame.height)
            scrollView.setContentOffset(CGPoint(x: CGFloat(index) * frame.width, y: 0), animated: true)
        }
    }
    
    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.view != otherGestureRecognizer.view {
            return false
        }
        if gestureRecognizer.isKind(of: UILongPressGestureRecognizer.self) || otherGestureRecognizer.isKind(of: UILongPressGestureRecognizer.self) {
            return false
        }
        return true
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX: CGFloat = scrollView.bounds.width * CGFloat(index)
        let halfWidth: CGFloat = scrollView.bounds.width * 0.5
        if scrollView.contentOffset.x - offsetX > halfWidth {
            index += 1
        } else if scrollView.contentOffset.x - offsetX < -halfWidth {
            index -= index == 0 ? 0 : 1
        }
    }
    
    // 恢复锚点位置
    func adjustAnchorPoint(_ gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == .began {
            if let view = gestureRecognizer.view {
                let point = gestureRecognizer.location(in: view)
                let center = gestureRecognizer.location(in: view.superview)
                view.layer.anchorPoint = CGPoint(x: point.x / view.frame.width, y: point.y / view.frame.height)
                view.center = center
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 更多选项
    @objc func moreAction(_ sender: UIButton) {
        photoDelegate?.showMoreOptions()
    }
}

class OptionsView: UIView {
    
    init(options: [(title: String, handler: VoidBlock)]) {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.clear
        
        let frame = UIScreen.main.bounds
        let kHeight: CGFloat = 54.0
        for (offset: i, element: (title: title, handler: haldler)) in options.enumerated() {
            let label = UILabel(frame: CGRect(x: 0, y: CGFloat(i) * (kHeight + 1.0) , width: frame.width, height: kHeight))
            self.addSubview(label)
            label.isUserInteractionEnabled = true
            label.backgroundColor = UIColor.white
            label.text = title
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 16)
            let tap = UITapGestureRecognizer()
            label.addGestureRecognizer(tap)
            tap.handler = { _ in
                haldler()
            }
        }
        self.frame = CGRect(x: 0, y:frame.maxY , width: frame.width, height:CGFloat(options.count) * kHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class GestureForPhotoViewController: UIViewController, PhotoViewDelegate {
    
    /**
     手势
     步骤：创建手势对象，设置属性，将手势添加到视图中
        重复添加手势事件只有最后的生效
     点击  UITapGestureRecognizer
     长按  UILongGestureRecognizer
     轻扫  UISwipeGestureRecognizer
     缩放  UIPinchGestureRecognizer
     拖拽  UIPanGestureRecognizer
     旋转  UIRotationGestureRecognizer
     核心属性
     state 手势状态
     view 手势中的视图
     numberOfTapsRequired  点击次数
     numberOfTouchesRequired  多点触摸
     direction  轻扫方向
     minimumPressDuration  长按时间
     rotation  旋转弧度
     velocity 缩放速率   scale 缩放比例
     位置 locationInView
     总偏移量(同步移动时注意清零) translationInView
     
     transform 视图变形
     常量CGAffineTransformIdentity记录矩阵没有变化的初始6个值(对象线3个1,其它0),可用于清除视图transform属性
     带Make的函数基于原始位置变化，不带Make的函数基于上一次变化的位置变化
     旋转 CGAffineTransformMakeRotation(rotation)/CGAffineTransformRotate
     缩放 CGAffineTransformScale(imageView.transform, scale, scale)/CGAffineTransformMakeScale
     位移 CGAffineTransformMakeTranslation/CGAffineTransformTranslate
     多个手势共存需UIGestureRecognizerDelegate，并设置手势对象的代理为当前控制器
     
     坐标系4成员
     frame：描述此视图在父视图中位置和占父视图空间的大小(在父视图中的定位)
     bounds：描述的是视图自身的大小，其值和父视图无关，改变会影响子视图
     origin->none size->frame
     transform：描述一个视图的变形(缩放、旋转、位移)，不能和自动布局同时使用
     位移：frame原点变，bounds不变，center不变
     旋转：frame原点及大小都变，bounds不变，center不变
     缩放：frame原点及大小都变，bounds不变，center不变
     center：视图中心
     
     */
    
    // imageView集合
    @IBOutlet var imageView: [UIImageView]!
    
    var optionsView: OptionsView!
    var maskView: UIView?
    
    @objc func imageViewTapAction(_ sender: UITapGestureRecognizer) {
        // 获取点击的位置
        let imageView = sender.view as! UIImageView
        let point = sender.location(in: view)
        
        var images: [UIImage] = []
        for view in self.imageView {
            if let image = view.image {
                images.append(image)
            }
        }
        let photoView = PhotoView(images: images, index: imageView.tag - 1)
        photoView.photoDelegate = self
        photoView.frame = CGRect(origin: point, size: CGSize.zero)
        UIApplication.shared.keyWindow?.addSubview(photoView)
        UIView.animate(withDuration: 0.5, animations: {
            photoView.frame = UIScreen.main.bounds
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSourceCodeItem("gestureforphoto")
        
        for view in imageView {
            // 允许交互
            view.isUserInteractionEnabled = true
            // 添加tap手势，点击进入图片预览窗口
            let tap = UITapGestureRecognizer(target: self, action: #selector(imageViewTapAction(_:)))
            view.addGestureRecognizer(tap)
        }
        
    }
    
    // MARK: - PhotoViewDelegate
    func showMoreOptions() {
        if maskView != nil {
            return
        }
        let options = [
            ("保存图片", {
//                UIImageWriteToSavedPhotosAlbum(<#T##image: UIImage##UIImage#>, self, #selector(image:didFinishSavingWithError:contextInfo:), nil)
            }),
            ("赞", {
                print("👍赞")
            }),
            ("取消", {
                self.dismissOptionsView(true)
            })
        ]
        optionsView =  OptionsView(options: options)
        maskView = UIApplication.shared.keyWindow?.showMask({ [unowned self] in
            self.optionsView.frame.origin = CGPoint(x: 0, y: UIScreen.main.bounds.height)
        })
        maskView?.addSubview(optionsView)
        dismissOptionsView(false)
    }
    
    func dismissOptionsView(_ dismiss: Bool) {
        if dismiss {
            UIView.animate(withDuration: 0.5, animations: {
                self.optionsView.frame.origin = CGPoint(x: 0, y: UIScreen.main.bounds.height)
            }) { flag in
                if let mask = self.optionsView.superview {
                    mask.removeFromSuperview()
                }
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.optionsView.frame.origin = CGPoint(x: 0, y: UIScreen.main.bounds.height - self.optionsView.frame.height)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
