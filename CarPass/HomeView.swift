//
//  HomeView.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-18.
//

import SwiftUI

struct HomeView: View {
    @Environment(User.self) var user
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ActionButtonsView()
                    .hidden()
                ScrollView {
                    VStack {
                        CarStatusView()
                        Spacer(minLength: 30)
                        Divider()
                        CalendarView(editingEnabled: false)
                        Divider()
                        Spacer(minLength: 30)
                        if user.pendingAlerts.count != 0 {
                            VStack(spacing: 10) {
                                HStack {
                                    Text("Pending")
                                        .foregroundStyle(.secondary)
                                        .font(.title3 .bold())
                                    Spacer()
                                }
                                .padding()
                                ForEach(user.pendingAlerts, id: \.id) { alert in
                                    CarRequestAlert(name: alert.name, reason: alert.reason, range: alert.rangeDescription, rangeRelative: alert.rangeRelativeDescription, color: alert.color)
                                }
                            }
                            Spacer(minLength: 30)
                        }
                        VStack(spacing: 10) {
                            HStack {
                                Text("Upcoming")
                                    .foregroundStyle(.secondary)
                                    .font(.title3 .bold())
                                Spacer()
                            }
                            .padding()
                            if user.confirmedAlerts.count == 0 {
                                Text("No Upcoming Events")
                                    .foregroundStyle(.tertiary)
                                    .font(.headline)
                                    .padding()
                            } else {
                                ForEach(user.confirmedAlerts, id: \.id) { alert in
                                    CarUpcomingEvent(name: alert.name, reason: alert.reason, range: alert.rangeDescription, rangeRelative: alert.rangeRelativeDescription, color: alert.color, mustBring: alert.mustBring)
                                }
                            }
                        }
                    }
                    .safeAreaPadding()
                }
                .scrollIndicators(.hidden)
                .background(.custombackground)
            }
            VStack {
                ActionButtonsView()
                Spacer()
            }
        }
//        .onOpenURL { url in
//            if let host = url.host, url.scheme == "carpassapp", url.pathComponents.count > 1 {
//                let carID = url.pathComponents[1]
//                user.force_accept_invite(carID: carID)
//            }
//        }
    }
}

#Preview {
    HomeView()
        .environment(User())
}
