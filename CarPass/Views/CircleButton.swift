//
//  CircleButton.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-18.
//

import SwiftUI

struct CircleButton: View {
    @Environment(\.colorScheme) private var colorScheme
    var systemName: String
    var body: some View {
        if (colorScheme == .dark) {
            Image(systemName: systemName)
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white.gradient, .bar)
                //.compositingGroup()
                .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
        } else {
            Image(systemName: systemName)
                .symbolRenderingMode(.palette)
                .foregroundStyle(.black.gradient.opacity(0.85), .bar)
                .compositingGroup()
                .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 2)
        }
    }
}

#Preview {
    CircleButton(systemName: "person.circle.fill")
        .font(.largeTitle)
}
