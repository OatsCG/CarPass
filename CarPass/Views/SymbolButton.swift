//
//  SymbolButton.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-19.
//

import SwiftUI

struct SymbolButton: View {
    var systemName: String
    var color: CustomColor
    var body: some View {
        ZStack {
            Image(systemName: systemName)
                .symbolRenderingMode(.palette)
                .foregroundStyle(cc(color, style: .thin), cc(color, style: .thin))
                .offset(y: -1)
            Image(systemName: systemName)
                .symbolRenderingMode(.palette)
                .foregroundStyle(.quinary, .quinary)
                .offset(y: -1)
            Image(systemName: systemName)
                .symbolRenderingMode(.palette)
                .foregroundStyle(cc(color, style: .primary), .backgroundsecondary)
        }
    }
}

#Preview {
    SymbolButton(systemName: "person.text.rectangle.fill", color: .green)
        .font(.largeTitle)
        .scaleEffect(4)
}
