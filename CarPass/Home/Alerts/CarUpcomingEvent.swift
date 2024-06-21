//
//  CarUpcomingEvent.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-19.
//

import SwiftUI

struct CarUpcomingEvent: View {
    var name: String
    var reason: String
    var range: String
    var rangeRelative: String
    var color: CustomColor
    var mustBring: Bool
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
                        Text("In 1 day")
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
                            Text(range)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Spacer()
                        }
                    }
                    if mustBring {
                        HStack {
                            Text("\(Image(systemName: "steeringwheel")) You must bring the car to \(Text("Simon").fontWeight(.medium))")
                                .foregroundStyle(cc(color, style: .primary))
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                    }
                }
                .padding(.top, 5)
                .padding(.horizontal, 10)
                .padding(.bottom, 5)
            }
            .padding(.all, 10)
            //.safeAreaPadding(.horizontal, 20)
            //.safeAreaPadding(.top, 15)
        }
        .background {
            RoundedRectangle(cornerRadius: 30, style: .circular)
                .fill(cc(color, style: .thin))
                .stroke(.quaternary)
        }
        .padding(.bottom, mustBring ? 10 : 0)
    }
}

#Preview {
    CarUpcomingEvent(name: "Simon", reason: "I just want it", range: "Tomorrow", rangeRelative: "In 1 Day", color: .orange, mustBring: true)
        .padding(10)
}
