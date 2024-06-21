//
//  CarInviteAlert.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-20.
//

import SwiftUI

struct CarInviteAlert: View {
    @Environment(User.self) var user
    var carID: CarID
    var body: some View {
        HStack(alignment: .bottom) {
            VStack(spacing: 18) {
                //Spacer()
                VStack(spacing: 16) {
                    HStack {
                        Image(systemName: "car.fill")
                            .font(.title2)
                            .foregroundStyle(.primary)
                        Text("You're Invited to **\(carID)**")
                            .fontWeight(.medium)
                            .font(.title3)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                }
                .padding(.top, 5)
                .padding(.horizontal, 10)
                HStack(spacing: 8) {
                    Button(action: {
                        user.accept_invite(carID: carID)
                    }) {
                        CapsuleButton(text: Text("\(Image(systemName: "checkmark")) Accept").font(.title3).fontWeight(.medium), lit: false, height: 45, color: .red)
                    }
                    .buttonStyle(.plain)
                    Button(action: {
                        user.dismiss_invite(carID: carID)
                    }) {
                        CapsuleButton(text: Text("\(Image(systemName: "xmark"))").font(.title3).fontWeight(.medium), lit: false, height: 45, color: .red)
                            .frame(width: 45)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.all, 10)
            //.safeAreaPadding(.horizontal, 20)
            //.safeAreaPadding(.top, 15)
        }
        .background {
            RoundedRectangle(cornerRadius: 30, style: .circular)
                .fill(.clear)
                .stroke(.quaternary)
            
        }
    }
}

#Preview {
    VStack {
        Spacer()
        CarInviteAlert(carID: "CT3G")
            .padding(10)
        Spacer()
    }
    .background(.custombackground)
}
