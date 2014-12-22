//
//  StatusChecker.swift
//  ERCode
//
//  Created by Dong Wang on 15.10.14.
//  Copyright (c) 2014 i2dm. All rights reserved.
//

import Foundation

// global variable
var savedWallpaper: NSMutableArray?

class StatusChecker {

  class func checkLoginStatus(controller: UIViewController) {
    if !StatusChecker.remembered() {
      if !loggedIn {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewControllerWithIdentifier("LoginVC") as UIViewController
        controller.presentViewController(loginVC, animated: false, completion: nil)
      }
    }
  }


  class func hasUserId() -> Bool {
     let uid: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("user_id")
      return (uid != nil)
  }
  
  class func remembered() -> Bool {
    let remember = NSUserDefaults.standardUserDefaults().objectForKey("remember_me") as? Bool
    if remember != nil {
      return remember!
    } else {
      return false
    }
  }

  class func getQRImage() -> UIImage? {
    let documentPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as String
    let qrImagePath = documentPath.stringByAppendingString("/qrCode.png")
    let filemanager = NSFileManager.defaultManager()
    if filemanager.fileExistsAtPath(qrImagePath) {
      let imageData = NSData(contentsOfFile: qrImagePath, options: nil, error: nil)
      let image = UIImage(data: imageData!)
      return image!
    } else {
      return nil
    }
  }

  class func checkQRCode() -> Bool {
    let documentPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as String
    var filemanager = NSFileManager.defaultManager()
    let qrImagePath = documentPath.stringByAppendingString("/qrCode.png")
    if filemanager.fileExistsAtPath(qrImagePath) {
      return true
    } else {
//      getQRCode(userId)
      return false
    }
  }

  class func downloadQRCode(userId: String, callback: ((image: UIImage) -> Void)?) {
    let documentPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as String
    let qrImagePath = documentPath.stringByAppendingString("/qrCode.png")
    dispatch_async(dispatch_get_main_queue()){
      // download the QRCode
      let manager = AFHTTPRequestOperationManager()
      manager.requestSerializer.setValue(wsSessionid, forHTTPHeaderField: kPHPSession)
      manager.GET("\(kServerUrl)user/data/\(userId)", parameters: nil,
        success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
          let response = responseObject as NSDictionary
          let base64str = response["Data"]?["qrcode"]! as String
          // save QR Code
          let imageData = NSData(base64EncodedString: base64str, options:nil)
          imageData?.writeToFile(qrImagePath, atomically: true)

          // save ER Code
          let erCodeStr = response["Data"]?["ercode"] as NSString

          println("success download QR Code")
          NSUserDefaults.standardUserDefaults().setObject(erCodeStr, forKey: "ercode")
          if callback != nil {
            let img = UIImage(data: imageData!)
            callback!(image: img!)
          }

        },
        failure: {(operation: AFHTTPRequestOperation!, error: NSError!) in
          SVProgressHUD.showErrorWithStatus("Fehler beim unterladen QR Bild")
          println("errow with download QR Code")
        }
      )

    }

  }


  class func saveQRImage(image: UIImage!) {
    let documentPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as String
    let qrImagePath = documentPath.stringByAppendingString("/qrCode.png")
    let imageData: NSData = UIImagePNGRepresentation(image)
    imageData.writeToFile(qrImagePath, atomically: true)
  }

  class func saveWallpaper(image: UIImage!) {
    var wallpaperIndex = NSUserDefaults.standardUserDefaults().integerForKey("wallpaperIndex")
    wallpaperIndex++

    let documentPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as String

    // Original Image
    let wpName = "wallpaper_\(wallpaperIndex).png"
    let wpImagePath = documentPath.stringByAppendingString("/\(wpName)")
    var imageData: NSData = UIImagePNGRepresentation(image)
    imageData.writeToFile(wpImagePath, atomically: true)

    // Thumbnail Image
    let thumbSize = CGSizeMake(kWPCellLength, kWPCellLength)
    UIGraphicsBeginImageContext(thumbSize)

    var dyHeight = image.size.height * kWPCellLength / image.size.width


    image.drawInRect(CGRectMake(0, (dyHeight - kWPCellLength) / -2 , kWPCellLength, dyHeight))
    var thumbImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    let thumbName = "thumb_\(wallpaperIndex).png"
    let thumbImagePath = documentPath.stringByAppendingString("/\(thumbName)")
    imageData = UIImagePNGRepresentation(thumbImage)
    imageData.writeToFile(thumbImagePath, atomically: true)

    // update global variable savedWallpaper
    var imgDict: NSDictionary = NSDictionary(objects: [wpName , thumbName], forKeys: [kKeyWallpapername, kKeyThumbname] )
    savedWallpaper?.insertObject(imgDict, atIndex: 0)

    NSUserDefaults.standardUserDefaults().setObject(savedWallpaper, forKey: "wallpapers")
    NSUserDefaults.standardUserDefaults().setInteger(wallpaperIndex, forKey: "wallpaperIndex")
    NSUserDefaults.standardUserDefaults().synchronize()
  }

  class func getWallpaper(name: NSString) -> UIImage? {
    let documentPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as String
    let imagePath = documentPath.stringByAppendingString("/\(name)")
    let filemanager = NSFileManager.defaultManager()
    if filemanager.fileExistsAtPath(imagePath) {
      let imageData = NSData(contentsOfFile: imagePath)
      let image = UIImage(data: imageData!)
      return image!
    } else {
      return nil
    }
  }

}
