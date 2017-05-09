//
//  CoreImageViewController.swift
//  SwiftCase
//
//  Created by 伍腾飞 on 2017/5/7.
//  Copyright © 2017年 Shepherd. All rights reserved.
//

import UIKit

class CoreImageViewController: UIViewController {

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
     */
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func action(_ sender: UIButton) {
        
    }
    
    @IBAction func sliderAction(_ sender: UISlider) {
        
    }

}
