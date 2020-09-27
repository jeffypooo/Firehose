//
//  Text.swift
//  Firehose
//
//  Created by Jefferson Jones on 8/15/20.
//  Copyright © 2020 Jefferson Jones. All rights reserved.
//

import Foundation
import SwiftUI

extension Text {
    func lightKerning() -> Text {
        return kerning(0.8)
    }
    
    func mediumKerning() -> Text {
        return kerning(1.0)
    }
    
    func heavyKerning() -> Text {
        return kerning(1.8)
    }
}

extension Text {
    func largeTitleStyle() -> Text {
        return fontWeight(.semibold)
            .font(.largeTitle)
            .heavyKerning()
    }
}
