//
//  ContentView.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-18.
//

import SwiftUI

struct ContentView: View {
    @Environment(User.self) var user
    var body: some View {
        if (user.fetchStatus == .waiting || user.isPushUpdatingCar) {
            ProgressView()
        } else if user.fetchStatus == .failed {
            ContentUnavailableView("No Connection to Server", systemImage: "network.slash", description: Text("Try again later."))
        } else {
            HomeView()
        }
    }
}

#Preview {
    ContentView()
        .environment(User())
}
