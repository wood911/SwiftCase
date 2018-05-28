//
//  AirdropViewController.swift
//  SwiftCase
//
//  Created by wtf on 2017/4/28.
//  Copyright © 2017年 Shepherd. All rights reserved.
//

import UIKit
import MediaPlayer
import MobileCoreServices

typealias VoidBlock = () -> ()

class AirdropViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /**
         ///////////////////////////////////////////////////////////////////////////////////
         extension UIViewController {
         
            public func addSourceCodeItem(_ fileName: String) {
                let item = UIBarButtonItem()
                item.title = "Code"
                item.hander = { _ in
                    self.show(SourceCodeViewController(sourceCodeFileName: fileName), sender: nil)
                }
                self.navigationItem.rightBarButtonItem = item
            }
         
         }
         
        ///////////////////////////////////////////////////////////////////////////////////
        
        private var block_key = "UIBarButtonItemBlockKey"
        
        extension UIBarButtonItem {
            
            public var hander: (_ sender: Any?) -> () {
                get {
                    if let target = objc_getAssociatedObject(self, &block_key) {
                        return (target as! _UIBarButtonItemBlockTarget).handler
                    }
                    return { _ in }
                }
                set {
                    let target = _UIBarButtonItemBlockTarget(handler: newValue )
                    objc_setAssociatedObject(self, &block_key, target, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                    self.target = target
                    self.action = #selector(_UIBarButtonItemBlockTarget.invoke(_:))
                }
            }
            
        }
        
        class _UIBarButtonItemBlockTarget: NSObject {
            var handler: (_ sender: Any?) -> ()
            
            init(handler: @escaping (_ sender: Any?) -> ()) {
                self.handler = handler
                super.init()
            }
            
            func invoke(_ sender: Any?) {
                handler(sender)
            }
        }
        ///////////////////////////////////////////////////////////////////////////////////
        */
        
        self.addSourceCodeItem("airdrop");
        
    }
    
    // MARK: UI点击事件
    @IBAction func camera(_ sender: UIButton) {
        self.showImagePickerAction()
    }
    
    @IBAction func album(_ sender: UIButton) {
        self.showImagePickerAction()
    }
    
    @IBAction func send(_ sender: UIButton) {
        let image: UIImage = imageView.image!
        // 打开分享控制器，参数1：需要分享的内容 参数2：[UIActivity]? 自定义图标
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        self.present(controller, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate代理事件
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: NSErrorPointer?, contextInfo: UnsafeRawPointer){
        if(error != nil){
            print("ERROR IMAGE \(error.debugDescription)")
        }
    }
    
    // MARK: 相机授权
    func albumAuthorization(callback: @escaping VoidBlock) {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video);
        switch status {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                granted == true ? callback() : ()
            })
        case .authorized:
            callback()
        default:
            print("No Access")
        }
    }
    
    func showImagePickerAction() {
        let carema = UIAlertAction.init(title: "Carema", style: .default) { (action) in
            self.albumAuthorization(callback: { 
                self.imagePicker(sourceType: .camera)
            })
        }
        let album = UIAlertAction.init(title: "PhotoLibrary", style: .default) { (action) in
            self.albumAuthorization(callback: { 
                self.imagePicker(sourceType: .photoLibrary)
            })
        }
        let save = UIAlertAction.init(title: "SavedPhotosAlbum", style: .default) { (action) in
            self.albumAuthorization(callback: { 
                self.imagePicker(sourceType: .savedPhotosAlbum)
            })
        }
        let cancel = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        
        let alertC = UIAlertController()
        alertC.addAction(carema)
        alertC.addAction(album)
        alertC.addAction(save)
        alertC.addAction(cancel)
        self.present(alertC, animated: true, completion: nil)
    }
    
    // MARK: 打开相机、相册
    func imagePicker(sourceType: UIImagePickerControllerSourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        // 指定类型（相机、相册、图库）
        picker.sourceType = sourceType
        switch sourceType {
            case .camera:
                // 指定所支持的类型，设置只能拍照，不允许录像
                picker.mediaTypes = [kUTTypeImage as String]
                picker.showsCameraControls = true
                picker.allowsEditing = true
            case .photoLibrary:
                break
            case .savedPhotosAlbum:
                break
        }
        self.present(picker, animated: true, completion: nil)
    }

}
