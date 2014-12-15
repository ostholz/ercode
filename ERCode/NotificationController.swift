//
//  NotificationController.swift
//  ERCode
//
//  Created by Dong Wang on 03.11.14.
//  Copyright (c) 2014 i2dm. All rights reserved.
//

import Foundation

class NotificationController: UITableViewController {
    
    override func viewDidLoad() {
        
    }
    
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
        
    }
    
}