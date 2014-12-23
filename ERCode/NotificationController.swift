//
//  NotificationController.swift
//  ERCode
//
//  Created by Dong Wang on 03.11.14.
//  Copyright (c) 2014 i2dm. All rights reserved.
//

import Foundation

class NotificationController: UIViewController, UITextFieldDelegate {

  @IBOutlet weak var qrImageView: UIImageView!
  @IBOutlet weak var getQRButton: UIButton!
  @IBOutlet weak var logoutButton: UIButton!
  @IBOutlet weak var erCodeLabel: UILabel!
  @IBOutlet weak var summaryLabel: UILabel!
  @IBOutlet weak var saveQRButton: UIButton!

  @IBOutlet weak var guideButton: UIButton!
  @IBOutlet weak var testPhoneNr: UITextField!

  override func viewDidLoad() {

  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    StatusChecker.checkLoginStatus(self)

    // TODO: This will only run at the first time
    if !StatusChecker.checkQRCode() {
      let uid = NSUserDefaults.standardUserDefaults().objectForKey("user_id") as? NSString
      if uid != nil {
        StatusChecker.downloadQRCode(uid!, callback: {[unowned self] (img: UIImage) in
          self.qrImageView.image = img

          let ercode = NSUserDefaults.standardUserDefaults().objectForKey("ercode") as? String
          if ercode != nil {
            self.erCodeLabel.text = ercode
          }
          // set Text
          let bloodIndex = userData![kBloodType] as Int
          let showBloodType = userData![kShowBloodType] as Int
          let bloodType = showBloodType == 1 ? self.getBloodType(bloodIndex) : ""
          self.summaryLabel.text = "\(userData?[kShowOnApp]) \n \(bloodType)"
        })
      }

      //      StatusChecker.downloadQRCode(uid, callback: nil)
    } else {
      self.qrImageView.image = StatusChecker.getQRImage()
    }


    if userData != nil {
      setGUIElement()
    } else if (loggedIn) {
      WebServiceClient.getUserData({[unowned self] in
        self.setGUIElement()
      } )
    }


  }

  func setGUIElement() {
    // set Text
    let bloodIndex = userData![kBloodType] as String
    let showBloodType = userData![kShowBloodType] as String
    let bloodType = showBloodType == "1" ? self.getBloodType(bloodIndex.toInt()!) : ""
    let txtToShow = userData![kShowOnApp] as String
    self.summaryLabel.text = "\(txtToShow) \nBlutgruppe \(bloodType)"
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

  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    testTelephoneNum = textField.text
    return false
  }

  private func getBloodType(index: Int) -> String {
    return [" ", "0+", "0-", "A+", "A-", "B-", "B+", "AB+", "AB-"][index]
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