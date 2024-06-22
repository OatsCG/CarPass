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
    var carname: String = ""
    var carUsers: [FetchedCarUser] = []
    var whohasthecar: FetchedUser? = nil
    var carInvites: [CarID] = []
    var pendingAlerts: [PendingAlert] = []
    var confirmedAlerts: [ConfirmedAlert] = []
    var outdatedAlerts: [ConfirmedAlert] = []
    
    private var isFetchingCar: Bool = false
    var isPushUpdatingInfo: Bool = false
    var isPushUpdatingCar: Bool = false
    
    private var syncedTimer: Timer? = nil
    var lastUpdated: Date = Date()
    
    init() {
        fetchUser() { boola in
            if boola {
                self.lastUpdated = Date()
            }
        }
        
        // start fetch timer
        self.syncedTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in // should be 0.3
            self.fetchLoop()
        }
    }
    
    func fetchLoop() {
        if self.isFetchingCar {
            return
        }
        self.isFetchingCar = true
        
        self.fetchUser() { boola in
            self.fetchCar() { boolb in
                self.fetchUsers() { boolc in
                    self.fetchPendingCarInvites() { boold in
                        if boola && boolb && boolc && boold {
                            self.lastUpdated = Date()
                        }
                        self.isFetchingCar = false
                    }
                }
            }
        }
    }
    
    func fetchUser(completion: @escaping (Bool) -> Void) {
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
                        withAnimation {
                            self.userID = data.id
                            self.username = data.name
                            self.myColor = strtocc(data.color)
                            self.car = data.car
                        }
                        withAnimation {
                            self.fetchStatus = .success
                        }
                        completion(true)
                    } else {
                        fetchServerEndpoint(endpoint: "newuser", fetchHash: UUID(), decodeAs: UserID.self) { (result, returnHash) in
                            if (self.isPushUpdatingInfo) {
                                completion(true)
                                return
                            }
                            switch result {
                            case .success(let data):
                                self.userID = data
                                self.username = "Username"
                                UserDefaults.standard.setValue(data, forKey: "userID")
                                withAnimation {
                                    self.fetchStatus = .success
                                }
                                completion(true)
                            case .failure(let error):
                                withAnimation {
                                    self.fetchStatus = .failed
                                }
                                completion(false)
                            }
                        }
                    }
                case .failure(let error):
                    withAnimation {
                        self.fetchStatus = .failed
                    }
                    completion(true)
                }
            }
        } else {
            // create new user from server
            fetchServerEndpoint(endpoint: "newuser", fetchHash: UUID(), decodeAs: UserID.self) { (result, returnHash) in
                if (self.isPushUpdatingInfo) {
                    completion(true)
                    return
                }
                switch result {
                case .success(let data):
                    self.userID = data
                    self.username = "Username"
                    UserDefaults.standard.setValue(data, forKey: "userID")
                    withAnimation {
                        self.fetchStatus = .success
                    }
                    completion(true)
                case .failure(let error):
                    withAnimation {
                        self.fetchStatus = .failed
                    }
                    completion(false)
                }
            }
        }
    }
    
    func fetchCar(completion: @escaping (Bool) -> Void) {
        if let carid = self.car {
            fetchServerEndpoint(endpoint: "getcar?id=\(carid)", fetchHash: UUID(), decodeAs: FetchedCar.self) { (result, returnHash) in
                switch result {
                case .success(let data):
                    withAnimation {
                        self.whohasthecar = FetchedUser(name: data.whohasusername, id: data.whohas, color: data.whohasusercolor)
                        self.carname = data.name
                    }
                    
                    Task.detached { [weak self] in
                        // Get Pending Ranges
                        var tempPendingAlerts: [PendingAlert] = []
                        for pendingRange in data.pendingRanges {
                            
                            let rangeDescription: String = epochToDescription(epoch: pendingRange.start)
                            let rangeRelativeDescription: String = epochToRelativeDescription(epoch: pendingRange.start)
                            tempPendingAlerts.append(PendingAlert(id: pendingRange.id, userID: pendingRange.user, name: pendingRange.username, reason: pendingRange.reason, rangeStart: Date(timeIntervalSince1970: TimeInterval(pendingRange.start)), rangeEnd: Date(timeIntervalSince1970: TimeInterval(pendingRange.end)), rangeDescription: rangeDescription, rangeRelativeDescription: rangeRelativeDescription, color: strtocc(pendingRange.usercolor), accepted: pendingRange.accepted))
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
                                tempOutdatedAlerts.append(ConfirmedAlert(id: confirmedRange.id, userID: confirmedRange.user, name: confirmedRange.username, reason: confirmedRange.reason, rangeStart: Date(timeIntervalSince1970: TimeInterval(confirmedRange.start)), rangeEnd: Date(timeIntervalSince1970: TimeInterval(confirmedRange.end)), rangeDescription: rangeDescription, rangeRelativeDescription: rangeRelativeDescription, color: strtocc(confirmedRange.usercolor), mustBring: mustBring))
                            } else { // if after now
                                if (data.whohas == self?.userID && tempConfirmedAlerts.isEmpty) { // if I have the car and this range is next
                                    mustBring = true
                                }
                                tempConfirmedAlerts.append(ConfirmedAlert(id: confirmedRange.id, userID: confirmedRange.user, name: confirmedRange.username, reason: confirmedRange.reason, rangeStart: Date(timeIntervalSince1970: TimeInterval(confirmedRange.start)), rangeEnd: Date(timeIntervalSince1970: TimeInterval(confirmedRange.end)), rangeDescription: rangeDescription, rangeRelativeDescription: rangeRelativeDescription, color: strtocc(confirmedRange.usercolor), mustBring: mustBring))
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
                    completion(true)
                case .failure(_):
                    completion(false)
                }
            }
        } else {
            completion(true)
        }
    }
    
    func fetchUsers(completion: @escaping (Bool) -> Void) {
        if let carid = self.car {
            fetchServerEndpoint(endpoint: "getusers?carid=\(carid)", fetchHash: UUID(), decodeAs: FetchedCarUsers.self) { (result, returnHash) in
                if (self.isPushUpdatingInfo || self.isPushUpdatingCar) {
                    completion(true)
                    return
                }
                switch result {
                case .success(let data):
                    withAnimation {
                        self.carUsers = data.users
                    }
                    completion(true)
                case .failure(let error):
                    completion(false)
                }
            }
        }
    }
    
    func fetchPendingCarInvites(completion: @escaping (Bool) -> Void) {
        fetchServerEndpoint(endpoint: "checkinvites?userid=\(self.userID)", fetchHash: UUID(), decodeAs: FetchedInvites.self) { (result, returnHash) in
            if (self.isPushUpdatingInfo || self.isPushUpdatingCar) {
                completion(true)
                return
            }
            switch result {
            case .success(let data):
                withAnimation {
                    self.carInvites = data.invites
                }
                completion(true)
            case .failure(let error):
                completion(false)
            }
        }
    }
    
    func update_color(to color: CustomColor) {
        self.isPushUpdatingInfo = true
        withAnimation {
            self.myColor = color
        }
        fetchServerEndpoint(endpoint: "updatecolor?userid=\(self.userID)&color=\(cctostr(color))", fetchHash: UUID(), decodeAs: Bool.self) { (result, returnHash) in
            switch result {
            case .success(_):
                self.isPushUpdatingInfo = false
            case .failure(let error):
                print("error")
                print(error)
                self.isPushUpdatingInfo = false
            }
        }
    }
    
    func update_name(to name: String) {
        self.isPushUpdatingInfo = true
        withAnimation {
            self.username = name
        }
        fetchServerEndpoint(endpoint: "updatename?userid=\(self.userID)&name=\(name)", fetchHash: UUID(), decodeAs: Bool.self) { (result, returnHash) in
            switch result {
            case .success(_):
                self.isPushUpdatingInfo = false
            case .failure(let error):
                print(error)
                self.isPushUpdatingInfo = false
            }
        }
    }
    
    func update_car_name(to name: String) {
        self.isPushUpdatingInfo = true
        withAnimation {
            self.carname = name
        }
        if let car = self.car {
            fetchServerEndpoint(endpoint: "updatecarname?carid=\(car)&name=\(name)", fetchHash: UUID(), decodeAs: Bool.self) { (result, returnHash) in
                switch result {
                case .success(_):
                    self.isPushUpdatingInfo = false
                case .failure(let error):
                    print(error)
                    self.isPushUpdatingInfo = false
                }
            }
        } else {
            self.isPushUpdatingInfo = false
        }
    }
    
    func accept_invite(carID: CarID) {
        withAnimation {
            self.isPushUpdatingCar = true
        }
        fetchServerEndpoint(endpoint: "acceptinvite?carid=\(carID)&userid=\(self.userID)", fetchHash: UUID(), decodeAs: Bool.self) { (result, returnHash) in
            switch result {
            case .success(_):
                withAnimation {
                    self.isPushUpdatingCar = false
                }
            case .failure(let error):
                print(error)
                withAnimation {
                    self.isPushUpdatingCar = false
                }
            }
        }
    }
    
    func force_accept_invite(carID: CarID) {
        withAnimation {
            self.isPushUpdatingCar = true
        }
        fetchServerEndpoint(endpoint: "forceacceptinvite?carid=\(carID)&userid=\(self.userID)", fetchHash: UUID(), decodeAs: Bool.self) { (result, returnHash) in
            switch result {
            case .success(_):
                withAnimation {
                    self.isPushUpdatingCar = false
                }
            case .failure(let error):
                print(error)
                withAnimation {
                    self.isPushUpdatingCar = false
                }
            }
        }
    }
    
    func dismiss_invite(carID: CarID) {
        withAnimation {
            self.isPushUpdatingCar = true
        }
        fetchServerEndpoint(endpoint: "dismissinvite?carid=\(carID)&userid=\(self.userID)", fetchHash: UUID(), decodeAs: Bool.self) { (result, returnHash) in
            switch result {
            case .success(_):
                withAnimation {
                    self.isPushUpdatingCar = false
                }
            case .failure(let error):
                print(error)
                withAnimation {
                    self.isPushUpdatingCar = false
                }
            }
        }
    }
    
    func invite_user(userID: String) {
        self.isPushUpdatingInfo = true
        if let car = self.car {
            fetchServerEndpoint(endpoint: "pendinvite?carid=\(car)&userid=\(userID)", fetchHash: UUID(), decodeAs: Bool.self) { (result, returnHash) in
                switch result {
                case .success(_):
                    self.isPushUpdatingInfo = false
                case .failure(let error):
                    print(error)
                    self.isPushUpdatingInfo = false
                }
            }
        } else {
            self.isPushUpdatingInfo = false
        }
    }
    
    func update_ihavecar() {
        self.isPushUpdatingInfo = true
        if let car = self.car {
            fetchServerEndpoint(endpoint: "ihavecar?carid=\(car)&userid=\(self.userID)", fetchHash: UUID(), decodeAs: Bool.self) { (result, returnHash) in
                switch result {
                case .success(_):
                    self.isPushUpdatingInfo = false
                case .failure(let error):
                    print(error)
                    self.isPushUpdatingInfo = false
                }
            }
        } else {
            self.isPushUpdatingInfo = false
        }
    }
    
    func send_car_request(start: Int, end: Int, reason: String) {
        self.isPushUpdatingInfo = true
        if let car = self.car {
            fetchServerEndpoint(endpoint: "sendrangerequest?carid=\(car)&userid=\(self.userID)&start=\(start)&end=\(end)&reason=\(reason)", fetchHash: UUID(), decodeAs: Bool.self) { (result, returnHash) in
                switch result {
                case .success(_):
                    self.isPushUpdatingInfo = false
                case .failure(let error):
                    print(error)
                    self.isPushUpdatingInfo = false
                }
            }
        } else {
            self.isPushUpdatingInfo = false
        }
    }
    
    func accept_car_request(rangeID: RangeID) {
        self.isPushUpdatingInfo = true
        if let car = self.car {
            fetchServerEndpoint(endpoint: "acceptrange?carid=\(car)&userid=\(self.userID)&rangeid=\(rangeID)", fetchHash: UUID(), decodeAs: Bool.self) { (result, returnHash) in
                switch result {
                case .success(_):
                    self.isPushUpdatingInfo = false
                case .failure(let error):
                    print(error)
                    self.isPushUpdatingInfo = false
                }
            }
        } else {
            self.isPushUpdatingInfo = false
        }
    }
    
}

enum FetchStatus {
    case waiting, success, failed
}
