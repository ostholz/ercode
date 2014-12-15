//
//  StationCell.swift
//  ERCodeScan
//
//  Created by Dong Wang on 30.11.14.
//  Copyright (c) 2014 i2dm gmbh. All rights reserved.
//

import UIKit

class StationCell : UITableViewCell {

  @IBOutlet weak var stationName: UILabel!
  @IBOutlet weak var stationNumber: UILabel!
  @IBOutlet weak var distance: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }


}