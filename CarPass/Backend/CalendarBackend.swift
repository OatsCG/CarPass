//
//  CalendarBackend.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-20.
//

import Foundation
import SwiftUI
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


func fullMonthSimpleArr(month: Int, year: Int) -> [CalDaySimple] {
    let monthDayCount: Int = daysInMonth(month: month, year: year)
    var inMonthArr: [CalDaySimple] = []
    for i in 1...monthDayCount {
        inMonthArr.append(CalDaySimple(year: year, month: month, day: i, isPartOfMonth: true))
    }
    
    let weekdayNum: Int = firstWeekdayNumber(month: month, year: year)
    
    let prevMonth: Int = previousMonthsMonth(month)
    let prevYear: Int = previousMonthsYear(m: month, y: year)
    let prevMonthDayCount: Int = daysInMonth(month: prevMonth, year: prevYear)
    var prevMonthArr: [CalDaySimple] = []
    for i in (prevMonthDayCount-(weekdayNum-1)+1)...prevMonthDayCount {
        prevMonthArr.append(CalDaySimple(year: prevYear, month: prevMonth, day: i, isPartOfMonth: false))
    }
    
    let nextMonth: Int = nextMonthsMonth(month)
    let nextYear: Int = nextMonthsYear(m: month, y: year)
    let remainingDays: Int = (6 * 7) - (inMonthArr.count + prevMonthArr.count)
    var nextMonthArr: [CalDaySimple] = []
    for i in 1...remainingDays {
        nextMonthArr.append(CalDaySimple(year: nextYear, month: nextMonth, day: i, isPartOfMonth: false))
    }
    
    return prevMonthArr + inMonthArr + nextMonthArr
}

func fullmonthToCalMonth(fullmonth: [CalDay], month: Int, year: Int) -> CalMonth? {
    if fullmonth.count == 42 {
        var weeks: [CalWeek] = []
        for a in 0...5 {
            weeks.append(
                CalWeek(
                    sunday: fullmonth[a * 7],
                    monday: fullmonth[(a * 7) + 1],
                    tuesday: fullmonth[(a * 7) + 2],
                    wednesday: fullmonth[(a * 7) + 3],
                    thursday: fullmonth[(a * 7) + 4],
                    friday: fullmonth[(a * 7) + 5],
                    saturday: fullmonth[(a * 7) + 6]
                )
            )
        }
        if weeks.count == 6 {
            if let monthname = MonthName.init(rawValue: month - 1) {
                let calmonth: CalMonth = CalMonth(
                    monthname: monthname,
                    year: year,
                    week1: weeks[0],
                    week2: weeks[1],
                    week3: weeks[2],
                    week4: weeks[3],
                    week5: weeks[4],
                    week6: weeks[5]
                )
                return calmonth
            } else {
                return nil
            }
        } else {
            return nil
        }
    } else {
        return nil
    }
}

func dateStatus(rangeStart: Date, rangeEnd: Date, date1: Date) -> CapType {
    let calendar = Calendar.current
    
    if (calendar.isDate(date1, inSameDayAs: rangeStart) && calendar.isDate(date1, inSameDayAs: rangeEnd)) {
        return .startandend
    } else if calendar.isDate(date1, inSameDayAs: rangeStart) {
        return .start
    } else if calendar.isDate(date1, inSameDayAs: rangeEnd) {
        return .end
    } else if date1 >= rangeStart && date1 <= rangeEnd {
        return .mid
    } else {
        return .none
    }
}

@Observable class CalendarModel {
    var month: CalMonth? = nil
    var editing: Bool
    var startEditDate: Date = Date()
    var endEditDate: Date = Date()
    var currentlyEditingStart: Bool = true
    
    init(editingEnabled: Bool) {
        self.editing = editingEnabled
        
        //self.updateCalendar(user: user)
    }
    
    func updateCalendar(user: User) {
        self.updateMonth(user: user)
    }
    
    private func updateOccupiedRanges(month: [CalDaySimple], user: User) -> [CalDay] {
        return month.map { calday in
            let thisdate: DateInRegion = DateInRegion(year: calday.year, month: calday.month, day: calday.day, region: .current)
            let thisrealdate: Date = thisdate.date
            
            var captype: CapType = .none
            var occupant: Occupant? = nil
            for alert in user.confirmedAlerts {
                let dateCapType: CapType = dateStatus(rangeStart: alert.rangeStart, rangeEnd: alert.rangeEnd, date1: thisrealdate)
                if dateCapType != .none {
                    occupant = Occupant(name: alert.name, color: alert.color, start: Int(alert.rangeStart.timeIntervalSince1970), end: Int(alert.rangeEnd.timeIntervalSince1970), reason: alert.reason)
                    captype = dateCapType
                    break
                }
            }
            // also include start/end editors
            if self.editing {
                let editrangeCapType: CapType = dateStatus(rangeStart: self.startEditDate, rangeEnd: self.endEditDate, date1: thisrealdate)
                if editrangeCapType != .none {
                    occupant = Occupant(name: "$editorname$", color: user.myColor, start: Int(self.startEditDate.timeIntervalSince1970), end: Int(self.startEditDate.timeIntervalSince1970), reason: "")
                    captype = .startandend
                }
            }
            
            return CalDay(dayNumber: calday.day, isPartOfMonth: calday.isPartOfMonth, isToday: thisdate.isToday, isBeforeToday: (thisdate.isInPast && !thisdate.isToday), actualDate: thisrealdate, occupiedBy: occupant, capType: captype)
        }
    }
    
    private func updateMonth(user: User) {
        let fullmonthsimple: [CalDaySimple] = fullMonthSimpleArr(month: 6, year: 2024)
        let calmonth: CalMonth? = fullmonthToCalMonth(fullmonth: self.updateOccupiedRanges(month: fullmonthsimple, user: user), month: 6, year: 2024)
        if let calmonth = calmonth {
            withAnimation {
                self.month = calmonth
            }
        }
    }
    
    func updateStartDate(to date: Date?, user: User) {
        if let date = date {
            self.startEditDate = date
            if (self.startEditDate > self.endEditDate) {
                self.endEditDate = self.startEditDate
            }
            self.updateCalendar(user: user)
        }
    }
    
    func updateEndDate(to date: Date?, user: User) {
        if let date = date {
            self.endEditDate = date
            if (self.endEditDate < self.startEditDate) {
                self.startEditDate = self.endEditDate
            }
            self.updateCalendar(user: user)
        }
    }
    
    func switchEdit(to: Bool) {
        self.currentlyEditingStart = to
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
    var isToday: Bool
    var isBeforeToday: Bool
    var actualDate: Date
    var occupiedBy: Occupant?
    var capType: CapType
}

struct CalDaySimple {
    var year: Int
    var month: Int
    var day: Int
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
    case none, start, mid, end, startandend
}
