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
    @State var isstartselected: Bool = true
    @State var rotation: CGFloat = 0
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
            VStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Button(action: {
                        withAnimation {
                            isstartselected = true
                        }
                        calendarModel.switchEdit(to: true)
                    }) {
                        Text("Start: **\(datestr(calendarModel.startEditDate))**")
                            .font(.title3)
                            .foregroundStyle(isstartselected ? Color.primary : .bluesecondary)
                            .padding(.horizontal)
                            .padding(.vertical)
                            .background {
                                Capsule()
                                    .fill(isstartselected ? .bluebgthick : .bluebgthin)
                                    .stroke(isstartselected ? .blueprimary : .bluebgthick, lineWidth: 2)
                            }
                    }
                    Button(action: {
                        withAnimation {
                            isstartselected = false
                        }
                        calendarModel.switchEdit(to: false)
                    }) {
                        Text("End: **\(datestr(calendarModel.endEditDate))**")
                            .font(.title3)
                            .foregroundStyle(!isstartselected ? Color.primary : .bluesecondary)
                            .padding(.horizontal)
                            .padding(.vertical)
                            .background {
                                Capsule()
                                    .fill(!isstartselected ? .bluebgthick : .bluebgthin)
                                    .stroke(!isstartselected ? .blueprimary : .bluebgthick, lineWidth: 2)
                            }
                    }
                }
                Button(action: {
                    user.send_car_request(start: Int(calendarModel.startEditDate.timeIntervalSince1970), end: Int(calendarModel.endEditDate.timeIntervalSince1970), reason: "I just want it pls")
                    showingRequestSheet = false
                }) {
                    CapsuleButton(text: Text("**Send Request**"), lit: false, color: .red)
                }
            }
            Spacer()
        }
        .safeAreaPadding()
        .background(.custombackground)
        .onAppear()
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
