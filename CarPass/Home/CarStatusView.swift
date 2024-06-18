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
            HStack {
                Image(systemName: "car.fill")
                    .font(.largeTitle)
                Spacer()
                Text("**Charlie Giannis** has the car.")
                    .font(.title)
                    .multilineTextAlignment(.leading)
            }
            ScrollView(.horizontal) {
                HStack {
                    
                }
            }
        }
        .padding(20)
        .frame(height: 150)
        .background(.cyan.gradient)
    }
}

#Preview {
    HomeView()
        .environment(User())
}
