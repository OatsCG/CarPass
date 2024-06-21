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
    var body: some View {
        VStack(spacing: 3) {
            CalendarWeekView()
            CalendarWeekView()
            CalendarWeekView()
            CalendarWeekView()
            CalendarWeekView()
            CalendarWeekView()
        }
    }
}


struct CalendarWeekView: View {
    var body: some View {
        HStack(spacing: 3) {
            CalendarDayView()
            CalendarDayView()
            CalendarDayView()
            CalendarDayView()
            CalendarDayView()
            CalendarDayView()
            CalendarDayView()
        }
    }
}

struct CalendarDayView: View {
    var body: some View {
        Circle()
            .fill(.ultraThinMaterial)
            .overlay {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("4")
                            .font(.body .bold())
                            .foregroundStyle(.primary)
                        Spacer()
                    }
                    //            Rectangle().fill(.red)
                    //                .frame(height: 20)
                    Spacer()
                }
                //.padding(.vertical, 3)
                //.background(.ultraThinMaterial)
                //.clipShape(RoundedRectangle(cornerRadius: 3))
            }
    }
}


#Preview {
    HomeView()
        .environment(User())
}

