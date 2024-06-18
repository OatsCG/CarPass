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
}

class FetchedCar: Codable {
    var name: String
    var id: CarID
    var pendingInvites: [UserID]
    var pendingRanges: [FetchedRange]
    var confirmedRanges: [FetchedRange]
}

class FetchedRange: Codable {
    var id: RangeID
    var user: UserID
    var reason: String
    var accepted: [UserID]
    var start: Int
    var end: Int
}
