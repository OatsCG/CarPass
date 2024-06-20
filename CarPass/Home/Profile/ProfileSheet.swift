//
//  ProfileSheet.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-19.
//

import SwiftUI

struct ProfileSheet: View {
    @Environment(User.self) var user
    @State var nameEditor: String = "Username"
    @Binding var showingProfileSheet: Bool
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("My Profile")
                    .font(.title2 .bold())
                Spacer()
                Button(action: {
                    showingProfileSheet = false
                }) {
                    Text("Done")
                        .padding(.horizontal, 15)
                        .padding(.vertical, 7)
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.backgroundsecondary)
                                .strokeBorder(.secondary)
                        }
                }
            }
            .safeAreaPadding()
            .background {
                UnevenRoundedRectangle(cornerRadii: .init(topLeading: 47, bottomLeading: 10, bottomTrailing: 10, topTrailing: 47), style: .continuous).fill(.shadow(.inner(color: cc(user.myColor, style: .thin), radius: 30)))
                    .foregroundStyle(.custombackground)
                    .ignoresSafeArea()
            }
            .background(.custombackground)
            ScrollView {
                VStack(spacing: 30) {
                    // Name editor
                    VStack {
                        HStack {
                            Text("Name")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Spacer()
                        }
                        .padding(.horizontal, 8)
                        TextField("Username", text: $nameEditor)
                            .font(.headline .weight(.medium))
                            .onAppear {
                                nameEditor = user.username
                            }
                            .onSubmit {
                                print("UPDATING NAME")
                                user.update_name(to: nameEditor)
                            }
                            .submitLabel(.done)
                            .textFieldStyle(.plain)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background {
                                Capsule().fill(.backgroundsecondary)
                                    .stroke(.quaternary)
                            }
                    }
                    VStack {
                        HStack {
                            Text("Colour")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Spacer()
                        }
                        .padding(.horizontal, 8)
                        HStack(spacing: 10) {
                            Splotch(.red)
                            Splotch(.orange)
                            Splotch(.yellow)
                            Splotch(.green)
                            Splotch(.blue)
                            Splotch(.purple)
                            Splotch(.pink)
                        }
                    }
                    VStack {
                        HStack {
                            Text("Car")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Spacer()
                        }
                        .padding(.horizontal, 8)
                        VStack(spacing: 10) {
                            ForEach(user.carUsers, id: \.id) { caruser in
                                CarProfileCapsule(text: Text("\(caruser.name)"), pending: !caruser.confirmed, color: strtocc(caruser.color), isMe: caruser.id == user.userID)
                            }
                            if let car = user.car {
                                ShareLink(item: URL(string: "carpassapp://invite/\(car)")!) {
                                    CapsuleButton(text: Text("Invite..."), lit: false, color: .red)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
            }
            .safeAreaPadding()
            
            .background(.custombackground)
        }
    }
}

#Preview {
    //testview()
    ProfileSheet(showingProfileSheet: .constant(true))
        .environment(User())
}

struct testview: View {
    @State var pres: Bool = false
    var body: some View {
        Button(action: {
            pres = true
        }) {
            Text("press me! \(pres)")
                .font(.largeTitle .bold())
        }
        .sheet(isPresented: $pres, content: {
            ProfileSheet(showingProfileSheet: .constant(true))
                .environment(User())
        })
    }
}
