//
//  LoadingView.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-22.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image(.carforwardoff)
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, -50)
                    .padding(.top, 50)
                Spacer()
            }
            Spacer()
            ProgressView()
                .scaleEffect(1.5)
            Spacer()
        }
        .background(.custombackground)
    }
}

#Preview {
    LoadingView()
}
