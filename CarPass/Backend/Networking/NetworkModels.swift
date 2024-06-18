//
//  NetworkModels.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-18.
//

import Foundation

typealias UserID = String
typealias CarID = String


class FetchedUser: Codable {
    var name: String
    var id: String
    var car: [CarID]
}

class FetchedCar: Codable {
    var name: String
    var id: String
    var pendingInvites: []
    var pendingRanges: []
    var confirmedRanges: []
}



class FetchedNewUser
