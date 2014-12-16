//
//  StatusChecker.swift
//  ERCode
//
//  Created by Dong Wang on 15.10.14.
//  Copyright (c) 2014 i2dm. All rights reserved.
//

import Foundation

class StatusChecker {
    class func hasUserId() -> Bool {
       let uid: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("user_id")
        return (uid != nil)
    }
    
    class func remembered() -> Bool {
        let remember: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("remember_me")
        return (remember != nil)
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
    let qrImagePath = documentPath.stringByAppendingString("/wallpaper_\(wallpaperIndex).png")
    let imageData: NSData = UIImagePNGRepresentation(image)
    imageData.writeToFile(qrImagePath, atomically: true)
    NSUserDefaults.standardUserDefaults().setInteger(wallpaperIndex, forKey: "wallpaperIndex")
    NSUserDefaults.standardUserDefaults().synchronize()
  }

  class func getWallpaper(name: NSString) -> UIImage? {
    let documentPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as String
    let imagePath = documentPath.stringByAppendingString("/wallpaper_\(name).png")
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
