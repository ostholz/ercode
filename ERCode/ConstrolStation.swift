//
//  ConstrolStation.swift
//  ERCode
//
//  Created by Dong Wang on 11.12.14.
//  Copyright (c) 2014 i2dm. All rights reserved.
//

import Foundation

class ControlStation {
  var name : String!
  var telefonNumber: String!
  var lat: Double!
  var lng: Double!
  var distance: Double?

  init(name: String, telefon: String, lat: Double, lng: Double) {
    self.name = name;
    self.telefonNumber = telefon;
    self.lat = lat;
    self.lng = lng;
  }
  
}