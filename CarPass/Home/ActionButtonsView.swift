//
//  ActionButtonsView.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-18.
//

import SwiftUI

struct ActionButtonsView: View {
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    // go back one month
                }) {
                    Text("Request Car")
                        .background(.red)
                }
                    .tint(.primary)
                
                Spacer()
                Button(action: {
                    // go back one month
                }) {
                    Image(systemName: "person.circle.fill")
                        .font(.largeTitle)
                        .symbolRenderingMode(.hierarchical)
                }
                    .tint(.primary)
            }
        }
        .frame(height: 30)
        .padding(15)
        .background {
            Rectangle().fill(.shadow(.inner(color: .primary.opacity(0.1), radius: 20)))
                .foregroundStyle(.ultraThinMaterial)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    HomeView()
        .environment(User())
}
