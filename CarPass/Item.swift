//
//  Item.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-18.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
