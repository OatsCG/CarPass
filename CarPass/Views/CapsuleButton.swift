//
//  CapsuleButton.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-18.
//

import SwiftUI

struct CapsuleButton: View {
    @State var text: Text
    @State var lit: Bool
    @State var height: CGFloat = 55
    var color: CustomColor
    var body: some View {
        HStack {
            Spacer()
            Text("\(text)")
                .foregroundStyle(lit ? cc(color, style: .primary) : .primary)
            Spacer()
        }
            .frame(height: height)
            .background {
                if lit {
                    ZStack {
                        Capsule()
                            .fill(cc(color, style: .thick))
                            .offset(y: -1)
                        Capsule()
                            .fill(.quinary)
                            .offset(y: -1)
                        Capsule()
                            .fill(cc(color, style: .thick))
                    }
                } else {
                    ZStack {
                        Capsule()
                            .fill(.backgroundsecondary)
                            .offset(y: -1)
                        Capsule()
                            .fill(.quinary)
                            .offset(y: -1)
                        Capsule()
                            .fill(.backgroundsecondary)
                    }
                }
            }
    }
}



#Preview {
    CapsuleButton(text: Text("Request Car"), lit: true, color: .red)
}
