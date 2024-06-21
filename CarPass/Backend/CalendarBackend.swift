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


func fullMonthSimpleArr(month: Int, year: Int) -> [CalDaySimple] {
    let monthDayCount: Int = daysInMonth(month: month, year: year)
    var inMonthArr: [CalDaySimple] = []
    for i in 1...monthDayCount {
        inMonthArr.append(CalDaySimple(year: year, month: month, day: i, isPartOfMonth: true))
    }
    
    var weekdayNum: Int = firstWeekdayNumber(month: month, year: year)
    
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

func simpleToFullMonth(month: [CalDaySimple]) -> [CalDay] {
    return month.map { calday in
        let thisdate: DateInRegion = DateInRegion(year: calday.year, month: calday.month, day: calday.day)
        var captype: CapType = .none
        if (calday.day % 7 == 0) {
            captype = .start
        } else if (calday.day % 7 == 1) {
            captype = .mid
        } else if (calday.day % 7 == 2) {
            captype = .end
        } else if (calday.day % 7 == 4) {
            captype = .start
        } else if (calday.day % 7 == 5) {
            captype = .end
        }
        return CalDay(dayNumber: calday.day, isPartOfMonth: calday.isPartOfMonth, isToday: thisdate.isToday, occupiedBy: nil, capType: captype)
    }
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
                var calmonth: CalMonth = CalMonth(
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

@Observable class CalendarModel {
    var month: CalMonth? = nil
    
    var editing: Bool
    init(editingEnabled: Bool) {
        self.editing = editingEnabled
        
        //self.updateCalendar(user: user)
    }
    
    func updateCalendar(user: User) {
        self.updateOccupiedRanges()
        self.updateMonth()
    }
    
    private func updateOccupiedRanges() {
        
    }
    
    private func updateMonth() {
        let fullmonthsimple: [CalDaySimple] = fullMonthSimpleArr(month: 6, year: 2024)
        let calmonth: CalMonth? = fullmonthToCalMonth(fullmonth: simpleToFullMonth(month: fullmonthsimple), month: 6, year: 2024)
        if let calmonth = calmonth {
            self.month = calmonth
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
    var isToday: Bool
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
    case none, passandstart, start, mid, end, endandpass
}
