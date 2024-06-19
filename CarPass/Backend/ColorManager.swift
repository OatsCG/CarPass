//
//  ColorManager.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-19.
//

import Foundation
import SwiftUI

enum CustomColor {
    case red, orange, yellow, green, blue, purple, pink
}

enum CustomStyle {
    case primary, secondary, thick, thin
}


func cc(_ color: CustomColor, style: CustomStyle = .primary) -> Color {
    switch color {
    case .red:
        switch style {
        case .primary:
            return .redprimary
        case .secondary:
            return .redsecondary
        case .thick:
            return .redbgthick
        case .thin:
            return .redbgthin
        }
    case .orange:
        switch style {
        case .primary:
            return .orangeprimary
        case .secondary:
            return .orangesecondary
        case .thick:
            return .orangebgthick
        case .thin:
            return .orangebgthin
        }
    case .yellow:
        switch style {
        case .primary:
            return .yellowprimary
        case .secondary:
            return .yellowsecondary
        case .thick:
            return .yellowbgthick
        case .thin:
            return .yellowbgthin
        }
    case .green:
        switch style {
        case .primary:
            return .greenprimary
        case .secondary:
            return .greensecondary
        case .thick:
            return .greenbgthick
        case .thin:
            return .greenbgthin
        }
    case .blue:
        switch style {
        case .primary:
            return .blueprimary
        case .secondary:
            return .bluesecondary
        case .thick:
            return .bluebgthick
        case .thin:
            return .bluebgthin
        }
    case .purple:
        switch style {
        case .primary:
            return .purpleprimary
        case .secondary:
            return .purplesecondary
        case .thick:
            return .purplebgthick
        case .thin:
            return .purplebgthin
        }
    case .pink:
        switch style {
        case .primary:
            return .pinkprimary
        case .secondary:
            return .pinksecondary
        case .thick:
            return .pinkbgthick
        case .thin:
            return .pinkbgthin
        }
    }
}
