//
//  QRcodeViewController.swift
//  SwiftCase
//
//  Created by 伍腾飞 on 2017/4/30.
//  Copyright © 2017年 Shepherd. All rights reserved.
//

import UIKit
import AVFoundation

class QRcodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet var preview: UIView!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var captureSession: AVCaptureSession!
    var metadataOutput: AVCaptureMetadataOutput!
    var videoDevice: AVCaptureDevice!
    var videoInput: AVCaptureDeviceInput!
    var runnng = false
    
    var sendURL: String!
    
    
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
        preview.layer.addSublayer(previewLayer)
        // 应用进入后台时停止扫描，进入前台时继续扫描
        NotificationCenter.default.addObserver(self, selector: #selector(startRunning), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(stopRunning), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)

        
    }
    
    func startRunning() {
        guard captureSession != nil else {
            return
        }
        captureSession.startRunning()
        metadataOutput.metadataObjectTypes = metadataOutput.availableMetadataObjectTypes
        runnng = true
    }
    
    func stopRunning() {
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
        
        videoDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
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
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        metadataOutput = AVCaptureMetadataOutput()
        let metadataQueue = DispatchQueue(label: "com.example.QRCode.metadata", attributes: [])
        metadataOutput.setMetadataObjectsDelegate(self, queue: metadataQueue)
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
        }
        
    }

}
