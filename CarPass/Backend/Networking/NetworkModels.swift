//
//  NetworkModels.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-18.
//

import Foundation

typealias UserID = String
typealias CarID = String
typealias RangeID = String


class FetchedUser: Codable {
    var name: String
    var id: UserID
    var car: CarID?
    var color: String
    
    init(name: String, id: UserID, color: String) {
        self.name = name
        self.id = id
        self.car = nil
        self.color = color
    }
}

class FetchedCar: Codable {
    var name: String
    var id: CarID
    var whohas: UserID
    var whohasusername: String
    var whohasusercolor: String
    var users: [UserID]
    var pendingInvites: [UserID]
    var pendingRanges: [FetchedPendingRange]
    var confirmedRanges: [FetchedConfirmedRange]
}

class FetchedCarUsers: Codable {
    var users: [FetchedCarUser]
}

class FetchedCarUser: Codable {
    var id: UserID
    var name: String
    var color: String
    var confirmed: Bool
}

class FetchedPendingRange: Codable {
    var id: RangeID
    var user: UserID
    var username: String
    var usercolor: String
    var reason: String
    var accepted: [UserID]
    var start: Int
    var end: Int
}

class FetchedConfirmedRange: Codable {
    var id: RangeID
    var user: UserID
    var username: String
    var usercolor: String
    var reason: String
    var start: Int
    var end: Int
}

class FetchedInvites: Codable {
    var invites: [CarID]
}
