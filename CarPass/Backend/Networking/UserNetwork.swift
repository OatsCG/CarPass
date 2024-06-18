//
//  Networking.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-18.
//

import Foundation
import SwiftUI

@Observable class UserNetworkModel {
    var isFetchingUser: Bool = false
    var fetchHash: UUID = UUID()
    
    func runFetch(with ipAddress: String? = nil) {
        self.isFetchingUser = true
        self.fetchHash = UUID()
        
        fetchServerEndpoint(endpoint: "newUser", fetchHash: self.fetchHash, decodeAs: NewUserModel) { (result, returnHash) in
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
    }
}
