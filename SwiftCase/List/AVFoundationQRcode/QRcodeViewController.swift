//
//  QRcodeViewController.swift
//  SwiftCase
//
//  Created by 伍腾飞 on 2017/4/30.
//  Copyright © 2017年 Shepherd. All rights reserved.
//

import UIKit
import AVFoundation

class QRcodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UITextFieldDelegate {

    @IBOutlet var preview: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var sendURL: UILabel!
    @IBOutlet weak var inputMessage: UITextField!
    
    var previewLayer: AVCaptureVideoPreviewLayer!
    var captureSession: AVCaptureSession!
    var metadataOutput: AVCaptureMetadataOutput!
    var videoDevice: AVCaptureDevice!
    var videoInput: AVCaptureDeviceInput!
    var runnng = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addSourceCodeItem("avfoundationqrcode")
        
        setupCaptureSession()
        
        guard captureSession != nil else {
            let alert = UIAlertController(title: "Carema Required", message: "This device has no carema.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Got it", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        previewLayer.frame = preview.bounds
        preview.layer.insertSublayer(previewLayer, at: 0)
        
        // 应用进入后台时停止扫描，进入前台时继续扫描
        NotificationCenter.default.addObserver(self, selector: #selector(startRunning), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(stopRunning), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.stopRunning()
    }
    
    @objc func startRunning() {
        guard captureSession != nil else {
            return
        }
        captureSession.startRunning()
        metadataOutput.metadataObjectTypes = metadataOutput.availableMetadataObjectTypes
        runnng = true
    }
    
    @objc func stopRunning() {
        captureSession.stopRunning()
        runnng = false
    }
    
    
    func setupCaptureSession() {
        // 流程：相机扫描二维码 需要captureSession包含输入流和输出流
        // 输入流：videoInput 设备初始化相机后构造设备输入流
        // 输出流：metadataOutput 摄像后得到的元数据后解码可得到扫到的二维码信息
        // 将captureSession信息通过AVCaptureVideoPreviewLayer实时显示到previewLayer
        
        // 如果captureSession已经初始化过就不用初始化了，使用完毕后关掉
        if captureSession != nil {
            return
        }

        videoDevice = AVCaptureDevice.default(for: .video)
        guard videoDevice != nil else {
            print("No carema on this device. Is this an iOS Simulator?")
            return
        }
        
        captureSession = AVCaptureSession()
        videoInput = try! AVCaptureDeviceInput(device: videoDevice)
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        metadataOutput = AVCaptureMetadataOutput()
        let metadataQueue = DispatchQueue(label: "com.example.QRCode.metadata", attributes: [])
        metadataOutput.setMetadataObjectsDelegate(self, queue: metadataQueue)
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
        }
        
    }
    
    // MARK: - AVCaptureMetadataOutputObjectsDelegate
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        let elemento = metadataObjects.first as? AVMetadataMachineReadableCodeObject
        if(elemento != nil){
            // self.stopRunning()
            print(elemento!.stringValue ?? "")
            sendURL.text = elemento!.stringValue
        }
    }
    
    // MARK: - 生成二维码
    @IBAction func generate(_ sender: UIButton) {
        self.stopRunning()
        // 创建一个二维码种类路径
        // 二维码：CIQRCodeGenerator  条形码：CICode128BarcodeGenerator
        let filter = CIFilter(name: "CIQRCodeGenerator")!
        // 恢复滤镜为默认设置
        filter.setDefaults()
        // 准备元数据
        var metaText = "https://www.github.com";
        if let text = inputMessage.text {
            if !text.isEmpty {
                metaText = text
            }
        }
        let metadata = metaText.data(using: .utf8)
        // 设置 滤镜 inputMessage 属性
        filter.setValue(metadata, forKey: "inputMessage")
        filter.setValue("H", forKey: "inputCorrectionLevel")
        // 输出二维码图片
        let ciImage = filter.outputImage!
        
        // 这样的二维码不清晰，需要重绘一下
        imageView.image = UIImage(ciImage: redrawImage(ciImage, width: imageView.frame.width))
        imageView.alpha = 1
        
        // 添加logo
        let width = imageView.frame.width * 0.5 - 30
        let logo = UIImageView(frame: CGRect(x: width, y: width, width: 60, height: 60))
        logo.image = UIImage(named: "image")
        imageView.addSubview(logo)
    }
    
    // MARK: - 扫描二维码
    @IBAction func scan(_ sender: UIButton) {
        if !runnng {
            self.startRunning()
        }
        imageView.alpha = 0
    }
    
    // MARK: - 侦测照片中的二维码
    @IBAction func detect(_ sender: UIButton) {
        if imageView.alpha > 0 {
            if let image = imageView.image, let result = detecteImage(image) {
                sendURL.text = result
            }
        }
    }
    
    
    // MARK: - 重绘 + 滤镜 增加清晰度
    func redrawImage(_ cgImage: CIImage, width: CGFloat) -> CIImage {
        // 根据容器得到适合的尺寸
        let rect = cgImage.extent.integral
        let scale = min(width / rect.width, width / rect.height)
        
        // 获取BitmapContext，设置输出质量high
        let bmpRef = CGContext(data: nil, width: Int(rect.width * scale), height: Int(rect.height * scale), bitsPerComponent: 8, bytesPerRow: 0, space: CGColorSpaceCreateDeviceGray(), bitmapInfo: CGImageAlphaInfo.none.rawValue)!
        bmpRef.interpolationQuality = .high
        bmpRef.scaleBy(x: scale, y: scale)
        
        // 默认用GPU渲染，以牺牲浮点数运算精度换取速度
        let context = CIContext(options: nil)
        let imageRef = context.createCGImage(cgImage, from: rect)!
        
        bmpRef.draw(imageRef, in: rect, byTiling: true)
        
        // 原生灰度图片
        var outputImage = CIImage(cgImage: bmpRef.makeImage()!)
        
        // 伪色滤镜
        var filter = CIFilter(name: "CIFalseColor")!
        filter.setDefaults()
        filter.setValue(outputImage, forKey: kCIInputImageKey)
        filter.setValue(CIColor(red: 99.0 / 255.0, green: 44.0 / 255.0, blue: 83.0 / 255.0), forKey: "inputColor0")
        filter.setValue(CIColor(red: 1.0, green: 1.0, blue: 1.0), forKey: "inputColor1")
        outputImage = filter.outputImage!
        
        // 兰索斯缩放变化滤镜
        filter = CIFilter(name: "CILanczosScaleTransform")!
        filter.setDefaults()
        filter.setValue(outputImage, forKey: kCIInputImageKey)
        filter.setValue(1.0, forKey: kCIInputScaleKey)
        filter.setValue(1.0, forKey: kCIInputAspectRatioKey)
        outputImage = filter.outputImage!
        
        // 细节锐化滤镜
        filter = CIFilter(name: "CISharpenLuminance")!
        filter.setDefaults()
        filter.setValue(outputImage, forKey: kCIInputImageKey)
        filter.setValue(10.0, forKey: kCIInputSharpnessKey)
        outputImage = filter.outputImage!
        
        return outputImage
    }
    
    // MARK: - 侦测相册中的图片
    func detecteImage(_ image: UIImage) -> String? {
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])!
        let features = detector.features(in: image.ciImage!)
        if features.count > 0 {
            let result = (features[0] as! CIQRCodeFeature).messageString
            return result
        }
        return nil
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
