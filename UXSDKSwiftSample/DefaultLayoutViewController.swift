//
//  DefaultLayoutViewController.swift
//  UXSDKSwiftSample
//
//  Copyright © 2021 RIIS. All rights reserved.
//

import UIKit
import DJIUXSDK

let ProductCommunicationServiceStateDidChange = "ProductCommunicationServiceStateDidChange"

// We subclass the DUXRootViewController to inherit all its behavior and add
// a couple of widgets in the storyboard.
class DefaultLayoutViewController: DUXDefaultLayoutViewController, DJISDKManagerDelegate {
    
    fileprivate let useDebugMode = true
    fileprivate let bridgeIP = "192.168.128.169"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DJISDKManager.registerApp(with: self)
    }
    
    //MARK: - Start Connecting to Product
    open func connectToProduct() {
        print("Connecting to product...")
        if useDebugMode {
            DJISDKManager.enableBridgeMode(withBridgeAppIP: bridgeIP)
        } else {
            let startedResult = DJISDKManager.startConnectionToProduct()
            
            if startedResult {
                print("Connecting to product started successfully!")
            } else {
                print("Connecting to product failed to start!")
            }
        }
    }
    
    //MARK: - DJISDKManagerDelegate
    func appRegisteredWithError(_ error: Error?) {
        if let error = error {
            print("Error Registering App: \(error.localizedDescription)")
        } else if useDebugMode {
            DJISDKManager.enableBridgeMode(withBridgeAppIP: bridgeIP)
        } else {
            DJISDKManager.startConnectionToProduct()
        }
    }
    
    func productConnected(_ product: DJIBaseProduct?) {
        if product != nil {
            print("Connection to new product succeeded!")
        }
    }

    func productDisconnected() {
        print("Disconnected from product!");
    }
    
    func didUpdateDatabaseDownloadProgress(_ progress: Progress) { }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent;
    }
}
