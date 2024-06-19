//
//  CarStatusView.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-18.
//

import SwiftUI

struct CarStatusView: View {
    var body: some View {
        VStack {
            Text("**Simon** has the car")
                .font(.title2)
            Text("Until Friday")
                .foregroundStyle(.secondary)
            HStack(spacing: 10) {
                Button(action: {
                    
                }) {
                    CapsuleButton(text: Text("Request Car"), lit: true, color: .blue)
                }
                Button(action: {
                    
                }) {
                    CapsuleButton(text: Text("I Have The Car"), lit: false, color: .blue)
                }
            }
            .bold()
            .buttonStyle(.plain)
            .padding(.vertical, 10)
        }
            .multilineTextAlignment(.leading)
    }
}

#Preview {
    HomeView()
        .environment(User())
}
