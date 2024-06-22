//
//  RequestCarSheet.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-21.
//

import SwiftUI

struct RequestCarSheet: View {
    @Environment(User.self) var user
    @Binding var showingRequestSheet: Bool
    @State var calendarModel: CalendarModel = CalendarModel(editingEnabled: true)
    @State var isstartselected: Bool = false
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text("New Request")
                    .font(.title .bold())
                Spacer()
            }
            .padding(10)
            CalendarView(editingEnabled: true, calendarModel: calendarModel)
                .frame(height: 350)
                .padding(.bottom)
            VStack(alignment: .leading) {
                HStack {
                    Text("Start: **\(datestr(calendarModel.startEditDate))**")
                        .font(.title3)
                        .padding(.horizontal)
                        .padding(.vertical)
                        .background {
                            
                        }
                }
                HStack {
                    Text("End: **\(datestr(calendarModel.endEditDate))**")
                        .font(.title3)
                }
            }
            Spacer()
        }
        .safeAreaPadding()
        .background(.custombackground)
    }
}

func datestr(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE MMMM d"
    return dateFormatter.string(from: date)
}

#Preview {
    RequestCarSheet(showingRequestSheet: .constant(true))
        .environment(User())
}
