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
                    .foregroundStyle(.white.secondary)
                Spacer()
                Image(systemName: "arrowshape.forward.fill")
                    .foregroundStyle(.white.tertiary)
            }
            HStack {
                Text("June 5 - June 10")
                    .bold()
                    .font(.subheadline)
                    .foregroundStyle(.white)
                Spacer()
            }
        }
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(.green.gradient)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    HomeView()
        .environment(User())
}
