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
        VStack(spacing: 3) {
            //ActionButtonsView()
            CarStatusView()
                .safeAreaPadding([.horizontal, .top])
            ScrollView {
                CalendarView()
                Spacer(minLength: 30)
                VStack(spacing: 10) {
                    HStack {
                        Text("Pending")
                            .foregroundStyle(.secondary)
                            .font(.title3 .bold())
                        Spacer()
                    }
                    .padding()
                    CarRequestAlert(name: "Simon", reason: "I just want it", range: "Tomorrow", color: .pink)
                    CarRequestAlert(name: "Ben", reason: "for cottage", range: "Tomorrow", color: .red)
                }
                Spacer(minLength: 30)
                VStack(spacing: 10) {
                    HStack {
                        Text("Upcoming")
                            .foregroundStyle(.secondary)
                            .font(.title3 .bold())
                        Spacer()
                    }
                    .padding()
                    CarUpcomingEvent(name: "Simon", reason: "school cause im too lazy to walk 5 minutes", range: "Tomorrow", color: .pink, mustBring: true)
                        .padding(.bottom, 10)
                    CarUpcomingEvent(name: "Dad", reason: "check engine", range: "Tomorrow", color: .orange, mustBring: false)
                    CarUpcomingEvent(name: "Charlie", reason: "work stuff", range: "Tomorrow", color: .blue, mustBring: false)
                }
            }
            .scrollIndicators(.hidden)
            .safeAreaPadding()
        }
    }
}

#Preview {
    HomeView()
        .environment(User())
}
