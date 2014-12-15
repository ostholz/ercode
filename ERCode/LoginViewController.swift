//
//  LoginViewController.swift
//  ERCode
//
//  Created by Dong Wang on 16.10.14.
//  Copyright (c) 2014 i2dm. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var rememberMe: UISwitch!
    
    var user = User();

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    @IBAction func doLogin(sender: AnyObject) {
        SVProgressHUD.show()
        let manager = AFHTTPRequestOperationManager()
        // default responseSerializer ist JSON Serializer
//        manager.responseSerializer = AFJSONResponseSerializer() as AFHTTPResponseSerializer
        manager.requestSerializer.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        manager.POST(
            "\(kServerUrl)login/",
            parameters: ["username": username.text, "password": password.text],
            success: {(operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                var response: NSDictionary = responseObject as NSDictionary
                let authenticated = response[kIsAuthenticated] as Bool
                if authenticated {
                    if self.rememberMe.on {
                        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "remember_me")
                        var userId = response[kLoginData]![kUID]! as String
                        NSUserDefaults.standardUserDefaults().setObject(userId, forKey: "user_id")
                        self.checkQRCode(userId)
                    }
                    SVProgressHUD.dismiss()
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                  SVProgressHUD.showErrorWithStatus("Login Failed")
                }
                
            },
            
            failure: {(operation: AFHTTPRequestOperation!, error: NSError!) in
                SVProgressHUD.dismiss()
            }
        )
    }
    
    func checkQRCode(userId: String) {

        dispatch_async(dispatch_get_main_queue()){
            var filemanager = NSFileManager.defaultManager()
            let documentPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as String
            let qrImagePath = documentPath.stringByAppendingString("/qrCode.png")
            if !filemanager.fileExistsAtPath(qrImagePath) {
                // download the QRCode
                let manager = AFHTTPRequestOperationManager()
                manager.GET("\(kServerUrl)qrcode/\(userId)", parameters: nil,
                    success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                      let response = responseObject as NSDictionary
                      let base64str = response["Data"]!["qrcode"]! as String
                      let imageData = NSData(base64EncodedString: base64str, options:nil)
                      imageData?.writeToFile(qrImagePath, atomically: true)
                      println("success get QR Image")
                    },
                    failure: {(operation: AFHTTPRequestOperation!, error: NSError!) in
                            println("problem get QR Code")
                    }
                )
            }
        }
    }

  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }
    
}