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
            ActionButtonsView()
            CalendarView()
            CarStatusView()
        }
    }
}

#Preview {
    HomeView()
        .environment(User())
}
