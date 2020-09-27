//
//  Colors.swift
//  Firehose
//
//  Created by Jefferson Jones on 8/15/20.
//  Copyright © 2020 Jefferson Jones. All rights reserved.
//

import Foundation
import SwiftUI

extension Color {
    static var backgroundLight: Color {
        return .init("backgroundLight")
    }
    static var backgroundDark: Color {
        return .init("backgroundDark")
    }
    static var foregroundLight: Color {
        return .init("foregroundLight")
    }
    static var foregroundDark: Color {
        return .init("foregroundDark")
    }
    static var accentLight: Color {
        return .init("accent")
    }
}

extension Gradient {
    static var backgroundLightDark: Gradient {
        return Gradient(colors: [.backgroundLight, .backgroundDark])
//        return Gradient(colors: [.backgroundDark, .backgroundLight, .backgroundDark, .backgroundLight])
    }
    
    static var foregroundLightDark: Gradient {
        return Gradient(colors: [.foregroundLight, .foregroundDark])
    }
}
