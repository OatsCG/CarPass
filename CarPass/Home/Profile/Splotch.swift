//
//  Splotch.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-19.
//

import SwiftUI

struct Splotch: View {
    @Environment(User.self) var user
    var color: CustomColor
    @State var selected: Bool
    init(_ color: CustomColor) {
        self.color = color
        self.selected = false
    }
    var body: some View {
        Group {
            if selected {
                Circle().fill(cc(color))
                    .mask {
                        ZStack {
                            Circle().fill(.white)
                            Circle().fill(.white)
                                .scaleEffect(0.78)
                                .blendMode(.destinationOut)
                        }
                    }
                    .overlay {
                        Circle().fill(cc(color))
                            .scaleEffect(0.58)
                    }
            } else {
                Button(action: {
                    user.update_color(to: self.color)
                }) {
                    Circle().fill(cc(color))
                }
                .buttonStyle(.plain)
            }
        }
        .onAppear {
            updateColor()
        }
        .onChange(of: user.myColor) {
            updateColor()
        }
    }
    func updateColor() {
        selected = user.myColor == self.color
    }
}

#Preview {
    Splotch(.blue)
        .environment(User())
}
