//
//  CalendarCaps.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-21.
//

import SwiftUI

struct CalendarDayCap: View {
    var color: CustomColor
    var inMonth: Bool
    var paddingAmount: CGFloat
    var cap: CapType
    var body: some View {
        ZStack {
            CalendarDayCapPicked(color: color, inMonth: inMonth, paddingAmount: paddingAmount, cap: cap)
                .brightness(0.07)
                .offset(y: -1)
            CalendarDayCapPicked(color: color, inMonth: inMonth, paddingAmount: paddingAmount, cap: cap)
        }
    }
}

struct CalendarDayCapPicked: View {
    var color: CustomColor
    var inMonth: Bool
    var paddingAmount: CGFloat
    var cap: CapType
    var body: some View {
        Group {
            if (cap == .start) {
                CalendarDayStartCap(color: color, inMonth: inMonth, paddingAmount: paddingAmount)
            } else if (cap == .mid) {
                CalendarDayMidCap(color: color, inMonth: inMonth, paddingAmount: paddingAmount)
            } else if (cap == .end) {
                CalendarDayEndCap(color: color, inMonth: inMonth, paddingAmount: paddingAmount)
            } else {
                Circle()
                    .fill(.clear)
            }
        }
    }
}

struct CalendarDayStartCap: View {
    var color: CustomColor
    var inMonth: Bool
    var paddingAmount: CGFloat
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
    var body: some View {
        UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 0, bottomTrailingRadius: 100, topTrailingRadius: 100)
            .fill(cc(color, style: inMonth ? .thick : .thin))
            .padding(.trailing, paddingAmount)
            .padding(.vertical, paddingAmount / 2)
    }
}


#Preview {
    HomeView()
        .environment(User())
}
