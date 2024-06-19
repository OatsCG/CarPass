//
//  ProfileSheet.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-19.
//

import SwiftUI

struct ProfileSheet: View {
    @Environment(User.self) var user
    @State var nameEditor: String = "Charlie"
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                HStack {
                    Text("Profile")
                        .font(.title2 .bold())
                    Spacer()
                    Button(action: {
                        
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
                // Name editor
                VStack {
                    HStack {
                        Text("Name")
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
                        Text("Colour")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                    .padding(.horizontal, 8)
                    TextField("Username", text: $nameEditor)
                        .font(.headline .weight(.medium))
                        .onSubmit {
                            //user.update_name(nameEditor)
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
            }
        }
        .safeAreaPadding()
        
        .background(.custombackground)
    }
}

#Preview {
    //testview()
    ProfileSheet()
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
            ProfileSheet()
                .environment(User())
        })
    }
}
