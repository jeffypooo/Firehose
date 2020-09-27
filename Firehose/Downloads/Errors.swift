//
// Created by Jefferson Jones on 9/27/20.
// Copyright (c) 2020 Jefferson Jones. All rights reserved.
//

import Foundation

enum FirehoseDownloadError: Error {
  case invalidUrl
  case httpError(source: Error)
  case rangesNotSupported
}
