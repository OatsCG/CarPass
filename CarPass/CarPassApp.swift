//
//  CarPassApp.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-18.
//

import SwiftUI

@main
struct CarPassApp: App {
    @State var user: User = User()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(user)
        }
    }
}
