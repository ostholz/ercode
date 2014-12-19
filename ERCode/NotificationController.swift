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
  @IBOutlet weak var erCodeLabel: UILabel!
  @IBOutlet weak var summaryLabel: UILabel!
  @IBOutlet weak var saveQRButton: UIButton!

  @IBOutlet weak var guideButton: UIButton!

  override func viewDidLoad() {

    let ercode = NSUserDefaults.standardUserDefaults().objectForKey("ercode") as? String
    if ercode != nil {
      erCodeLabel.text = ercode
    }

    if !StatusChecker.checkQRCode() {
      let uid = NSUserDefaults.standardUserDefaults().objectForKey("user_id") as? NSString
      if uid != nil {
        StatusChecker.downloadQRCode(uid!, callback: {(img: UIImage) in
          self.qrImageView.image = img
          println("download QR Code callback called")
        })
      }

//      StatusChecker.downloadQRCode(uid, callback: nil)
    }
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    StatusChecker.checkLoginStatus(self)
  }

  @IBAction func logout() {
    NSUserDefaults.standardUserDefaults().setBool(false, forKey: "remember_me")
    loggedIn = false

    StatusChecker.checkLoginStatus(self)
  }

  @IBAction func saveQRintoPhotos(sender: AnyObject) {
    let qrImage = StatusChecker.getQRImage()
    UIImageWriteToSavedPhotosAlbum(qrImage, nil, nil, nil)
  }

  @IBAction func showGuide(sender: AnyObject) {

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