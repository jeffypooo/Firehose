//
// Created by Jefferson Jones on 9/26/20.
// Copyright (c) 2020 Jefferson Jones. All rights reserved.
//

import Foundation

struct Version {
  static var shortVersionString: String {
    (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "?"
  }
  static var buildNumber: String {
    (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? "?"
  }
}
