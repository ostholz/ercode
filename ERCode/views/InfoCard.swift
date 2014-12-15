//
//  InfoCard.swift
//  ERCode
//
//  Created by Dong Wang on 20.10.14.
//  Copyright (c) 2014 i2dm. All rights reserved.
//

import Foundation

class InfoCard: UIView {
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    override init() {
        super.init()
    }
    
    override init(frame aRect: CGRect) {
        super.init(frame: aRect)
        
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    
}