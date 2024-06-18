//
//  RangeStatusView.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-18.
//

import SwiftUI

struct RangeStatusView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Charlie")
                    .font(.footnote)
                    .textCase(.uppercase)
                    .lineLimit(1)
                    .bold()
                    .foregroundStyle(.secondary)
                Spacer()
                Image(systemName: "arrowshape.forward.fill")
                    .foregroundStyle(.tertiary)
            }
            HStack {
                Text("June 5 - June 10")
                    .bold()
                    .font(.subheadline)
                Spacer()
            }
        }
            .padding(8)
            .background(.blue.gradient)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    HomeView()
        .environment(User())
}
