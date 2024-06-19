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
    @State var accepted: Bool
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
                        Text("Charlie")
                            .fontWeight(.medium)
                            .font(.title2)
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Text("Tomorrow")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    VStack {
                        HStack {
                            Text("Until June 5")
                                .font(.subheadline)
                            Spacer()
                        }
                        HStack {
                            Text("Starting tomorrow")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Spacer()
                        }
                    }
                }
                .padding(.top, 5)
                .padding(.horizontal, 10)
                HStack(spacing: 8) {
                    Button(action: {}) {
                        CapsuleButton(text: Text("\(Image(systemName: "checkmark")) Accept").font(.title3).fontWeight(.medium), lit: false, height: 45, color: .yellow)
                    }
                    Button(action: {}) {
                        CapsuleButton(text: Text("\(Image(systemName: "xmark"))").font(.title3).fontWeight(.medium), lit: true, height: 45, color: color)
                            .frame(width: 45)
                        
                    }
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
    CarRequestAlert(name: "Simon", reason: "I just want it", range: "Today", accepted: false, color: .red)
        .padding(10)
}
