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
      success: { [unowned self] (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
        var response: NSDictionary = responseObject as NSDictionary
        let authenticated = response[kIsAuthenticated] as Bool
        if authenticated {
          //
          var userId = response[kLoginData]![kUID]! as String
          NSUserDefaults.standardUserDefaults().setObject(userId, forKey: "user_id")
          StatusChecker.checkQRCode(userId)

          NSUserDefaults.standardUserDefaults().setBool(self.rememberMe.on, forKey: "remember_me")

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
  

  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }
    
}