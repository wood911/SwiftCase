//
//  GestureForPhotoViewController.swift
//  SwiftCase
//
//  Created by 伍腾飞 on 2017/5/13.
//  Copyright © 2017年 Shepherd. All rights reserved.
//

import UIKit

extension UIGestureRecognizer {
    
    static private var block_key = "UIGestureRecognizerBlockKey"
    
    public var handler: (_ sender: UIGestureRecognizer) -> Void {
        get {
            if let target = objc_getAssociatedObject(self, &UIGestureRecognizer.block_key) {
                return (target as! _UIGestureRecognizerBlockTarget).hander
            }
            return { _ in }
        }
        set {
            let target = _UIGestureRecognizerBlockTarget(hander: newValue)
            objc_setAssociatedObject(self, &UIGestureRecognizer.block_key, target, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.addTarget(target, action: #selector(_UIGestureRecognizerBlockTarget.invoke(_:)))
        }
    }
    
    class _UIGestureRecognizerBlockTarget: NSObject {
        
        var hander: (_ sender: UIGestureRecognizer) -> Void
        
        init(hander: @escaping (_ sender: UIGestureRecognizer) -> Void) {
            self.hander = hander
            super.init()
        }
        
        func invoke(_ sender: UIGestureRecognizer) {
            hander(sender)
        }
        
    }
    
}

extension UIView {
    
    typealias VoidBlock = () -> Void
    
    func showMask(_ tapHandler: VoidBlock?) -> UIView {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        view.isUserInteractionEnabled = true
        view.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.7)
        
        let tap = UITapGestureRecognizer()
        view.addGestureRecognizer(tap)
        tap.handler = { sender in
            UIView.animate(withDuration: 0.5, animations: {
                if let handler = tapHandler {
                    handler()
                }
            }) { _ in
                sender.view?.removeFromSuperview()
            }
        }
        self.addSubview(view)
        
        return view
    }
}

protocol PhotoViewDelegate {
    func showMoreOptions()
    
}

class PhotoView: UIView, UIGestureRecognizerDelegate, UIScrollViewDelegate {
    
    var photoDelegate: PhotoViewDelegate?
    var imageURLs: [String]?
    var images: [UIImage]?
    var count: Int = 0
    var index: Int {
        didSet {
            if let title = title {
                title.text = "\(index + 1)/\(count)"
            }
        }
    }
    var normalState: Bool = true
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
            var i = 0
            for image in images {
                // 这里用ScrollView嵌套ImageView,而不直接用ImageView
                let imageView = UIImageView(frame: CGRect(x: CGFloat(i) * frame.width, y: 0, width: frame.width, height: frame.height))
                imageView.image = image
                imageView.contentMode = .scaleAspectFit
                imageView.isUserInteractionEnabled = true
                imageView.isMultipleTouchEnabled = true
                // 添加手势
                // 1、单击退出
                let tap = UITapGestureRecognizer()
                tap.numberOfTapsRequired = 1
                tap.delaysTouchesBegan = true
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
                doubleTap.numberOfTapsRequired = 2
                doubleTap.handler = { [unowned self] sender in
                    UIView.animate(withDuration: 0.5, animations: {
                        if let view = sender.view {
                            if !self.normalState {
                                view.transform = CGAffineTransform.identity
                                view.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                                view.center = CGPoint(x: frame.width * 0.5, y: frame.height * 0.5)
                            } else {
                                let point = view.convert(sender.location(in: view), to: self)
                                view.center = CGPoint(x: frame.width - point.x, y: frame.height - point.y)
                                let scale: CGFloat = self.normalState ? 2.1 : 1.0
                                view.transform = CGAffineTransform(scaleX: scale, y: scale)
                                self.normalState = !self.normalState
                            }
                        }
                    })
                }
                imageView.addGestureRecognizer(doubleTap)
                // 3、长按显示更多选项
                let longPress = UILongPressGestureRecognizer()
                longPress.addTarget(self, action: #selector(moreAction(_:)))
                imageView.addGestureRecognizer(longPress)
                // 4、旋转
                let rotation = UIRotationGestureRecognizer()
                rotation.handler = { [unowned self] sender in
                    self.adjustAnchorPoint(sender)
                    if let view = sender.view, let gestureReconizer = sender as? UIRotationGestureRecognizer {
                        if gestureReconizer.state == .began || gestureReconizer.state == .changed {
                            print("rotation:\(gestureReconizer.rotation)")
                            view.transform.rotated(by: gestureReconizer.rotation)
                            gestureReconizer.rotation = 0
                        }
                    }
                }
                imageView.addGestureRecognizer(rotation)
                // 5、缩放
                let pinch = UIPinchGestureRecognizer()
                pinch.handler = { [unowned self] sender in
                    self.adjustAnchorPoint(sender)
                    if let view = sender.view, let gestureReconizer = sender as? UIPinchGestureRecognizer {
                        if gestureReconizer.state == .began || gestureReconizer.state == .changed {
                            print("scale:\(gestureReconizer.scale)")
                            view.transform.scaledBy(x: gestureReconizer.scale, y: gestureReconizer.scale)
                            gestureReconizer.scale = 1.0
                        }
                    }
                }
                imageView.addGestureRecognizer(pinch)
                // 6、上一张
                let rightSwipe = UISwipeGestureRecognizer()
                rightSwipe.direction = .right
                rightSwipe.handler = { sender in
                    
                }
                imageView.addGestureRecognizer(rightSwipe)
                // 7、下一张
                let leftSwipe = UISwipeGestureRecognizer()
                leftSwipe.direction = .left
                leftSwipe.handler = { sender in
                
                }
                imageView.addGestureRecognizer(leftSwipe)
                
                scrollView.addSubview(imageView)
                i += 1
            }
            scrollView.contentSize = CGSize(width: CGFloat(i) * frame.width, height: frame.height)
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
    func moreAction(_ sender: UIButton) {
        photoDelegate?.showMoreOptions()
    }
}

class OptionsView: UIView {
    
    init(options: [(title: String, handler: VoidBlock)]) {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.clear
        
        let frame = UIScreen.main.bounds
        let kHeight: CGFloat = 54.0
        var i = 0
        for (title, haldler) in options {
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
            i += 1
        }
        self.frame = CGRect(x: 0, y:frame.maxY , width: frame.width, height:CGFloat(i) * kHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class GestureForPhotoViewController: UIViewController, PhotoViewDelegate {
    
    // imageView集合
    @IBOutlet var imageView: [UIImageView]!
    
    var optionsView: OptionsView!
    var maskView: UIView?
    
    func imageViewTapAction(_ sender: UITapGestureRecognizer) {
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
