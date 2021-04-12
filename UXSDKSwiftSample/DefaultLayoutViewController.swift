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
    // We are going to add focus adjustment to the default view.
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerWithProduct()
    }
    
    //MARK: - Start Registration
    func registerWithProduct() {
        guard
            let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path) as? Dictionary<String, AnyObject>,
            let appKey = dict["DJISDKAppKey"] as? String,
            appKey != "PASTE_YOUR_DJI_APP_KEY_HERE"
        else {
                print("\n<<<ERROR: Please add DJI App Key in Info.plist after registering as developer>>>\n")
                return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            NSLog("Registering Product with registration ID: \(appKey)")
            DJISDKManager.registerApp(with: self)
        }
    }
    
    //MARK: - Start Connecting to Product
    open func connectToProduct() {
        NSLog("Connecting to product...")
        let startedResult = DJISDKManager.startConnectionToProduct()
        
        if startedResult {
            NSLog("Connecting to product started successfully!")
        } else {
            NSLog("Connecting to product failed to start!")
        }
    }
    
//    public func disconnectProduct() {
//        DJISDKManager.stopConnectionToProduct()
//
//        // This is a little cheat because sdkmanager is not properly disconnecting the product.
//        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "ProductCommunicationManagerStateDidChange")))
//    }
    
    //MARK: - DJISDKManagerDelegate
    func appRegisteredWithError(_ error: Error?) {
        if error == nil {
            self.connectToProduct()
        } else {
            NSLog("Error Registrating App: \(String(describing: error))")
        }
    }
    
    func productConnected(_ product: DJIBaseProduct?) {
        if product != nil {
            NSLog("Connection to new product succeeded!")
        }
    }

    func productDisconnected() {
        NSLog("Disconnected from product!");
    }
    
    func didUpdateDatabaseDownloadProgress(_ progress: Progress) {
        print("didUpdateDatabaseDownloadProgress")
    }
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent;
    }
}
