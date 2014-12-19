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

  
  override func viewDidLoad() {
      super.viewDidLoad()
  }
  
  
  
  @IBAction func doLogin(sender: AnyObject) {
//    SVProgressHUD.show()
    WebServiceClient.doLogin(username.text, password: password.text, callback: { [unowned self] () in

      NSUserDefaults.standardUserDefaults().setBool(self.rememberMe.on, forKey: "remember_me")
      if self.rememberMe.on {
        println("CALLBACK: save username and password")
        // TODO: save username & password und in keychain
        let userdefault = NSUserDefaults.standardUserDefaults()
        let credential = NSDictionary(objects: [self.username.text, self.password.text], forKeys: ["username", "password"])
        userdefault.setObject(credential, forKey: "credential")
        userdefault.synchronize()
      }
      self.dismissViewControllerAnimated(true, completion: nil)
    })
  }



  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }
    
}