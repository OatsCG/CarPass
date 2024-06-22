//
//  CarStatusView.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-18.
//

import SwiftUI

struct CarStatusView: View {
    @Environment(User.self) var user
    @State var showingHaveCarAlert: Bool = false
    @State var showingRequestSheet: Bool = false
    @State var carimageon: Bool = false
    var body: some View {
        VStack {
            if let whohasthecar = user.whohasthecar {
                HStack {
                    Spacer()
                    Image(.carforwardon)
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal, -50)
                        .padding(.vertical, -50)
                        
                    Spacer()
                }
                Text("**\(whohasthecar.name)** has the car")
                    .font(.title2)
                    .contentTransition(.numericText(countsDown: true))
            } else {
                HStack {
                    Spacer()
                    Image(.carforwardmid)
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal, -50)
                    Spacer()
                }
                ProgressView()
                    .padding()
            }
            HStack(spacing: 10) {
                Button(action: {
                    showingRequestSheet = true
                }) {
                    CapsuleButton(text: Text("Request Car"), lit: true, color: user.myColor)
                }
                Button(action: {
                    showingHaveCarAlert = true
                }) {
                    CapsuleButton(text: Text("I Have The Car"), lit: false, color: user.myColor)
                }
            }
            .bold()
            .buttonStyle(.plain)
            .padding(.vertical, 10)
        }
            .multilineTextAlignment(.leading)
            .padding(.top, 30)
            .alert(isPresented: $showingHaveCarAlert) {
                Alert(
                    title: Text("Do you really have the car?"),
                    primaryButton: .default(Text("Yes")) {
                        user.update_ihavecar()
                    },
                    secondaryButton: .cancel()
                )
            }
            .sheet(isPresented: $showingRequestSheet, content: {
                RequestCarSheet(showingRequestSheet: $showingRequestSheet)
            })
    }
}

#Preview {
    HomeView()
        .environment(User())
}
