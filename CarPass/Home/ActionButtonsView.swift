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
                        .bold()
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .background {
                            RoundedRectangle(cornerRadius: 8).fill(.shadow(.drop(color: .black.opacity(0.2), radius: 3, x: 0, y: 2)))
                                .foregroundStyle(.bar)
                        }
                }
                    .tint(.primary)
                
                Spacer()
                Button(action: {
                    // go back one month
                }) {
                    CircleButton(systemName: "person.circle.fill")
                        .font(.largeTitle)
                        //.scaleEffect(2)
                }
                    .tint(.primary)
            }
        }
        .frame(height: 30)
        .padding(15)
        .background {
            Rectangle().fill(.shadow(.inner(color: .black.opacity(0.1), radius: 20)))
                .foregroundStyle(.ultraThinMaterial)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    HomeView()
        .environment(User())
}
