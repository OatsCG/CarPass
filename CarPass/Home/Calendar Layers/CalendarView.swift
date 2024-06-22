//
//  CalendarView.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-18.
//

import SwiftUI

struct CalendarView: View {
    @Environment(User.self) var user
    @State var calendarModel: CalendarModel
    @State private var calTimer: Timer?
    init(editingEnabled: Bool, calendarModel: CalendarModel? = nil) {
        if let calendarModel = calendarModel {
            self.calendarModel = calendarModel
        } else {
            self.calendarModel = CalendarModel(editingEnabled: editingEnabled)
        }
    }
    var body: some View {
        VStack(spacing: 3) {
            CalendarHeader(calendarModel: calendarModel)
            CalendarMonthView(calendarModel: calendarModel)
        }
        .onAppear {
            startTimer()
        }
        
    }
    
    func startTimer() {
        calTimer?.invalidate()
        calTimer = nil
        calTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.calendarModel.updateCalendar(user: user)
        }
    }
}



struct CalendarMonthView: View {
    var calendarModel: CalendarModel
    var body: some View {
        VStack(spacing: 0) {
            CalendarWeekView(calendarModel: calendarModel, calWeek: calendarModel.month?.week1)
            CalendarWeekView(calendarModel: calendarModel, calWeek: calendarModel.month?.week2)
            CalendarWeekView(calendarModel: calendarModel, calWeek: calendarModel.month?.week3)
            CalendarWeekView(calendarModel: calendarModel, calWeek: calendarModel.month?.week4)
            CalendarWeekView(calendarModel: calendarModel, calWeek: calendarModel.month?.week5)
            CalendarWeekView(calendarModel: calendarModel, calWeek: calendarModel.month?.week6)
        }
        .mask {
            HStack(spacing: 0) {
                Rectangle().fill(LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .leading, endPoint: .trailing))
                    .frame(width: 6)
                Rectangle().fill(.black)
                Rectangle().fill(LinearGradient(gradient: Gradient(colors: [.black, .clear]), startPoint: .leading, endPoint: .trailing))
                    .frame(width: 6)
            }
        }
    }
}


struct CalendarWeekView: View {
    var calendarModel: CalendarModel
    var calWeek: CalWeek?
    var body: some View {
        HStack(spacing: 0) {
            CalendarDayView(calendarModel: calendarModel, calDay: calWeek?.sunday)
            CalendarDayView(calendarModel: calendarModel, calDay: calWeek?.monday)
            CalendarDayView(calendarModel: calendarModel, calDay: calWeek?.tuesday)
            CalendarDayView(calendarModel: calendarModel, calDay: calWeek?.wednesday)
            CalendarDayView(calendarModel: calendarModel, calDay: calWeek?.thursday)
            CalendarDayView(calendarModel: calendarModel, calDay: calWeek?.friday)
            CalendarDayView(calendarModel: calendarModel, calDay: calWeek?.saturday)
        }
    }
}

struct CalendarDayView: View {
    @Environment(User.self) var user
    var calendarModel: CalendarModel
    var calDay: CalDay?
    var paddingAmount: CGFloat = 5
    var body: some View {
        Group {
            if calendarModel.editing {
                Button(action: {
                    if calendarModel.currentlyEditingStart {
                        calendarModel.updateStartDate(to: calDay?.actualDate, user: user)
                    } else {
                        calendarModel.updateEndDate(to: calDay?.actualDate, user: user)
                    }
                }) {
                    CalendarDayCap(color: calDay?.occupiedBy?.color, inMonth: calDay?.isPartOfMonth ?? false, paddingAmount: paddingAmount, cap: calDay?.capType ?? .none, isEditing: calDay?.isEditing ?? false)
                }
            } else {
                CalendarDayCap(color: calDay?.occupiedBy?.color, inMonth: calDay?.isPartOfMonth ?? false, paddingAmount: paddingAmount, cap: calDay?.capType ?? .none, isEditing: calDay?.isEditing ?? false)
            }
        }
            .overlay {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        if let daynum = calDay?.dayNumber {
                            Text("\(daynum)")
                                .font(.subheadline .bold())
                        } else {
                            Text("•")
                                .font(.subheadline .bold())
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                    }
                    Spacer()
                }
            }
            .foregroundStyle((calDay?.isPartOfMonth ?? false) ? ((calDay?.isToday ?? false) ? cc(calDay?.occupiedBy?.color ?? .blue, style: .primary) : .white) : .customsecondary)
    }
}





#Preview {
    HomeView()
        .environment(User())
}

