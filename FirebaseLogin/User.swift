//
//  User.swift
//  FirebaseLogin
//
//  Created by bally on 11/24/17.
//  Copyright © 2017 bally. All rights reserved.
//

import Foundation

class User {
    var Username:String?
    var Password:String?
    var Latitude:Double?
    var Longtitude:Double?
    init(user: String, pass: String, lat: Double, long: Double) {
        self.Username = user
        self.Password = pass
        self.Latitude = lat
        self.Longtitude = long
    }
}
