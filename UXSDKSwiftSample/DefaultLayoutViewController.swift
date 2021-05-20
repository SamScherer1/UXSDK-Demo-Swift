//
//  DefaultLayoutViewController.swift
//  UXSDK Sample
//
//  MIT License
//
//  Copyright © 2018-2020 DJI
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
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
