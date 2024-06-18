//
//  User.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-18.
//

import Foundation
import SwiftUI


@Observable class User {
    var fetchStatus: FetchStatus = .waiting
    var userID: UserID = ""
    var username: String = ""
    var car: CarID? = nil
    
    init() {
        // update UserID
        let userID: String? = UserDefaults.standard.string(forKey: "userID")
        if let userID = userID {
            // fetch user data from server with userID
            fetchServerEndpoint(endpoint: "getuser?id=\(userID)", fetchHash: UUID(), decodeAs: FetchedUser.self) { (result, returnHash) in
                switch result {
                case .success(let data):
                    self.userID = data.id
                    self.username = data.name
                    self.car = data.car
                    withAnimation {
                        self.fetchStatus = .success
                    }
                case .failure(let error):
                    print(error)
                    withAnimation {
                        self.fetchStatus = .failed
                    }
                }
            }
        } else {
            // create new user from server
            fetchServerEndpoint(endpoint: "newuser", fetchHash: UUID(), decodeAs: UserID.self) { (result, returnHash) in
                switch result {
                case .success(let data):
                    self.userID = data
                    self.username = "username"
                    UserDefaults.standard.setValue(data, forKey: "userID")
                    withAnimation {
                        self.fetchStatus = .success
                    }
                case .failure(let error):
                    print(error)
                    withAnimation {
                        self.fetchStatus = .failed
                    }
                }
            }
        }
    }
}

enum FetchStatus {
    case waiting, success, failed
}
