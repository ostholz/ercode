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

    
    @IBOutlet weak var webview: UIWebView!
    
    override func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view, typically from a nib.
      if user == nil {
          user = User.dummyUser()
      }
        
    }
    
    override func viewDidAppear(animated: Bool) {
      super.viewDidAppear(animated)

      let url = NSURL(string: "\(kServerUrl)\(kUserIndex)")
      let request = NSMutableURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 30.0)

      webview.dataDetectorTypes = UIDataDetectorTypes.None
      webview.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

