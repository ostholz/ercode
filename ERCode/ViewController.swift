//
//  ViewController.swift
//  ERCode
//
//  Created by Dong Wang on 10.10.14.
//  Copyright (c) 2014 i2dm. All rights reserved.
//

import UIKit

var user: User?

class ViewController: UIViewController, UIWebViewDelegate {

  var webFormLogged = false
    
  @IBOutlet weak var webview: UIWebView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    SVProgressHUD.show()
    let url = NSURL(string: "\(kServerUrl)\(kUserIndex)")
    let request = NSMutableURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 30.0)

    //      webview.dataDetectorTypes = UIDataDetectorTypes.None
    webview.loadRequest(request)
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    StatusChecker.checkLoginStatus(self)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }

  //
  func webViewDidFinishLoad(webView: UIWebView) {
    // load Username and Password
    if !webFormLogged {
      webFormLogged = true
      let savedCredential = NSUserDefaults.standardUserDefaults().objectForKey("credential") as NSDictionary
      let uname = savedCredential["username"]! as String
      let pword = savedCredential["password"]! as String
      var setUser = "document.getElementById('benutzername1').value='\(uname)';"
      var setPass = "document.getElementById('passwort1').value='\(pword)';"
      var submitForm = "document.forms['Loginform'].submit();"

      webview.stringByEvaluatingJavaScriptFromString(setUser+setPass+submitForm)
    }

    SVProgressHUD.dismiss()
  }


}

