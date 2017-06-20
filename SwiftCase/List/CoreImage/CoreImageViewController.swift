//
//  CoreImageViewController.swift
//  SwiftCase
//
//  Created by 伍腾飞 on 2017/5/7.
//  Copyright © 2017年 Shepherd. All rights reserved.
//

import UIKit

class CoreImageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    /**
     1、滤镜（CIFliter）：接受一到多的图片作为输入，经过一些过滤操作，产生指定输出的图片，滤镜链
     2、检测（CIDetector）：检测处理图片的特性，如使用来检测图片中人脸的眼睛、嘴巴、等等。
     3、特征（CIFeature）：由 detector处理后产生的特征。
     4、画布（CIContext）：可被用与处理Quartz 2D 或者  OpenGL
     5、颜色（CIColor）
     6、向量（CIVector）
     7、图片（CIImage）
     操作步骤：
     1、创建 CIImage
     2、创建 CIFliter 并设置输入
     3、创建 CIContext
     4、渲染滤镜输出 CIImage
     
     https://developer.apple.com/library/content/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html#//apple_ref/doc/uid/TP30000136-SW29
     let categories = [
        kCICategoryDistortionEffect         , //失真效果
        kCICategoryGeometryAdjustment       , //几何调整
        kCICategoryCompositeOperation       , //复合操作
        kCICategoryHalftoneEffect           , //半色调效果
        kCICategoryColorAdjustment          , //颜色调整
        kCICategoryColorEffect              , //颜色效果
        kCICategoryTransition               , //翻转
        kCICategoryTileEffect               , //瓦片效果
        kCICategoryGenerator                , //生成器
        kCICategoryReduction                , //削减
        kCICategoryGradient                 , //梯度
        kCICategoryStylize                  , //风格
        kCICategorySharpen                  , //锐化
        kCICategoryBlur                     , //模糊
        kCICategoryVideo                    , //视频
        kCICategoryStillImage               , //静态图片
        kCICategoryInterlaced               , //交叉
        kCICategoryNonSquarePixels          , //非方形像素
        kCICategoryHighDynamicRange         , //高动态范围
        kCICategoryBuiltIn                  , //内建
        kCICategoryFilterGenerator
     ]
     
     for category in categories {
        print(CIFilter.filterNames(inCategory: category))
     }
     */
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var slider: UISlider!
    
    var saturation: Float = 1.0
    var brightness: Float = 0
    var contrast: Float = 1.0
    
    // MARK: - lazy load
    lazy var context = {
        return CIContext(options: nil)
    }()
    
    var filter: CIFilter!
    
    // 元组 (filterName: String, displayName: String)
    lazy var filterNames: [(filterName: String, displayName: String)] = {
        return [("CIPhotoEffectInstant", "怀旧Instant"),
                ("CIPhotoEffectNoir", "黑白Noir"),
                ("CIPhotoEffectTonal", "色调Tonal"),
                ("CIPhotoEffectTransfer", "岁月Transfer"),
                ("CIPhotoEffectMono", "单调Mono"),
                ("CIPhotoEffectFade", "褪色Fade"),
                ("CIPhotoEffectProcess", "冲印Process"),
                ("CIPhotoEffectChrome", "珞璜Chrome"),
                ("CIGaussianBlur", "高斯模糊GaussianBlur")]
    }()
    lazy var inputImage = { () -> CIImage in 
        let filePath = Bundle.main.path(forResource: "landscape", ofType: "png")!
        let inputImage: CIImage = CIImage(contentsOf: URL(fileURLWithPath: filePath))!
        return inputImage
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSourceCodeItem("coreimage")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.cellForItem(at: indexPath) ?? collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath)
        filter = CIFilter(name: filterNames[indexPath.row].filterName)
        filter.setDefaults()
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        let outputImage = filter.outputImage!
        let cgImage = context.createCGImage(outputImage, from: outputImage.extent)!
        
        for view in item.contentView.subviews {
            if view.isKind(of: UIImageView.classForCoder()) {
                (view as! UIImageView).image = UIImage(cgImage: cgImage)
            } else if view.isKind(of: UILabel.classForCoder()) {
                (view as! UILabel).text = filterNames[indexPath.row].displayName
            }
        }
        return item
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3 - 2, height: collectionView.frame.width / 3 - 30)
    }
    
    // MARK: - UIEvents
    @IBAction func sliderAction(_ sender: UISlider) {
        switch segment.selectedSegmentIndex {
        case 0:
            saturation = sender.value
        case 1:
            brightness = sender.value
        case 2:
            contrast = sender.value
        default:
            print("test")
        }
        let filter = CIFilter(name: "CIColorControls")!
        filter.setDefaults()
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(saturation, forKey: "inputSaturation")
        filter.setValue(brightness, forKey: "inputBrightness")
        filter.setValue(contrast, forKey: "inputContrast")
        
        let outputImage = filter.outputImage!
        let cgImage = CIContext(options: nil).createCGImage(outputImage, from: outputImage.extent)!
        
        imageView.image = UIImage(cgImage: cgImage)
    }

    @IBAction func valueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            slider.value = saturation
        case 1:
            slider.value = brightness
        case 2:
            slider.value = contrast
        default:
            print("test")
        }
    }
    
    @IBAction func tapImage(_ sender: UITapGestureRecognizer) {
        self.show(DetectorViewController(), sender: nil)
    }
}
