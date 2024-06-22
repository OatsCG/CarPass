//
//  PendingAlerts.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-19.
//

import Foundation

struct PendingAlert {
    var id: RangeID
    var userID: UserID
    var name: String // Charlie
    var reason: String // just want it
    var rangeStart: Date
    var rangeEnd: Date
    var rangeDescription: String // June 5
    var rangeRelativeDescription: String // Tomorrow, In 2 days, etc
    var color: CustomColor // .red
    var accepted: [UserID]
}

struct ConfirmedAlert {
    var id: RangeID
    var userID: UserID
    var name: String // Charlie
    var reason: String // just want it
    var rangeStart: Date
    var rangeEnd: Date
    var rangeDescription: String // June 5
    var rangeRelativeDescription: String // Tomorrow, In 2 days, etc
    var color: CustomColor // .red
    var mustBring: Bool // true
}
