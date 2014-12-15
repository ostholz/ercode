//
//  PetientData.swift
//  ERCode
//
//  Created by Dong Wang on 16.10.14.
//  Copyright (c) 2014 i2dm. All rights reserved.
//

import Foundation

struct PatientData {
    var blood_type = ""
    var allergies = ""
    var medical_conditions = ""
    var medical_notes = ""
    var medications = ""
    var emergency_contacts = [Contact]()
    var weight = ""
    var height = ""
    var ercode = ""
    var organ_donor = ""
}