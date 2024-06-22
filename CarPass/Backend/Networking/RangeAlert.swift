//
//  PendingAlerts.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-19.
//

import Foundation

struct PendingAlert: Codable {
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

struct ConfirmedAlert: Codable {
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

func pendingAlertsToString(alerts: [PendingAlert]) -> String? {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601 // Customize date encoding if needed
    
    if let jsonData = try? encoder.encode(alerts) {
        return String(data: jsonData, encoding: .utf8)
    }
    return nil
}

func stringToPendingAlerts(jsonString: String) -> [PendingAlert]? {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601 // Customize date decoding if needed
    
    if let jsonData = jsonString.data(using: .utf8) {
        return try? decoder.decode([PendingAlert].self, from: jsonData)
    }
    return nil
}

func confirmedAlertsToString(alerts: [ConfirmedAlert]) -> String? {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601 // Customize date encoding if needed
    
    if let jsonData = try? encoder.encode(alerts) {
        return String(data: jsonData, encoding: .utf8)
    }
    return nil
}

func stringToConfirmedAlerts(jsonString: String) -> [ConfirmedAlert]? {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601 // Customize date decoding if needed
    
    if let jsonData = jsonString.data(using: .utf8) {
        return try? decoder.decode([ConfirmedAlert].self, from: jsonData)
    }
    return nil
}
