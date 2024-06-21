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
            CalendarView(editingEnabled: true)
                .frame(height: 350)
            
            Spacer()
        }
        .background(.custombackground)
    }
}

#Preview {
    RequestCarSheet(showingRequestSheet: .constant(true))
        .environment(User())
}
