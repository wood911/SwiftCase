//
//  DetectorViewController.swift
//  SwiftCase
//
//  Created by wtf on 2017/5/10.
//  Copyright © 2017年 Shepherd. All rights reserved.
//

import UIKit

class DetectorViewController: UIViewController {

    lazy var inputImage = { () -> CIImage in 
        let filePath = Bundle.main.path(forResource: "emotions", ofType: "jpg")!
        let image = CIImage(contentsOf: URL(fileURLWithPath: filePath))!
        return image
    }()
    
    lazy var context = {
        return CIContext(options: nil)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSourceCodeItem("detector")
        
        let imageView = UIImageView(image: UIImage(named: "emotions.jpg"))
        imageView.frame = CGRect(x: 0, y: 44, width: view.bounds.width, height: view.bounds.height)
        view.addSubview(imageView)
        
        let detector = CIDetector(ofType: CIDetectorTypeFace, context: context, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])!
        let features = detector.features(in: inputImage, options: [CIDetectorSmile: true, CIDetectorEyeBlink: true])
        
        let vistAux = UIView(frame: imageView.frame)
        
        for feature in features {
            
            if let faceFeature = feature as? CIFaceFeature {
                // Face location
                let faceView = UIView(frame: faceFeature.bounds)
                faceView.layer.borderWidth = 2
                faceView.layer.borderColor = UIColor.red.cgColor
                vistAux.addSubview(faceView)
                
                let faceWidth = faceFeature.bounds.width
                let faceHeight = faceFeature.bounds.height
                
                // Smile location
                if faceFeature.hasSmile {
                    let smileRect = CGRect(x: faceFeature.mouthPosition.x - faceWidth * 0.18, y: faceFeature.mouthPosition.y - faceHeight * 0.1, width: faceWidth * 0.4, height: faceHeight * 0.2)
                    let smileView = UIView(frame: smileRect)
                    smileView.layer.cornerRadius = faceWidth * 0.1
                    smileView.layer.borderWidth = 2
                    smileView.layer.borderColor = UIColor.green.cgColor
                    smileView.layer.backgroundColor = UIColor.green.cgColor
                    smileView.layer.opacity = 0.5
                    vistAux.addSubview(smileView)
                }
                
                // Right eye location
                let rightEyeView = UIView(frame: CGRect(x: faceFeature.rightEyePosition.x - faceWidth * 0.2, y: faceFeature.rightEyePosition.y - faceWidth * 0.2, width: faceWidth * 0.4, height: faceWidth * 0.4))
                rightEyeView.layer.cornerRadius = faceWidth * 0.2
                rightEyeView.layer.borderColor = UIColor.red.cgColor
                rightEyeView.layer.backgroundColor = faceFeature.rightEyeClosed ? UIColor.yellow.cgColor : UIColor.red.cgColor
                rightEyeView.layer.opacity = 0.5
                vistAux.addSubview(rightEyeView)
                
                // Left eye location
                let leftEyeView = UIView(frame: CGRect(x: faceFeature.leftEyePosition.x - faceWidth * 0.2, y: faceFeature.leftEyePosition.y - faceWidth * 0.2, width: faceWidth * 0.4, height: faceWidth * 0.4))
                leftEyeView.layer.cornerRadius = faceWidth * 0.2
                leftEyeView.layer.borderColor = UIColor.blue.cgColor
                leftEyeView.layer.backgroundColor = faceFeature.leftEyeClosed ? UIColor.yellow.cgColor : UIColor.blue.cgColor
                leftEyeView.layer.opacity = 0.5
                vistAux.addSubview(leftEyeView)
                
            }
        }
        view.addSubview(vistAux)
        vistAux.transform = CGAffineTransform(scaleX: 1, y: -1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
