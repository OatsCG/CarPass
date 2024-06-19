//
//  ActionButtonsView.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-18.
//

import SwiftUI

struct ActionButtonsView: View {
    @Environment(User.self) var user
    var body: some View {
        VStack {
            HStack {
                Text("CarPass")
                    .font(.title3 .bold())
                Spacer()
                Button(action: {
                    // open profile sheet
                }) {
                    SymbolButton(systemName: "person.text.rectangle.fill")
                        .font(.largeTitle)
                        .foregroundStyle(cc(user.myColor, style: .primary))
                        //.scaleEffect(2)
                }
                    .tint(.primary)
            }
        }
        .frame(height: 30)
        .padding([.horizontal, .bottom], 15)
        .background {
            UnevenRoundedRectangle(cornerRadii: .init(topLeading: 47, bottomLeading: 10, bottomTrailing: 10, topTrailing: 47), style: .continuous).fill(.shadow(.inner(color: cc(user.myColor, style: .thin), radius: 30)))
                .foregroundStyle(.custombackground)
                .ignoresSafeArea()
        }
        .compositingGroup()
        .shadow(radius: 10)
        //.shadow(color: .black, radius: 5, y: 2)
    }
}

#Preview {
    HomeView()
        .environment(User())
}
