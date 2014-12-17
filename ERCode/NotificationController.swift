//
//  NotificationController.swift
//  ERCode
//
//  Created by Dong Wang on 03.11.14.
//  Copyright (c) 2014 i2dm. All rights reserved.
//

import Foundation

class NotificationController: UIViewController {

  @IBOutlet weak var qrImageView: UIImageView!
  @IBOutlet weak var getQRButton: UIButton!
  @IBOutlet weak var logoutButton: UIButton!
    
  override func viewDidLoad() {
    var qrImage = StatusChecker.getQRImage()
    if qrImage != nil {
      qrImageView.image = qrImage
      getQRButton.alpha = 0.0
    }
  }

  @IBAction func logout() {
    NSUserDefaults.standardUserDefaults().setBool(false, forKey: "remember_me")
  }

  /*
  func initTable() {
      
    let manager = AFHTTPRequestOperationManager()
    
    manager.responseSerializer = AFJSONResponseSerializer() as AFHTTPResponseSerializer
    manager.GET("\(kServerUrl)notifications/3", parameters: nil,
      success: {(operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
        let authenticated = responseObject[kIsAuthenticated] as String
        if authenticated == "true" {
          self.dismissViewControllerAnimated(true, completion: nil)
        } else {

        }
          
      }, failure: {(operation: AFHTTPRequestOperation!, error: NSError!) in
          
      }
    )
    
  } */
    
}