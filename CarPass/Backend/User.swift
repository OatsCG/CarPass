//
//  User.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-18.
//

import Foundation


@Observable class User {
    var userID: String
    var username: String
    
    init() {
        // update UserID
        let userID: String? = UserDefaults.standard.string(forKey: "userID")
        if let userID = userID {
            // fetch user data from server with userID
            
        } else {
            // create new user from server
            
        }
    }
}
