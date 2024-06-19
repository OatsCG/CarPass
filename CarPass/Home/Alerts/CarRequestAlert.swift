//
//  CarRequestAlert.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-18.
//

import SwiftUI

struct CarRequestAlert: View {
    var name: String
    var reason: String
    var range: String
    var color: CustomColor
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
                }
                .padding(.top, 5)
                .padding(.horizontal, 10)
                HStack(spacing: 8) {
                    Button(action: {

                    }) {
                        CapsuleButton(text: Text("\(Image(systemName: "checkmark")) Accept").font(.title3).fontWeight(.medium), lit: true, height: 45, color: color)
                    }
                    .buttonStyle(.plain)
                    Button(action: {}) {
                        CapsuleButton(text: Text("\(Image(systemName: "xmark"))").font(.title3).fontWeight(.medium), lit: true, height: 45, color: color)
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
                .fill(cc(color, style: .thin))
                .stroke(.quaternary)
            
        }
    }
}

#Preview {
    CarRequestAlert(name: "Simon", reason: "I just want it", range: "Tomorrow", color: .orange)
        .padding(10)
}
