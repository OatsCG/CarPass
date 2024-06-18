//
//  CarStatusView.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-18.
//

import SwiftUI

struct CarStatusView: View {
    var body: some View {
        VStack(spacing: 18) {
            Spacer()
            HStack {
                Image(systemName: "car.fill")
                    .font(.largeTitle)
                Spacer()
                Text("**Charlie** has the car.")
                    .font(.title2)
                    .multilineTextAlignment(.leading)
            }
            ScrollView(.horizontal) {
                HStack {
                    RangeStatusView()
                        .containerRelativeFrame(.horizontal, count: 2, spacing: 10.0)
                    RangeStatusView()
                        .containerRelativeFrame(.horizontal, count: 2, spacing: 10.0)
                    RangeStatusView()
                        .containerRelativeFrame(.horizontal, count: 2, spacing: 10.0)
                    RangeStatusView()
                        .containerRelativeFrame(.horizontal, count: 2, spacing: 10.0)
                    RangeStatusView()
                        .containerRelativeFrame(.horizontal, count: 2, spacing: 10.0)
                }
                .scrollTargetLayout()
                .padding(.bottom, 10)
            }
            .scrollTargetBehavior(.viewAligned)
            //.safeAreaPadding(.horizontal, 10)
            
        }
        .safeAreaPadding(.horizontal, 20)
        .frame(height: 120)
        .background(.cyan.gradient)
    }
}

#Preview {
    HomeView()
        .environment(User())
}
