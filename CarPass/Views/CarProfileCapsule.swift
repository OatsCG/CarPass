//
//  CarProfileCapsule.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-19.
//

import SwiftUI

struct CarProfileCapsule: View {
    @State var text: String
    @State var pending: Bool
    @State var height: CGFloat = 55
    var color: CustomColor
    var isMe: Bool
    var body: some View {
        HStack {
            Image(systemName: "person.fill")
                .foregroundStyle(cc(color, style: .primary))
            Text(text)
                .foregroundStyle(.primary)
            Spacer()
            
            if isMe {
                Text("Me")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.trailing, 5)
            }
            
            if pending {
                Text("Invite sent")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.trailing, 5)
            }
        }
            .padding(.horizontal, 15)
            .frame(height: height)
            .background {
                Capsule()
                    .fill(pending ? .clear : cc(color, style: .thin))
                    .stroke(pending ? .tertiary : .quaternary, style: .init(dash: .init(repeating: 10, count: pending ? 1 : 0)))
                    //.stroke(.quaternary)
            }
    }
}

#Preview {
    VStack {
        Spacer()
        CarProfileCapsule(text: "Charlie", pending: true, color: .red, isMe: false)
        Spacer()
    }
        .background(.custombackground)
}
