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
    var myColor: CustomColor = .blue
    var car: CarID? = nil
    var carUsers: [FetchedUser] = []
    var whohasthecar: FetchedUser? = nil
    var pendingAlerts: [PendingAlert] = []
    var confirmedAlerts: [ConfirmedAlert] = []
    var outdatedAlerts: [ConfirmedAlert] = []
    
    private var isFetchingCar: Bool = false
    var isPushUpdatingInfo: Bool = false
    
    private var syncedTimer: Timer? = nil
    
    init() {
        // update UserID
        let userID: String? = UserDefaults.standard.string(forKey: "userID")
        if let userID = userID {
            // fetch user data from server with userID
            fetchServerEndpoint(endpoint: "getuser?id=\(userID)", fetchHash: UUID(), decodeAs: FetchedUser?.self) { (result, returnHash) in
                if (self.isPushUpdatingInfo) {
                    return
                }
                switch result {
                case .success(let data):
                    if let data = data {
                        self.userID = data.id
                        self.username = data.name
                        self.car = data.car
                        withAnimation {
                            self.fetchStatus = .success
                        }
                    } else {
                        fetchServerEndpoint(endpoint: "newuser", fetchHash: UUID(), decodeAs: UserID.self) { (result, returnHash) in
                            if (self.isPushUpdatingInfo) {
                                return
                            }
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
                if (self.isPushUpdatingInfo) {
                    return
                }
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
        
        // start fetch timer
        self.syncedTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
            self.fetchLoop()
        }
    }
    
    func fetchLoop() {
        self.fetchCar()
    }
    
    func fetchCar() {
        if self.isFetchingCar {
            return
        }
        self.isFetchingCar = true
        if let carid = self.car {
            fetchServerEndpoint(endpoint: "getcar?id=\(carid)", fetchHash: UUID(), decodeAs: FetchedCar.self) { (result, returnHash) in
                switch result {
                case .success(let data):
                    self.isFetchingCar = false
                    withAnimation {
                        self.whohasthecar = FetchedUser(name: data.whohasusername, id: data.whohas, color: data.whohasusercolor)
                    }
                    
                    Task.detached { [weak self] in
                        // Get Pending Ranges
                        var tempPendingAlerts: [PendingAlert] = []
                        for pendingRange in data.pendingRanges {
                            let rangeDescription: String = epochToDescription(epoch: pendingRange.start)
                            let rangeRelativeDescription: String = epochToRelativeDescription(epoch: pendingRange.start)
                            tempPendingAlerts.append(PendingAlert(id: pendingRange.id, userID: pendingRange.user, name: pendingRange.username, reason: pendingRange.reason, range: rangeDescription, rangeRelative: rangeRelativeDescription, color: strtocc(pendingRange.usercolor)))
                        }
                        
                        // Get Confirmed Ranges
                        var tempConfirmedAlerts: [ConfirmedAlert] = []
                        var tempOutdatedAlerts: [ConfirmedAlert] = []
                        let sortedRanges: [FetchedConfirmedRange] = data.confirmedRanges.sorted(by: { $0.start > $1.start })
                        let currentDate: Date = Date()
                        for confirmedRange in sortedRanges {
                            let rangeDescription: String = epochToDescription(epoch: confirmedRange.start)
                            let rangeRelativeDescription: String = epochToRelativeDescription(epoch: confirmedRange.start)
                            var mustBring: Bool = false
                            if (Int(currentDate.timeIntervalSince1970) > confirmedRange.start) { // if range start date is before now
                                tempOutdatedAlerts.append(ConfirmedAlert(id: confirmedRange.id, userID: confirmedRange.user, name: confirmedRange.username, reason: confirmedRange.reason, range: rangeDescription, rangeRelative: rangeRelativeDescription, color: strtocc(confirmedRange.usercolor), mustBring: mustBring))
                            } else { // if after now
                                if (data.whohas == self?.userID && tempConfirmedAlerts.isEmpty) { // if I have the car and this range is next
                                    mustBring = true
                                }
                                tempConfirmedAlerts.append(ConfirmedAlert(id: confirmedRange.id, userID: confirmedRange.user, name: confirmedRange.username, reason: confirmedRange.reason, range: rangeDescription, rangeRelative: rangeRelativeDescription, color: strtocc(confirmedRange.usercolor), mustBring: mustBring))
                            }
                        }
                        DispatchQueue.main.async { [weak self, tempPendingAlerts, tempOutdatedAlerts, tempConfirmedAlerts] in
                            withAnimation {
                                self?.pendingAlerts = tempPendingAlerts
                                self?.outdatedAlerts = tempOutdatedAlerts
                                self?.confirmedAlerts = tempConfirmedAlerts
                            }
                        }
                    }
                    
                    
                case .failure(_):
                    self.isFetchingCar = false
                }
            }
        }
    }
    
    func update_color(to color: CustomColor) {
        self.isPushUpdatingInfo = true
        fetchServerEndpoint(endpoint: "updatecolor?userid=UUID&color=\(cctostr(color))", fetchHash: UUID(), decodeAs: UserID.self) { (result, returnHash) in
            switch result {
            case .success(let data):
                self.isPushUpdatingInfo = false
            case .failure(let error):
                print(error)
                self.isPushUpdatingInfo = false
            }
        }
    }
    
}

enum FetchStatus {
    case waiting, success, failed
}
