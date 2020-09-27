//
// Created by Jefferson Jones on 9/26/20.
// Copyright (c) 2020 Jefferson Jones. All rights reserved.
//

import Foundation
import Combine
import CleanroomLogger

class DownloadController {

  @Published var downloads: [MultiPartDownload] = []

  private init() {
  }

  func getDownloadMetadata(
      url string: String,
      onComplete: @escaping (DownloadMetadata) -> (),
      onError: @escaping (FirehoseDownloadError) -> ()
  ) {
    guard let request = URLRequest.head(url: string) else {
      onError(FirehoseDownloadError.invalidUrl)
      return
    }
    URLSession.shared.dataTask(with: request) { _, resp, err in
      if let error = err {
        onError(FirehoseDownloadError.httpError(source: error))
        return
      }
      let httpResp = resp as! HTTPURLResponse
      let metadata = DownloadMetadata(
          acceptsRanges: httpResp.value(forHTTPHeaderField: "Accept-Ranges") == "bytes",
          mimeType: httpResp.value(forHTTPHeaderField: "Content-Type") ?? "unknown",
          contentLength: Int64(httpResp.value(forHTTPHeaderField: "Content-Length") ?? "0")!
      )
      onComplete(metadata)
    }.resume()
  }

  func getDownload(
      url string: String,
      numConnections: Int,
      onComplete: @escaping (MultiPartDownload) -> (),
      onError: @escaping (FirehoseDownloadError) -> ()
  ) {
    getDownloadMetadata(
        url: string,
        onComplete: { metadata in
          guard metadata.acceptsRanges else {
            onError(.rangesNotSupported)
            return
          }
          let download = MultiPartDownload(
              url: URL(string: string)!,
              metadata: metadata,
              numConnections: numConnections
          )
          self.downloads.append(download)
          onComplete(download)
        },
        onError: onError
    )
  }
}

extension DownloadController {
  static let shared = DownloadController()
}

