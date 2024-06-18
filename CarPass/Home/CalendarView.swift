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
            HStack {
                Button(action: {
                    
                }) {
                    Image(systemName: "arrowshape.backward.circle.fill")
                        .font(.largeTitle)
                        .symbolRenderingMode(.hierarchical)
                }
                .tint(.primary)
                Spacer()
                Text("June 2024")
                    .font(.title3 .bold())
                Spacer()
                Button(action: {
                    
                }) {
                    Image(systemName: "arrowshape.forward.circle.fill")
                        .font(.largeTitle)
                        .symbolRenderingMode(.hierarchical)
                }
                .tint(.primary)
            }
                .frame(height: 30)
                .safeAreaPadding()
                .background(.regularMaterial)
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
        VStack {
            HStack {
                Spacer()
                Text("4")
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                Spacer()
            }
            Spacer()
        }
        .padding(.vertical, 3)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 3))
    }
}


#Preview {
    HomeView()
        .environment(User())
}




