//
//  WebServiceClient.swift
//  ERCode
//
//  Created by Dong Wang on 19.12.14.
//  Copyright (c) 2014 i2dm. All rights reserved.
//

import Foundation

/*
  glabel Variable
*/

var wsSessionid: String?
var loggedIn = false

class WebServiceClient {

  class func doLogin(username: String, password: String, callback: (() -> Void)?) {
    let manager = AFHTTPRequestOperationManager()
    // default responseSerializer ist JSON Serializer
    //        manager.responseSerializer = AFJSONResponseSerializer() as AFHTTPResponseSerializer
    manager.requestSerializer.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    manager.POST(
      "\(kServerUrl)login/",
      parameters: ["username": username, "password": password],
      success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
        var response: NSDictionary = responseObject as NSDictionary
        let authenticated = response[kIsAuthenticated] as Bool
        if authenticated {
          //
          loggedIn = true
          var userId = response[kLoginData]![kUID]! as String
          wsSessionid = response[kCookie]![kPHPSession]! as String

          println("get userId: \(userId) and sessionId: \(wsSessionid)")
          println("downloading QR Code")

          NSUserDefaults.standardUserDefaults().setObject(userId, forKey: "user_id")
          if !StatusChecker.checkQRCode() {
            // download QR Image
            //            self.downloadQRCode(userId)
            StatusChecker.downloadQRCode(userId, nil)
          }

          if callback != nil {
            callback!()
          }

        } else {
          SVProgressHUD.showErrorWithStatus("Login fehlergeschlagen")
        }

      },

      failure: {(operation: AFHTTPRequestOperation!, error: NSError!) in
//        SVProgressHUD.dismiss()
      }
    )


  }
}
