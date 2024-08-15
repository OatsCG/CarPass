//
//  CarRequestAlert.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-18.
//

import SwiftUI

struct CarRequestAlert: View {
    @Environment(User.self) var user
    var rangeID: RangeID
    var name: String
    var reason: String
    var range: String
    var rangeRelative: String
    var color: CustomColor
    var accepted: Bool = false
    var isMine: Bool
    var acceptedCount: Int
    @State var loadingIndicator: Bool = false
    @State var loadingIndicatorMineAcc: Bool = false
    @State var loadingIndicatorMineCanc: Bool = false
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
                            Text("\(acceptedCount) Accepted")
                                .font(.subheadline)
                                .foregroundStyle(.tertiary)
                        }
                    }
                }
                .padding(.top, 5)
                .padding(.horizontal, 10)
                if !isMine {
                    HStack(spacing: 8) {
                        Button(action: {
                            withAnimation {
                                loadingIndicatorMineAcc = true
                            }
                            user.accept_car_request(rangeID: rangeID)
                        }) {
                            if !loadingIndicatorMineAcc {
                                CapsuleButton(text: Text("\(Image(systemName: "checkmark")) Accept\(accepted ? "ed" : "")").font(.title3).fontWeight(.medium), lit: true, height: 45, color: color)
                            } else {
                                ZStack {
                                    CapsuleButton(text: Text("").font(.title3).fontWeight(.medium), lit: true, height: 45, color: color)
                                    ProgressView().progressViewStyle(.circular)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                        .disabled(accepted)
                        if !accepted {
                            Button(action: {
                                withAnimation {
                                    loadingIndicatorMineCanc = true
                                }
                                user.reject_car_request(rangeID: rangeID)
                            }) {
                                if !loadingIndicatorMineCanc {
                                    CapsuleButton(text: Text("\(Image(systemName: "xmark"))").font(.title3).fontWeight(.medium), lit: true, height: 45, color: color)
                                        .frame(width: 45)
                                } else {
                                    ZStack {
                                        CapsuleButton(text: Text("").font(.title3).fontWeight(.medium), lit: true, height: 45, color: color)
                                            .frame(width: 45)
                                        ProgressView().progressViewStyle(.circular)
                                    }
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                } else {
                    Button(action: {
                        withAnimation {
                            loadingIndicator = true
                        }
                        user.reject_car_request(rangeID: rangeID)
                    }) {
                        if !loadingIndicator {
                            CapsuleButton(text: Text("\(Image(systemName: "xmark")) Revoke Request").font(.title3).fontWeight(.medium), lit: true, height: 45, color: color)
                        } else {
                            ZStack {
                                CapsuleButton(text: Text("").font(.title3).fontWeight(.medium), lit: true, height: 45, color: color)
                                ProgressView().progressViewStyle(.circular)
                            }
                        }
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
        .disabled(loadingIndicator || loadingIndicatorMineAcc || loadingIndicatorMineCanc)
        .onChange(of: accepted) {
            withAnimation {
                loadingIndicatorMineAcc = false
            }
        }
    }
}

#Preview {
    CarRequestAlert(rangeID: "1234", name: "Simon", reason: "I just want it", range: "Jun 26 - Jun 28", rangeRelative: "Tomorrow", color: .orange, accepted: false, isMine: false, acceptedCount: 2)
        .padding(10)
        .environment(User())
}
