//
//  User.swift
//  ERCode
//
//  Created by Dong Wang on 16.10.14.
//  Copyright (c) 2014 i2dm. All rights reserved.
//

import Foundation

class User: NSObject, NSCoding {
    var uid = ""
    var loginname = ""
    var password = ""
    var ercode = ""
    var firstname = ""
    var lastname = ""
    var birthday = ""
    var gender = ""
    var addresses = [Address]()
    var contacts = [Contact]()
    
    override init(){
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        aDecoder.decodeObjectForKey("thisUser") as? User
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self, forKey: "thisUser")
    }
    
    func save() {
        let data = NSKeyedArchiver.archivedDataWithRootObject(self)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: "savedUser")
    }
    
    class func loadUser() -> User? {
        if let data = NSUserDefaults.standardUserDefaults().objectForKey("savedUser") as? NSData {
            return NSKeyedUnarchiver.unarchiveObjectWithData(data) as? User
        }
        
        return nil
    }
    
    class func dummyUser() -> User {
        var u = User()
        u.firstname = "Little"
        u.lastname = "Apple"
        u.birthday = "01.01.1960"
        u.gender = "1"
        
        return u
    }
    
    
    

}