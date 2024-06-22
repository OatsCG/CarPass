//
//  CalendarHeader.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-20.
//

import SwiftUI

struct CalendarHeader: View {
    var calendarModel: CalendarModel
    var body: some View {
        HStack {
            Button(action: {
                calendarModel.backwardMonth()
            }) {
                Image(systemName: "chevron.backward")
                    .font(.title2 .bold())
                    .symbolRenderingMode(.hierarchical)
            }
                .tint(.primary)
            Spacer()
            Button(action: {
                // open month/year picker
            }) {
                Text("\(monthName(from: calendarModel.currentMonth)) \(Text(verbatim: "\(calendarModel.currentYear)"))")
                    .font(.title3 .bold())
            }
                .tint(.primary)
            Spacer()
            Button(action: {
                calendarModel.forwardMonth()
            }) {
                Image(systemName: "chevron.forward")
                    .font(.title2 .bold())
                    .symbolRenderingMode(.hierarchical)
            }
                .tint(.primary)
        }
            .frame(height: 30)
            .safeAreaPadding()
    }
}

func monthName(from monthNumber: Int) -> String {
    let formatter = DateFormatter()
    let months = formatter.monthSymbols
    
    guard monthNumber >= 1 && monthNumber <= 12 else {
        return "---"
    }
    
    if let months = months {
        return months[monthNumber - 1]
    } else {
        return "---"
    }
}

#Preview {
    CalendarHeader(calendarModel: CalendarModel(editingEnabled: false))
}
