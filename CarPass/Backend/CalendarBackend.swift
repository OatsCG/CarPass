//
//  CalendarBackend.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-20.
//

import Foundation

class CalendarModel {
    var months: [CalMonth] = []
    init() {
        
        
        
        var thismonth = CalMonth(monthname: <#T##MonthName#>, year: <#T##Int#>, week1: <#T##CalWeek#>, week2: <#T##CalWeek#>, week3: <#T##CalWeek#>, week4: <#T##CalWeek#>, week5: <#T##CalWeek#>, week6: <#T##CalWeek#>)
    }
    
    
    func newDay() -> CalDay {
        
    }
}


enum MonthName {
    case Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sept, Oct, Nov, Dec
}

struct CalMonth {
    var monthname: MonthName
    var year: Int
    var week1: CalWeek
    var week2: CalWeek
    var week3: CalWeek
    var week4: CalWeek
    var week5: CalWeek
    var week6: CalWeek
}

struct CalWeek {
    var sunday: CalDay
    var monday: CalDay
    var tuesday: CalDay
    var wednesday: CalDay
    var thursday: CalDay
    var friday: CalDay
    var saturday: CalDay
}

struct CalDay {
    var dayNumber: Int
    var isPartOfMonth: Bool
    var occupiedBy: Occupant?
    var capType: CapType
}

struct Occupant {
    var name: String
    var color: CustomColor
    var start: Int
    var end: Int
    var reason: String
}

enum CapType {
    case none, passandstart, start, mid, end, endandpass
}
