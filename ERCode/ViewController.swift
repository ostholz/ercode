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
    var loginShowed_temp = false
    
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

      if !StatusChecker.remembered() {
        if  !loginShowed_temp {
          let storyboard = UIStoryboard(name: "Main", bundle: nil)
          let loginVC = storyboard.instantiateViewControllerWithIdentifier("LoginVC") as UIViewController
          self.presentViewController(loginVC, animated: false, completion: nil)
          loginShowed_temp = true
        }
      }
        
      let url = NSURL(string: "\(kServerUrl)\(kUserInfo)")
        let request = NSURLRequest(URL: url!)
        webview.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

