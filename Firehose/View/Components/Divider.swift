//
//  Divider.swift
//  Firehose
//
//  Created by Jefferson Jones on 8/16/20.
//  Copyright © 2020 Jefferson Jones. All rights reserved.
//

import Foundation
import SwiftUI

func horizontalDivider(padding: CGFloat = 4) -> some View {
    return Divider().padding(.vertical, padding)
}

func verticalDivider(padding: CGFloat = 4) -> some View {
    return Divider().padding(.horizontal, padding)
}
