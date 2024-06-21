//
//  ActionButtonsView.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-18.
//

import SwiftUI

struct ActionButtonsView: View {
    @Environment(User.self) var user
    @State var showingProfileSheet: Bool = false
    var body: some View {
        VStack {
            HStack {
                Text("CarPass")
                    .font(.title3 .bold())
                Spacer()
                Button(action: {
                    // open profile sheet
                    showingProfileSheet = true
                }) {
                    SymbolButton(systemName: "person.text.rectangle.fill", color: user.myColor)
                        .font(.largeTitle)
                        .foregroundStyle(cc(user.myColor, style: .primary))
                        //.scaleEffect(2)
                }
                    .tint(.primary)
            }
            .overlay {
                HStack {
                    Spacer()
                    if user.fetchStatus == .failed {
                        Text("\(Image(systemName: "exclamationmark.triangle.fill")) No Connection")
                            .font(.caption)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 7)
                            .background {
                                ZStack {
                                    Capsule().fill(.red)
                                        .brightness(0.2)
                                        .offset(y: -1)
                                    Capsule().fill(.red)
                                }
                            }
                    } else {
                        Text("last updated: \(formatTime(user.lastUpdated))")
                            .font(.caption2)
                            .foregroundStyle(.quaternary)
                    }
                    Spacer()
                }
            }
        }
        .frame(height: 30)
        .padding([.horizontal, .bottom], 15)
        .padding(.top, 10)
        .background {
            UnevenRoundedRectangle(cornerRadii: .init(topLeading: 47, bottomLeading: 10, bottomTrailing: 10, topTrailing: 47), style: .continuous).fill(.shadow(.inner(color: cc(user.myColor, style: .thin), radius: 30)))
                .foregroundStyle(.custombackground)
                .ignoresSafeArea()
        }
        .background(.custombackground)
        .compositingGroup()
        .shadow(radius: 10)
        .sheet(isPresented: $showingProfileSheet, content: {
            ProfileSheet(showingProfileSheet: $showingProfileSheet)
                .environment(user)
        })
    }
}

func formatTime(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm:ss"
    return formatter.string(from: date)
}

#Preview {
    HomeView()
        .environment(User())
}
