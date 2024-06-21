//
//  CalendarView.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-18.
//

import SwiftUI

struct CalendarView: View {
    var body: some View {
        VStack(spacing: 3) {
            CalendarHeader()
            CalendarMonthView()
        }
    }
}



struct CalendarMonthView: View {
    @State var calendarModel: CalendarModel = CalendarModel()
    var body: some View {
        VStack(spacing: 0) {
            CalendarWeekView(calWeek: calendarModel.month?.week1)
            CalendarWeekView(calWeek: calendarModel.month?.week2)
            CalendarWeekView(calWeek: calendarModel.month?.week3)
            CalendarWeekView(calWeek: calendarModel.month?.week4)
            CalendarWeekView(calWeek: calendarModel.month?.week5)
            CalendarWeekView(calWeek: calendarModel.month?.week6)
        }
    }
}


struct CalendarWeekView: View {
    var calWeek: CalWeek?
    var body: some View {
        HStack(spacing: 0) {
            CalendarDayView(calDay: calWeek?.sunday)
            CalendarDayView(calDay: calWeek?.monday)
            CalendarDayView(calDay: calWeek?.tuesday)
            CalendarDayView(calDay: calWeek?.wednesday)
            CalendarDayView(calDay: calWeek?.thursday)
            CalendarDayView(calDay: calWeek?.friday)
            CalendarDayView(calDay: calWeek?.saturday)
        }
    }
}

struct CalendarDayView: View {
    var calDay: CalDay?
    var paddingAmount: CGFloat = 5
    var body: some View {
        CalendarDayCap(color: .green, inMonth: calDay?.isPartOfMonth ?? false, paddingAmount: paddingAmount, cap: calDay?.capType ?? .none)
            .overlay {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("\(calDay?.dayNumber ?? 1)")
                            .font(.subheadline .bold())
                            //.foregroundStyle(.blueprimary)
                        Spacer()
                    }
                    Spacer()
                }
            }
            .foregroundStyle((calDay?.isPartOfMonth ?? false) ? ((calDay?.isToday ?? false) ? .greenprimary : .white) : .customsecondary)
    }
}





#Preview {
    HomeView()
        .environment(User())
}

