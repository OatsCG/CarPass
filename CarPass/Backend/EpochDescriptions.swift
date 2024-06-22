//
//  EpochDescriptions.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-19.
//

import SwiftUI

func epochToDescription(epochStart: Int, epochEnd: Int) -> String {
    let startDate = Date(timeIntervalSince1970: TimeInterval(epochStart))
    let endDate = Date(timeIntervalSince1970: TimeInterval(epochEnd))
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM d"
    
    let startString = dateFormatter.string(from: startDate)
    let endString = dateFormatter.string(from: endDate)
    
    if startString == endString {
        return startString
    } else {
    return "\(startString) - \(endString)"
    }
}

func epochToRelativeDescription(epoch: Int) -> String {
    let targetDate = Date(timeIntervalSince1970: TimeInterval(epoch))
    let currentDate = Date()
    
    let calendar = Calendar.current
    let startOfDayCurrent = calendar.startOfDay(for: currentDate)
    let startOfDayTarget = calendar.startOfDay(for: targetDate)
    
    let components = calendar.dateComponents([.day], from: startOfDayCurrent, to: startOfDayTarget)
    
    guard let daysUntil = components.day else {
        return ""
    }
    
    switch daysUntil {
    case 0:
        return "Today"
    case 1:
        return "Tomorrow"
    case _ where daysUntil > 1:
        return "In \(daysUntil) Days"
    default:
        return ""
    }
}
