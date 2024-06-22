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
    @State var reason: String = ""
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text("Request Car")
                    .font(.title2 .bold())
                Spacer()
                Button(action: {
                    
                }) {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundStyle(.tertiary)
                        .symbolRenderingMode(.hierarchical)
                }
                .buttonStyle(.plain)
            }
            .padding(10)
            .padding(.bottom, 10)
            Divider()
            CalendarView(editingEnabled: true, calendarModel: calendarModel)
                .frame(height: 350)
            Divider()
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
                            .font(.headline)
                            .foregroundStyle(isstartselected ? Color.primary : cc(user.myColor, style: .secondary))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background {
                                Capsule()
                                    .fill(isstartselected ? cc(user.myColor, style: .thick) : cc(user.myColor, style: .thin))
                                    .stroke(isstartselected ? cc(user.myColor, style: .primary) : cc(user.myColor, style: .thick), lineWidth: 2)
                            }
                    }
                    Button(action: {
                        withAnimation {
                            isstartselected = false
                        }
                        calendarModel.switchEdit(to: false)
                    }) {
                        Text("End: **\(datestr(calendarModel.endEditDate))**")
                            .font(.headline)
                            .foregroundStyle(!isstartselected ? Color.primary : cc(user.myColor, style: .secondary))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background {
                                Capsule()
                                    .fill(!isstartselected ? cc(user.myColor, style: .thick) : cc(user.myColor, style: .thin))
                                    .stroke(!isstartselected ? cc(user.myColor, style: .primary) : cc(user.myColor, style: .thick), lineWidth: 2)
                            }
                    }
                }
                TextField("Reason (Optional)", text: $reason)
                    .font(.headline .weight(.medium))
                    .submitLabel(.done)
                    .textFieldStyle(.plain)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background {
                        ZStack {
                            Capsule().fill(.backgroundsecondary)
                                .stroke(.quaternary)
                            HStack {
                                Spacer()
                                Image(systemName: "pencil")
                                    .foregroundStyle(.secondary)
                            }
                            .padding()
                        }
                    }
                    .padding(.bottom)
                Button(action: {
                    user.send_car_request(start: Int(calendarModel.startEditDate.timeIntervalSince1970), end: Int(calendarModel.endEditDate.timeIntervalSince1970), reason: reason)
                    showingRequestSheet = false
                }) {
                    CapsuleButton(text: Text("**Send Request**"), lit: false, color: .red)
                }
                .buttonStyle(.plain)
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
