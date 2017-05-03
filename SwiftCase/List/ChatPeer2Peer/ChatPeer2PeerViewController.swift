//
//  ChatPeer2PeerViewController.swift
//  SwiftCase
//
//  Created by wtf on 2017/5/3.
//  Copyright © 2017年 Shepherd. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ChatPeer2PeerViewController: UIViewController, MCBrowserViewControllerDelegate, MCSessionDelegate, UITextFieldDelegate {

    @IBOutlet weak var input: UITextField!
    @IBOutlet weak var textview: UITextView!
    
    // 用于回话显示的用户名称
    var peerID: MCPeerID!
    var session: MCSession!
    // 向用户发出邀请 处理响应，连接助手
    var advertAssistant: MCAdvertiserAssistant!
    var browserC: MCBrowserViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSourceCodeItem("chatpeer2peer")
        
        peerID = MCPeerID(displayName: UIDevice.current.name)
        session = MCSession(peer: peerID)
        advertAssistant = MCAdvertiserAssistant(serviceType: "Chat", discoveryInfo: nil, session: session)
        browserC = MCBrowserViewController(serviceType: "Chat", session: session)
        browserC.delegate = self
        advertAssistant.start()
    }
    
    // MARK: - MCSessionDelegate
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let message = String.init(data: data, encoding: .utf8)!
        DispatchQueue.main.async {
            self.receive(message: message, fromPeer: peerID)
        }
    }
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        let attributedText = NSMutableAttributedString(attributedString: self.textview.attributedText)
        switch state {
        case .connected:
            attributedText.append(NSAttributedString(string: "\(peerID) connected", attributes: [NSForegroundColorAttributeName: UIColor.green]))
        case .connecting:
            attributedText.append(NSAttributedString(string: "\(peerID) connecting", attributes: [NSForegroundColorAttributeName: UIColor.orange]))
        case .notConnected:
            attributedText.append(NSAttributedString(string: "\(peerID) disconnected", attributes: [NSForegroundColorAttributeName: UIColor.red]))
        }
        input.attributedText = attributedText
    }
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("Receiving \(peerID) \(resourceName) \(progress.fractionCompleted)")
    }
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
        print("Finish \(peerID) \(resourceName)")
    }
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func receive(message: String, fromPeer peerID: MCPeerID) {
        let attributedText = NSMutableAttributedString(attributedString: self.textview.attributedText)
        if peerID == self.peerID {
            attributedText.append(NSAttributedString(string: "\n" + message, attributes: [NSForegroundColorAttributeName: UIColor.blue]))
        } else {
            attributedText.append(NSAttributedString(string: "\n" + peerID.displayName + ":" + message, attributes: [NSForegroundColorAttributeName: UIColor.gray]))
        }
        self.textview.attributedText = attributedText
    }
    
    
    // MARK: - MCBrowserViewControllerDelegate
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismissBrowser()
    }
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismissBrowser()
    }
    func dismissBrowser() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        input.resignFirstResponder()
        return true
    }
    // 发送消息，将输入框的内容显示到界面中
    func sendMessage() {
        guard session.connectedPeers.count > 0 else {
            return
        }
        let data = input.text!.data(using: .utf8)
        do {
            try! session.send(data!, toPeers: session.connectedPeers, with: .reliable)
        }
        receive(message: input.text!, fromPeer: peerID)
    }
    
    // 搜索蓝牙设备
    @IBAction func browser(_ sender: UIButton) {
        self.present(browserC, animated: true, completion: nil)
    }
    
    @IBAction func sendDoc(_ sender: UIButton) {
        guard session.connectedPeers.count > 0 else {
            return
        }
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "chatpeer2peer", ofType: ".html")!)
        for peerID in session.connectedPeers {
            session.sendResource(at: url, withName: "chatpeertopeer.html", toPeer: peerID, withCompletionHandler: { (error) in
                if error != nil {
                    print("Send Resource Error:" + error.debugDescription)
                }
            })
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if input.isFirstResponder {
            input.resignFirstResponder()
        }
        view.endEditing(true)
    }

}
