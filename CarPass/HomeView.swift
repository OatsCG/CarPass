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
            ScrollView {
                CalendarView()
                VStack {
                    CarRequestAlert(name: "Simon", reason: "I just want it", range: "Today", accepted: false, color: .red)
                    CarRequestAlert(name: "Simon", reason: "I just want it", range: "Today", accepted: false, color: .red)
                    CarRequestAlert(name: "Simon", reason: "I just want it", range: "Today", accepted: false, color: .red)
                }
            }
            .safeAreaPadding()
        }
    }
}

#Preview {
    HomeView()
        .environment(User())
}
