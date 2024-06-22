//
//  LoadingView.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-22.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ScrollView {
            HStack {
                Spacer()
                Image(.carforwardoff)
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, -50)
                    .padding(.top, 50)
                Spacer()
            }
        }
        .background(.custombackground)
    }
}

#Preview {
    LoadingView()
}
