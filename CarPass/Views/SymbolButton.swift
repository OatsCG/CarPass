//
//  SymbolButton.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-19.
//

import SwiftUI

struct SymbolButton: View {
    var systemName: String
    var body: some View {
        ZStack {
            Image(systemName: systemName)
                .symbolRenderingMode(.palette)
                .foregroundStyle(.primary, .backgroundsecondary)
            Image(systemName: systemName)
                .symbolRenderingMode(.palette)
                .foregroundStyle(.quinary, .quinary)
                .offset(y: -1)
            Image(systemName: systemName)
                .symbolRenderingMode(.palette)
                .foregroundStyle(.primary, .backgroundsecondary)
        }
    }
}

#Preview {
    SymbolButton(systemName: "person.text.rectangle.fill")
        .font(.largeTitle)
        .scaleEffect(4)
}
