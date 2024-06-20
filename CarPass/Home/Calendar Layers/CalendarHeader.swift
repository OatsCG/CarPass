//
//  CalendarHeader.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-20.
//

import SwiftUI

struct CalendarHeader: View {
    var body: some View {
        HStack {
            Button(action: {
                // go back one month
            }) {
                Image(systemName: "chevron.backward")
                    .font(.largeTitle)
                    .symbolRenderingMode(.hierarchical)
            }
                .tint(.primary)
            Spacer()
            Button(action: {
                // open month/year picker
            }) {
                Text("June 2024")
                    .font(.title3 .bold())
            }
                .tint(.primary)
            Spacer()
            Button(action: {
                // go forward one month
            }) {
                Image(systemName: "chevron.forward")
                    .font(.largeTitle)
                    .symbolRenderingMode(.hierarchical)
            }
                .tint(.primary)
        }
            .frame(height: 30)
            .safeAreaPadding()
    }
}

#Preview {
    CalendarHeader()
}
