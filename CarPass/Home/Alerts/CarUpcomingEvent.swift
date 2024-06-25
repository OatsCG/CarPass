//
//  CarUpcomingEvent.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-19.
//

import SwiftUI

struct CarUpcomingEvent: View {
    @Environment(User.self) var user
    var userid: String
    var name: String
    var rangeID: String
    var reason: String
    var range: String
    var rangeRelative: String
    var color: CustomColor
    var mustBring: Bool
    @State var showingRevokeAlert: Bool = false
    var body: some View {
        HStack(alignment: .bottom) {
            VStack(spacing: 18) {
                //Spacer()
                VStack(spacing: 16) {
                    HStack {
                        Image(systemName: "person.fill")
                            .font(.title2)
                            .foregroundStyle(cc(color, style: .primary))
                        Text(name)
                            .fontWeight(.medium)
                            .font(.title2)
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Text(range)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    VStack(spacing: 5) {
                        HStack {
                            Text(reason)
                                .font(.subheadline)
                            Spacer()
                        }
                        HStack {
                            Text(rangeRelative)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Spacer()
                        }
                    }
                    if mustBring {
                        HStack {
                            Text("\(Image(systemName: "steeringwheel")) You must bring the car to \(Text(name).fontWeight(.medium))")
                                .foregroundStyle(cc(color, style: .primary))
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                    }
                }
                .padding(.top, 5)
                .padding(.horizontal, 10)
                .padding(.bottom, 5)
                if (userid == user.userID) {
                    Button(action: {
                        showingRevokeAlert = true
                    }) {
                        CapsuleButton(text: Text("Revoke Request"), lit: true, color: .orange)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.all, 10)
            //.safeAreaPadding(.horizontal, 20)
            //.safeAreaPadding(.top, 15)
            //blah
        }
        .background {
            RoundedRectangle(cornerRadius: 30, style: .circular)
                .fill(cc(color, style: .thin))
                .stroke(.quaternary)
        }
        .padding(.bottom, mustBring ? 10 : 0)
        .alert(isPresented: $showingRevokeAlert) {
            Alert(
                title: Text("Remove your request for \(range)?"),
                primaryButton: .default(Text("Yes")) {
                    user.revoke_car_request(rangeID: rangeID)
                },
                secondaryButton: .cancel()
            )
        }
    }
}

#Preview {
    CarUpcomingEvent(userid: "1234", name: "Simon", rangeID: "5678", reason: "I just want it", range: "Jun 26 - Jun 29", rangeRelative: "In 1 Day", color: .orange, mustBring: true)
        .padding(10)
}
