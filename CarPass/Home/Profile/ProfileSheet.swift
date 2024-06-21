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
    @State var carNameEditor: String = "Car 1"
    @State var showingInviteSheet: Bool = false
    @State var showingJoinSheet: Bool = false
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
                            Spacer()
                            Text("User ID: **\(user.userID)**")
                        }
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 8)
                        TextField("Username", text: $nameEditor)
                            .font(.headline .weight(.medium))
                            .onAppear {
                                nameEditor = user.username
                            }
                            .onSubmit {
                                user.update_name(to: nameEditor)
                            }
                            .onChange(of: user.username) {
                                nameEditor = user.username
                            }
                            .submitLabel(.done)
                            .textFieldStyle(.plain)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background {
                                ZStack {
                                    Capsule().fill(.backgroundsecondary)
                                        .stroke(.quaternary)
                                    HStack {
                                        Spacer()
                                        Image(systemName: "pencil")
                                            .foregroundStyle(.secondary)
                                    }
                                    .padding()
                                }
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
                            Spacer()
                            if let car = user.car {
                                Text("Car ID: **\(car)**")
                            }
                        }
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.top, 30)
                        TextField("Car Name...", text: $carNameEditor)
                            .font(.headline .weight(.medium))
                            .onAppear {
                                carNameEditor = user.carname
                            }
                            .onSubmit {
                                user.update_car_name(to: carNameEditor)
                            }
                            .onChange(of: user.carname) {
                                carNameEditor = user.carname
                            }
                            .submitLabel(.done)
                            .textFieldStyle(.plain)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background {
                                ZStack {
                                    Capsule().fill(.backgroundsecondary)
                                        .stroke(.quaternary)
                                    HStack {
                                        Spacer()
                                        Image(systemName: "pencil")
                                            .foregroundStyle(.secondary)
                                    }
                                    .padding()
                                }
                            }
                        VStack(spacing: 10) {
                            ForEach(user.carUsers, id: \.id) { caruser in
                                CarProfileCapsule(text: caruser.name, pending: !caruser.confirmed, color: strtocc(caruser.color), isMe: caruser.id == user.userID)
                            }
                            Button(action: {
                                showingInviteSheet = true
                            }) {
                                CapsuleButton(text: Text("**Invite...**"), lit: false, color: .red)
                            }
                            .buttonStyle(.plain)
                        }
                        
                        VStack(spacing: 10) {
                            ForEach(user.carInvites, id: \.self) { carid in
                                CarInviteAlert(carID: carid)
                            }
                        }
                        .padding(.vertical, 20)
                        
                        Button(action: {
                            showingJoinSheet = true
                        }) {
                            CapsuleButton(text: Text("**Join Another Car...**"), lit: false, color: .red)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .safeAreaPadding()
            }
            .background(.custombackground)
        }
        .sheet(isPresented: $showingInviteSheet, content: {
            InviteUserSheet(showingInviteSheet: $showingInviteSheet)
        })
        .sheet(isPresented: $showingJoinSheet, content: {
            JoinCarSheet(showingJoinSheet: $showingJoinSheet)
        })
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
