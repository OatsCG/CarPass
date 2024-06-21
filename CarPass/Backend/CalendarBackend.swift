//
//  CalendarBackend.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-20.
//

import Foundation
import SwiftDate

func currentYear() -> Int {
    let currentDate: DateInRegion = SwiftDate.defaultRegion.nowInThisRegion()
    let currentYear: Int = currentDate.year
    return currentYear
}

func currentMonth() -> Int {
    let currentDate: DateInRegion = SwiftDate.defaultRegion.nowInThisRegion()
    let currentMonth: Int = currentDate.month
    return currentMonth
}

func previousMonthsMonth(_ month: Int) -> Int {
    if (month > 1) {
        return month - 1
    } else {
        return 12
    }
}

func previousMonthsYear(m month: Int, y year: Int) -> Int {
    if (month > 1) {
        return year
    } else {
        return year - 1
    }
}

func nextMonthsMonth(_ month: Int) -> Int {
    if (month == 12) {
        return 1
    } else {
        return month + 1
    }
}

func nextMonthsYear(m month: Int, y year: Int) -> Int {
    if (month == 12) {
        return year + 1
    } else {
        return year
    }
}

func daysInMonth(month: Int, year: Int) -> Int {
    var dateComponents = DateComponents()
    dateComponents.year = year
    dateComponents.month = month
    
    let calendar = Calendar.current
    
    guard let date = calendar.date(from: dateComponents),
          let range = calendar.range(of: .day, in: .month, for: date) else {
        return 1
    }
    
    return range.count
}

func firstWeekdayNumber(month: Int, year: Int) -> Int {
    var dateComponents = DateComponents()
    dateComponents.year = year
    dateComponents.month = month
    dateComponents.day = 1
    let calendar = Calendar.current
    guard let date = calendar.date(from: dateComponents) else {
        return 1
    }
    let weekday = calendar.component(.weekday, from: date)
    return weekday
}


func fullMonthArr(month: Int, year: Int) -> [CalDaySimple] {
    let monthDayCount: Int = daysInMonth(month: month, year: year)
    print("monthcount: \(monthDayCount)")
    var inMonthArr: [CalDaySimple] = []
    for i in 1...monthDayCount {
        inMonthArr.append(CalDaySimple(dayNumber: i, isPartOfMonth: true))
    }
    
    var weekdayNum: Int = firstWeekdayNumber(month: month, year: year)
    print("weekdayNum: \(weekdayNum)")
    
    let prevMonthDayCount: Int = daysInMonth(month: month, year: year)
    print("prevMonthDayCount: \(prevMonthDayCount)")
    var prevMonthArr: [CalDaySimple] = []
    for i in (prevMonthDayCount-(weekdayNum-1)+2)...prevMonthDayCount+1 {
        prevMonthArr.append(CalDaySimple(dayNumber: i, isPartOfMonth: false))
    }
    
    let remainingDays: Int = (6 * 7) - (inMonthArr.count + prevMonthArr.count)
    print("remainingDays: \(remainingDays)")
    var nextMonthArr: [CalDaySimple] = []
    for i in 1...remainingDays {
        nextMonthArr.append(CalDaySimple(dayNumber: i, isPartOfMonth: false))
    }
    
    return prevMonthArr + inMonthArr + nextMonthArr
}


class CalendarModel {
    var months: [CalMonth] = []
    init() {
        let monthArr: [CalDaySimple] = fullMonthArr(month: 6, year: 2024)
        for day in monthArr {
            print(day.dayNumber)
        }
    }
}


enum MonthName: Int {
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
    var dayNumber: Int // number of day in the month
    var isPartOfMonth: Bool // true if the day is in the inputted month
    var occupiedBy: Occupant?
    var capType: CapType
}

struct CalDaySimple {
    var dayNumber: Int // number of day in the month
    var isPartOfMonth: Bool // true if the day is in the inputted month
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
