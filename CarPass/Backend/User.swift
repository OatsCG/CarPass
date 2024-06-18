//
//  User.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-18.
//

import Foundation


@Observable class User {
    var userID: UserID
    var username: String
    
    init() {
        // update UserID
        let userID: String? = UserDefaults.standard.string(forKey: "userID")
        if let userID = userID {
            // fetch user data from server with userID
            fetchServerEndpoint(endpoint: "newUser", fetchHash: UUID(), decodeAs: UserID) { (result, returnHash) in
                switch result {
                case .success(let data):
                    if (self.fetchHash == returnHash) {
                        withAnimation {
                            self.serverStatus = data
                        }
                    }
                case .failure(let error):
                    if (self.fetchHash == returnHash) {
                        withAnimation {
                            self.serverStatus = ServerStatus(online: false, om_verify: "")
                        }
                    }
                    print("Error: \(error)")
                }
            }
        } else {
            // create new user from server
            
        }
    }
}
