//
//  CalendarCaps.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-21.
//

import SwiftUI

struct CalendarDayCap: View {
    var color: CustomColor?
    var inMonth: Bool
    var paddingAmount: CGFloat
    var cap: CapType
    var isEditing: Bool = false
    var body: some View {
        ZStack {
            if !isEditing {
                CalendarDayCapPicked(color: color ?? .blue, inMonth: inMonth, paddingAmount: paddingAmount, cap: cap, isEditing: isEditing)
                    .brightness(0.07)
                    .offset(y: -1)
            }
            CalendarDayCapPicked(color: color ?? .blue, inMonth: inMonth, paddingAmount: paddingAmount, cap: cap, isEditing: isEditing)
        }
    }
}

struct CalendarDayCapPicked: View {
    var color: CustomColor
    var inMonth: Bool
    var paddingAmount: CGFloat
    var cap: CapType
    var isEditing: Bool
    var body: some View {
        Group {
            switch cap {
            case .none:
                Circle()
                    .fill(.clear)
            case .start:
                CalendarDayStartCap(color: color, inMonth: inMonth, paddingAmount: paddingAmount, isEditing: isEditing)
            case .mid:
                CalendarDayMidCap(color: color, inMonth: inMonth, paddingAmount: paddingAmount, isEditing: isEditing)
            case .end:
                CalendarDayEndCap(color: color, inMonth: inMonth, paddingAmount: paddingAmount, isEditing: isEditing)
            case .startandend:
                CalendarDayStartandendCap(color: color, inMonth: inMonth, paddingAmount: paddingAmount, isEditing: isEditing)
            }
        }
    }
}

struct CalendarDayStartCap: View {
    var color: CustomColor
    var inMonth: Bool
    var paddingAmount: CGFloat
    var isEditing: Bool
    var body: some View {
        ZStack {
            UnevenRoundedRectangle(topLeadingRadius: 100, bottomLeadingRadius: 100, bottomTrailingRadius: 0, topTrailingRadius: 0)
                .fill(cc(color, style: inMonth ? .thick : .thin))
                .padding(.leading, paddingAmount)
                .padding(.vertical, paddingAmount / 2)
        }
    }
}

struct CalendarDayMidCap: View {
    var color: CustomColor
    var inMonth: Bool
    var paddingAmount: CGFloat
    var isEditing: Bool
    var body: some View {
        Rectangle()
            .fill(cc(color, style: inMonth ? .thick : .thin))
            .padding(.vertical, paddingAmount / 2)
    }
}

struct CalendarDayEndCap: View {
    var color: CustomColor
    var inMonth: Bool
    var paddingAmount: CGFloat
    var isEditing: Bool
    var body: some View {
        UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 0, bottomTrailingRadius: 100, topTrailingRadius: 100)
            .fill(cc(color, style: inMonth ? .thick : .thin))
            .padding(.trailing, paddingAmount)
            .padding(.vertical, paddingAmount / 2)
    }
}

struct CalendarDayStartandendCap: View {
    var color: CustomColor
    var inMonth: Bool
    var paddingAmount: CGFloat
    var isEditing: Bool
    @State var rotation: CGFloat = 0
    var body: some View {
        Group {
            if isEditing {
                Circle()
                    .stroke(cc(color, style: .primary), style: .init(lineWidth: 2, lineCap: .round, dash: [5, 8], dashPhase: 0))
            } else {
                Circle()
                    .fill(cc(color, style: inMonth ? .thick : .thin))
            }
            //.stroke(cc(color, style: .primary), style: .init(lineWidth: 2, lineCap: .round, dash: [5, 8], dashPhase: 0))
        }
            .padding(.vertical, paddingAmount / 2)
            .padding(.horizontal, paddingAmount / 2)
            .rotationEffect(.degrees(rotation))
            .onAppear {
                withAnimation(.linear(duration: 6).repeatForever(autoreverses: false)) {
                    rotation += 360
                }
            }
    }
}


#Preview {
    HomeView()
        .environment(User())
}
